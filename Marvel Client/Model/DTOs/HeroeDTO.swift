//
//  Heroe.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 3/3/22.
//

import Foundation
import BackedCodable

/// Using BackedDecodable in order to decode nested JSON with property wrappers
struct HeroeDTO: BackedDecodable, Identifiable, Hashable {

    var id: UUID = UUID()
    var isFavorite: Bool = false

    @Backed()
    var name: String

    @Backed()
    var description: String

    /// Uses custom path for nested JSON
    @Backed(Path("thumbnail", "path"))
    var imagePath: String

    @Backed(Path("thumbnail", "extension"))
    var imageExtension: String

    @Backed(Path("comics", "items"))
    var comics: [ComicDTO]

    /// Default init for Backed Framework
    init(_: DeferredDecoder) { }

    init(id: UUID, name: String, description: String, imageURLString: String, comics: [ComicDTO], isFavorite: Bool = false) {
        self.id = id
        self.$name = name
        self.$description = description
        self.$imagePath = imageURLString.path()
        self.$imageExtension = imageURLString.fileExtension()
        self.$comics = comics
        self.isFavorite = isFavorite
    }

    static func == (lhs: HeroeDTO, rhs: HeroeDTO) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.imageURL == rhs.imageURL
    }

}

extension HeroeDTO {
    var imageURL: URL {
        let urlString = String("\(imagePath).\(imageExtension)")
        return URL(string: urlString)!
    }
}

extension String {

    func path() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
}
