//
//  Comic.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 3/3/22.
//

import Foundation

struct ComicDTO: Codable, Hashable, Identifiable, CoreDataStorable {
    var id: UUID = UUID()

    let name: String
    private enum CodingKeys: String, CodingKey {
        case name
    }
}
