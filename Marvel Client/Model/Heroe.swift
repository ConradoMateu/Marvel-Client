//
//  Heroe.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 3/3/22.
//

import Foundation

struct Heroe: Codable, Identifiable {
    var id: UUID = UUID()
    let name: String
    let description: String

    let thumbnail: Thumbnail

    /// Adding CodingKeys in order to Avoid `id` from being decoded
    private enum CodingKeys: String, CodingKey {
        case name, description, thumbnail
    }
}

extension Heroe {
    var imageURL: URL {
        let urlString = String("\(thumbnail.path).\(thumbnail.thumbnailExtension.rawValue)")
        return URL(string: urlString)!
    }
}
