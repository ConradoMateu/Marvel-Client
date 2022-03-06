//
//  ComicDAO.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 6/3/22.
//

import Foundation
import CoreData

class ComicsDao: CoreDataDAO<ComicDTO, Comic> {

    override func encode(entity: ComicDTO, into object: inout Comic) {
        object.encode(entity: entity)
    }

    override func decode(object: Comic) -> Entity {
        return object.decode()
    }

    override var sortDescriptors: [NSSortDescriptor]? {
        return [
            NSSortDescriptor(keyPath: \Comic.name, ascending: true)
        ]
    }
}
