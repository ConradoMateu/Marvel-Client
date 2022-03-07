//
//  Comic+CoreDataProperties.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 7/3/22.
//
//

import Foundation
import CoreData

extension Comic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comic> {
        return NSFetchRequest<Comic>(entityName: "Comic")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var ofHeroe: Heroe?

}

extension Comic: Identifiable {

}
