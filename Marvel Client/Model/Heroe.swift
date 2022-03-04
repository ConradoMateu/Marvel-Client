//
//  Heroe.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 3/3/22.
//

import Foundation
import BackedCodable

struct Heroe: BackedDecodable, Identifiable, Hashable {

    var id: UUID = UUID()
    var isFavorite: Bool = false

    @Backed()
    var name: String

    @Backed()
    var description: String

    @Backed(Path("thumbnail", "path"))
    var imagePath: String

    @Backed(Path("thumbnail", "extension"))
    var imageExtension: String

    @Backed(Path("comics", "items"))
    var comics: [Comic]

    init(_: DeferredDecoder) { }

    static func == (lhs: Heroe, rhs: Heroe) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.imageURL == rhs.imageURL
    }

}

extension Heroe {
    var imageURL: URL {
        let urlString = String("\(imagePath).\(imageExtension)")
        return URL(string: urlString)!
    }
}
