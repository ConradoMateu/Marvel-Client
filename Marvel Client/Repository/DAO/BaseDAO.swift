//
//  BaseDAO.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 5/3/22.
//

import Foundation
import UIKit

protocol BaseDAO {

    associatedtype Entity
    associatedtype Storage

    var storage: Storage { get }
    init(storage: Storage)

    /// Updates an entity if it exists in the model, otherwise, the entity will be created
    func addReplacing(_ entity: Entity) async -> Entity
    func getAll() async throws -> [Entity]
    func delete(_ entity: Entity) async throws -> Bool
    func deleteAll() async throws -> Bool
}
