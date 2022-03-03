//
//  Thumbnail.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 3/3/22.
//

import Foundation

struct Thumbnail: Codable, Hashable {
    let path: String
    let thumbnailExtension: Extension

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

enum Extension: String, Codable {
    case jpg
}
