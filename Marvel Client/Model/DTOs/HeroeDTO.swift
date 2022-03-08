//
//  Heroe.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 3/3/22.
//

import Foundation
import BackedCodable

/// Using BackedDecodable in order to decode nested JSON with property wrappers
struct HeroeDTO: BackedDecodable, Identifiable, Hashable, CoreDataStorable, Comparable {

    var id: String = UUID().uuidString
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
    init(_: DeferredDecoder) {  }

    private enum CodingKeys: String, CodingKey {
        case id
    }

    // swiftlint:disable:next line_length
    init(id: String, name: String, description: String, imageURLString: String, comics: [ComicDTO], isFavorite: Bool = false) {
//        self.id = id
        self.id = id
        self.$name = name
        self.$description = description
        let urlExtension = imageURLString.fileExtension()

        self.$imageExtension = urlExtension

        self.$imagePath = imageURLString.replacingOccurrences(of: ".\(urlExtension)", with: "")
        self.$comics = comics
        self.isFavorite = isFavorite
    }

    static func == (lhs: HeroeDTO, rhs: HeroeDTO) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.imageURL == rhs.imageURL &&
        lhs.isFavorite == rhs.isFavorite &&
        lhs.description == rhs.description &&
        lhs.comics.count == rhs.comics.count
    }

    static func < (lhs: HeroeDTO, rhs: HeroeDTO) -> Bool {
        lhs.name < rhs.name
    }

}

extension HeroeDTO {
    var imageURL: URL {
        let urlString = String("\(imagePath).\(imageExtension)")
        return URL(string: urlString)!
    }

    static var random: HeroeDTO {
        HeroeDTO(id: UUID().uuidString,
                 name: "This hero is a test",
                 description: "This is a description for a random user",
                 imageURLString: "http://i.annihil.us/u/prod/marvel/i/mg/3/80/4c00358ec7548.jpg",
                 comics: [],
                 isFavorite: false)
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
