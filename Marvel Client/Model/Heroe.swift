//
//  Heroe.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 3/3/22.
//

import Foundation

struct Heroe: Codable, Identifiable, Hashable {

    var id: UUID = UUID()
    var isFavorite: Bool = false
    let name: String
    let description: String
    let thumbnail: Thumbnail
    let comicResponse: ComicResponse

    static func == (lhs: Heroe, rhs: Heroe) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.thumbnail == rhs.thumbnail
    }

    /// Adding CodingKeys in order to Avoid `id` from being decoded
    private enum CodingKeys: String, CodingKey {
        case name, description, thumbnail, comicResponse = "comics"
    }
}

extension Heroe {
    var imageURL: URL {
        let urlString = String("\(thumbnail.path).\(thumbnail.thumbnailExtension.rawValue)")
        return URL(string: urlString)!
    }
}
