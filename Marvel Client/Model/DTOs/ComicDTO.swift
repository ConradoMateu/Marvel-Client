//
//  Comic.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 3/3/22.
//

import Foundation

struct ComicDTO: Codable, Hashable, Identifiable, CoreDataStorable {
    var id: String = UUID().uuidString

    let name: String
    private enum CodingKeys: String, CodingKey {
        case name
    }
}
