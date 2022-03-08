//
//  CoreDataStorage.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 5/3/22.
//

import Foundation
import CoreData

struct CoreDataStorage: Storage {

    typealias PersistentContainer = NSPersistentContainer
    typealias ManagedContext = NSManagedObjectContext

    static let shared = CoreDataStorage()

    let persistentContainer: NSPersistentContainer

    var mainContext: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }

    var taskContext: ManagedContext {

        let context = self.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        context.undoManager = nil

        return context
    }

    init(isInMemoryStore: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "Marvel_Client")
        if isInMemoryStore {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        persistentContainer.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    func saveContext() {
        let context = mainContext

        // Save all the changes just made and reset the context to free the cache.
        context.performAndWait {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            // Reset the context to clean up the cache and low the memory footprint.
            context.reset()
        }
    }

    func saveContext(_ context: NSManagedObjectContext) {
        guard context != mainContext else {
            saveContext()
            return
        }

        context.performAndWait {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }

            self.saveContext(self.mainContext)
        }
    }
}
