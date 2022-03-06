//
//  CoreDataDAO.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 5/3/22.
//

import Foundation
import CoreData

enum CoreDataError: Error {
    case readError(String)
    case writeError(String)
    case deleteError(String)
    case inconsistentState
}

protocol CoreDataStorable {
    var id: UUID { get set }
}

class CoreDataDAO<Entity: CoreDataStorable, ManagedObject: NSManagedObject>: BaseDAO {
    typealias Storage = CoreDataStorage

    var storage: Storage

    required init(storage: Storage = CoreDataStorage.shared) {
        self.storage = storage
    }

    /// Generates Element Request for finding a specific object in database
    func generateElementRequest(_ entity: Entity) throws -> NSFetchRequest<ManagedObject> {
        // swiftlint:disable:next force_cast
        let request = ManagedObject.fetchRequest() as! NSFetchRequest<ManagedObject>
        request.predicate = NSPredicate(format: "id = %@", entity.id.uuidString)
        return request
    }

    /// Generates Array Request for retrieving all existing objects in database
    func generateArrayRequest() -> NSFetchRequest<ManagedObject> {
        // swiftlint:disable:next force_cast
        let request: NSFetchRequest<ManagedObject> = ManagedObject.fetchRequest() as! NSFetchRequest<ManagedObject>

        if let sortDescriptors = self.sortDescriptors {
            request.sortDescriptors = sortDescriptors
        }
        return request
    }

    // This function adds an Entity if does not exists on the model or on the contrary updates it
    func addReplacing(_ entity: Entity) async -> Entity {

        let backgroundContext = storage.taskContext

        var updatedEntity: Entity!
        await backgroundContext.perform {

            let results = try? backgroundContext.fetch(self.generateElementRequest(entity))

            var coreDataObject: ManagedObject

            if results?.count == 0 {
               // Creating Entity
                coreDataObject = ManagedObject(context: backgroundContext)
            } else {
               // Updating Entity
                coreDataObject = results!.first!
            }
            self.encode(entity: entity, into: &coreDataObject)
            self.storage.saveContext(backgroundContext)
            updatedEntity = self.decode(object: coreDataObject)
        }

        return updatedEntity
    }

    func getAll() async throws -> [Entity] {

        let backgroundContext = storage.taskContext
        var resultCollection: [Entity]!

        try await backgroundContext.perform {

            do {
                resultCollection = try backgroundContext.fetch(self.generateArrayRequest()).map {
                    self.decode(object: $0)
                }
            } catch {
                throw CoreDataError.readError("Data Could Not Be Read")
            }

        }

        return resultCollection

    }

    func delete(_ entity: Entity) async throws -> Bool {

        let backgroundContext = storage.taskContext
        try await backgroundContext.perform {

                let result = try backgroundContext.fetch(self.generateElementRequest(entity))

                if let object = result.last {
                    guard result.count == 1 else {
                        throw CoreDataError.inconsistentState
                    }
                    backgroundContext.delete(object)
                    self.storage.saveContext(backgroundContext)
                } else {
                    throw CoreDataError.readError("Entity Could Not Be Read")
                }

        }

        return true
    }

    func deleteAll() async throws -> Bool {

        let backgroundContext = storage.taskContext

        try await backgroundContext.perform {
            do {
                try backgroundContext.fetch(self.generateArrayRequest()).forEach { entity in
                    backgroundContext.delete(entity)
                }
                self.storage.saveContext(backgroundContext)
            } catch {
                throw CoreDataError.readError("Data Could Not Be Read")
            }

        }

        return true

    }

    // MARK: - OVERRIDABLE
    var sortDescriptors: [NSSortDescriptor]? {
        return nil
    }

    func encode(entity: Entity, into object: inout ManagedObject) {
        fatalError("""
                    no encoding provided \(String(describing: Entity.self)) - \(String(describing: ManagedObject.self))
                    """)
    }

    func decode(object: ManagedObject) -> Entity {
        fatalError("""
                   no decoding provided between core data entity:
                   \(String(describing: ManagedObject.self))
                   and domain entity: \(String(describing: Entity.self))
                   """)
    }
}
