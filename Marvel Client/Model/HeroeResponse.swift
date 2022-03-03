//
//  HeroeResponse.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 3/3/22.
//

import Foundation

struct HeroeResponse: Codable {
    let data: DataClass
}

struct DataClass: Codable {
    let heroes: [Heroe]
    enum CodingKeys: String, CodingKey {
        case heroes = "results"
    }
}
