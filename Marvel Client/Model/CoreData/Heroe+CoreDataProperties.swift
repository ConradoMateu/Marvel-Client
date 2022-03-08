//
//  Heroe+CoreDataProperties.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 7/3/22.
//
//

import Foundation
import CoreData

extension Heroe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Heroe> {
        return NSFetchRequest<Heroe>(entityName: "Heroe")
    }

    @NSManaged public var heroeDescription: String?
    @NSManaged public var id: String?
    @NSManaged public var imageURLString: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var name: String?
    @NSManaged public var comics: Set<Comic>?

}

// MARK: Generated accessors for comics
extension Heroe {

    @objc(addComicsObject:)
    @NSManaged public func addToComics(_ value: Comic)

    @objc(removeComicsObject:)
    @NSManaged public func removeFromComics(_ value: Comic)

    @objc(addComics:)
    @NSManaged public func addToComics(_ values: Set<Comic>)

    @objc(removeComics:)
    @NSManaged public func removeFromComics(_ values: Set<Comic>)

}

extension Heroe: Identifiable {

}
