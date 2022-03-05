//
//  Storage.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 5/3/22.
//

import Foundation
import UIKit
import CoreData

/// Abstraction of Storage Layer in order to be maintainable in the future (Realm, UserDefault)
public protocol Storage {
    associatedtype PersistentContainer
    associatedtype ManagedContext

    var persistentContainer: PersistentContainer { get }
    var mainContext: ManagedContext { get }
    var taskContext: ManagedContext { get }

    func saveContext()
    func saveContext(_ context: ManagedContext)

    init(isInMemoryStore: Bool)
}
