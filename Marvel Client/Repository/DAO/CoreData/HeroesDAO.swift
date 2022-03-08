//
//  HeroesDAO.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 5/3/22.
//

import Foundation
import CoreData

protocol QueryDAO {
    func addReplacing(_ entity: HeroDTO) async -> HeroDTO
    func getAll() async throws -> [HeroDTO]
    func delete(_ entity: HeroDTO) async throws -> Bool
    func deleteAll() async throws -> Bool

}

class HeroesDao: CoreDataDAO<HeroDTO, Hero>, QueryDAO {

    override func encode(entity: HeroDTO, into object: inout Hero) {
        object.encode(entity: entity)
    }

    override func decode(object: Hero) -> Entity {
        return object.decode()
    }

    override var sortDescriptors: [NSSortDescriptor]? {
        return [
            NSSortDescriptor(keyPath: \Hero.isFavorite, ascending: false),
            NSSortDescriptor(keyPath: \Hero.name, ascending: true)
        ]
    }
}
