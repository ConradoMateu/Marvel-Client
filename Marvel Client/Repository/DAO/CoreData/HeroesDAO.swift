//
//  HeroesDAO.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 5/3/22.
//

import Foundation
import CoreData

class MoviesDao : CoreDataDAO<HeroeDTO, Heroe> {

    override func encode(entity: HeroeDTO, into object: inout Heroe) {
        object.encode(entity: entity)
    }

    override func decode(object: Heroe) -> Entity {
        return object.decode()
    }

    override var sortDescriptors: [NSSortDescriptor]? {
        return [
            NSSortDescriptor(keyPath: \Heroe.name, ascending: true)
        ]
    }
}
