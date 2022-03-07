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
        self.imageURLString = "\(entity.imagePath).\(entity.imageExtension)"

        var comicObjects = Set<Comic>()
        for comic in entity.comics {
            let newComic: Comic = Comic(context: self.managedObjectContext!)
            newComic.encode(entity: comic)
            comicObjects.insert(newComic)
        }

        // Ads Reference between Hero <--> Comics
        self.addToComics(comicObjects)
    }

    func decode() -> HeroeDTO {
        return HeroeDTO(id: self.id!,
                        name: self.name!,
                        description: self.heroeDescription ?? "",
                        imageURLString: self.imageURLString ?? "",
                        comics: Array(self.comics ?? [] ).map { $0.decode() },
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
