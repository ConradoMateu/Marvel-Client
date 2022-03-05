//
//  CoreDataDAO.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 5/3/22.
//

import Foundation
import CoreData

enum CoreDataError : Error {
    case readError(String)
    case writeError(String)
    case deleteError(String)
    case inconsistentState
}

protocol CoreDataStorable {
    var id: UUID { get set }
}

class CoreDataDAO<T : CoreDataStorable, ManagedObject: NSManagedObject> : BaseDAO {
    typealias Storage = CoreDataStorage
    typealias Entity = CoreDataStorable
    
    var storage: Storage

    required init(storage: Storage = CoreDataStorage.shared) {
        self.storage = storage
    }

    // This function adds an Entity if does not exists on the model or on the contrary updates it
    func update(_ e: Entity) async -> Entity {

        let backgroundContext = storage.taskContext

        var updatedEntity: Entity!
        await backgroundContext.perform {

            let request = ManagedObject.fetchRequest() as! NSFetchRequest<ManagedObject>
            request.predicate = NSPredicate(format: "id = %@", e.id.uuidString)

                let results = try? backgroundContext.fetch(request)

            var entity: ManagedObject

            if results?.count == 0 {
               // Creating Entity
               entity = ManagedObject(context: backgroundContext)
            } else {
               // Updating Entity
                entity = results!.first!
            }
            self.encode(entity: e, into: &entity)
            self.storage.saveContext(backgroundContext)
            updatedEntity = self.decode(object: entity)
        }

        return updatedEntity
    }

    func getAll() async throws -> [Entity] {

        let backgroundContext = storage.taskContext
        var resultCollection: [Entity]!

        try await backgroundContext.perform {

            let request: NSFetchRequest<ManagedObject> = ManagedObject.fetchRequest() as! NSFetchRequest<ManagedObject>

            if let sortDescriptors = self.sortDescriptors {
                request.sortDescriptors = sortDescriptors
            }

            do {
                resultCollection = try backgroundContext.fetch(request).map { self.decode(object: $0) }
            } catch {
                throw CoreDataError.readError("Data Could Not Be Read")
            }

        }

        return resultCollection

    }


    func delete(_ e: Entity) async throws -> Bool {

        let backgroundContext = storage.taskContext
        try await backgroundContext.perform {

            let request = ManagedObject.fetchRequest() as! NSFetchRequest<ManagedObject>
            request.predicate = NSPredicate(format: "id = %@", e.id.uuidString)

                let result = try backgroundContext.fetch(request)

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

            let request: NSFetchRequest<ManagedObject> = ManagedObject.fetchRequest() as! NSFetchRequest<ManagedObject>

            if let sortDescriptors = self.sortDescriptors {
                request.sortDescriptors = sortDescriptors
            }

            do {

                try backgroundContext.fetch(request).forEach { entity in backgroundContext.delete(entity)}
                self.storage.saveContext(backgroundContext)
            } catch {
                throw CoreDataError.readError("Data Could Not Be Read")
            }

        }

        return true

    }

    // MARK: - OVERRIDABLE
    var sortDescriptors : [NSSortDescriptor]? {
        return nil
    }

    func encode(entity: Entity, into object: inout ManagedObject) {
        fatalError("no encoding provided between domain entity: \(String(describing: Entity.self)) and core data entity: \(String(describing: ManagedObject.self))")
    }

    func decode(object: ManagedObject) -> Entity {
        fatalError("no decoding provided between core data entity: \(String(describing: ManagedObject.self)) and domain entity: \(String(describing: Entity.self))")
    }
}
