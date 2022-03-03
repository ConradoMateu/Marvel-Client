//
//  Comic.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 3/3/22.
//

import Foundation

struct ComicResponse: Codable, Hashable {
    let comics: [Comic]
    private enum CodingKeys: String, CodingKey {
        case comics = "items"
    }
}

struct Comic: Codable, Hashable, Identifiable {
    var id: UUID = UUID()

    let name: String
    private enum CodingKeys: String, CodingKey {
        case name
    }
}
