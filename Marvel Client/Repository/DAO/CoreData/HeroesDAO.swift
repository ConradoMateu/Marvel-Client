//
//  HeroesDAO.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 5/3/22.
//

import Foundation
import CoreData

protocol QueryDAO {
    func addReplacing(_ entity: HeroeDTO) async -> HeroeDTO
    func getAll() async throws -> [HeroeDTO]
    func delete(_ entity: HeroeDTO) async throws -> Bool
    func deleteAll() async throws -> Bool

}

class HeroesDao: CoreDataDAO<HeroeDTO, Heroe>, QueryDAO {

    override func encode(entity: HeroeDTO, into object: inout Heroe) {
        object.encode(entity: entity)
    }

    override func decode(object: Heroe) -> Entity {
        return object.decode()
    }

    override var sortDescriptors: [NSSortDescriptor]? {
        return [
            NSSortDescriptor(keyPath: \Heroe.isFavorite, ascending: false),
            NSSortDescriptor(keyPath: \Heroe.name, ascending: true)
        ]
    }
}
