//
//  Mapper.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 5/3/22.
//

import Foundation

extension Heroe {

    func encode(entity e: HeroeDTO) {
        self.id = e.id
        self.name = e.name
        self.heroeDescription = e.description
        self.isFavorite = e.isFavorite
        self.comics = NSSet(arrayLiteral: e.comics)
    }

    func decode() -> HeroeDTO {
        return HeroeDTO(id: self.id!, name: self.name!, description: self.heroeDescription!, imageURLString: self.imageURLString!, comics: self.comics.array(of: ComicDTO.self), isFavorite: self.isFavorite)

    }
}
