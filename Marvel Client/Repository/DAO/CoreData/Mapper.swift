//
//  Mapper.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 5/3/22.
//

import Foundation

extension Heroe {

    func encode(entity: HeroeDTO) {
        self.id = entity.id
        self.name = entity.name
        self.heroeDescription = entity.description
        self.isFavorite = entity.isFavorite
//        self.comics = NSSet(array: entity.comics)

    }

    func decode() -> HeroeDTO {
        return HeroeDTO(id: self.id!,
                        name: self.name!,
                        description: self.heroeDescription ?? "",
                        imageURLString: self.imageURLString ?? "", comics: self.comics.array(type: ComicDTO.self),
                        isFavorite: self.isFavorite)

    }
}

extension Comic {
    func encode(entity: ComicDTO) {
        self.id = entity.id
        self.name = entity.name
    }

    func decode() -> ComicDTO {
        return ComicDTO(id: self.id!, name: self.name ?? "")

    }
}
