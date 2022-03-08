//
//  Mapper.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 5/3/22.
//

import Foundation

extension Hero {

    func encode(entity: HeroDTO) {
        self.id = entity.id
        self.name = entity.name
        self.heroDescription = entity.description
        self.isFavorite = entity.isFavorite
        self.imageURLString = "\(entity.imagePath).\(entity.imageExtension)"

        // Adding only if creating struct
        if self.comics?.count == 0 {
            var comicObjects = Set<Comic>()
            for comic in entity.comics {
                let newComic: Comic = Comic(context: self.managedObjectContext!)
                newComic.encode(entity: comic)
                comicObjects.insert(newComic)
            }

            // Ads Reference between Hero <--> Comics
            self.addToComics(comicObjects)
        }
    }

    func decode() -> HeroDTO {
        return HeroDTO(id: self.id!,
                        name: self.name!,
                        description: self.heroDescription ?? "",
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
