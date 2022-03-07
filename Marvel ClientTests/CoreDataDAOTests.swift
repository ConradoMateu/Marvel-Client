//
//  CoreDataDAOTests.swift
//  Marvel ClientTests
//
//  Created by Conrado Mateu Gisbert on 6/3/22.
//

import XCTest
@testable import Marvel_Client
class CoreDataDAOTests: XCTestCase {

    var storage: CoreDataStorage!

    @JSONFile(named: "response")
    var response: HeroeResponseDTO?

    var heroesWithComics: [HeroeDTO] {

        guard let safeHeroes = response?.heroes else {
            fatalError("JSONData Could not be decoded")
        }

        return safeHeroes.filter { $0.comics.count != 0 }
    }

    override func setUpWithError() throws {

        // Set in memory for testing purposes to do not persist in SQL DB
        self.storage = CoreDataStorage(isInMemoryStore: true)
    }

    func testShouldCreateEntityInDB() async throws {
        let heroesDAO = HeroesDao(storage: storage)

//        for hero in  {
            _ = try await heroesDAO.addReplacing(heroesWithComics[0])
//        }

        print("API: \(heroesWithComics[0].hashValue)")
        print("API: \(heroesWithComics[0].hashValue)")
        print("API: \(heroesWithComics[0].id)")

        let dbHeroes = try await heroesDAO.getAll()

        for (index, element) in dbHeroes.enumerated() {
            print("DBHEROES: \(element.id)")
            print("APIHEROES: \(heroesWithComics[0].id)")
            print("DBHEROES: \(element.name)")
            print("APIHEROES: \(heroesWithComics[0].name)")
          assert(dbHeroes[index] == heroesWithComics[index])
        }
    }

    func testShouldCreateComicInDB() async throws {
        let randomComic = response?.heroes.randomElement()?.comics.randomElement()
        let comicsDAO = ComicsDao(storage: storage)

        await comicsDAO.addReplacing(randomComic!)

        var insertedComic = try await comicsDAO.getAll()

        print("Inserted HERO: \(insertedComic)")
        var newReplacementComic = ComicDTO(id: randomComic!.id, name: "Emgyyy")

        await comicsDAO.addReplacing(newReplacementComic)

        var aaaaa = try await comicsDAO.getAll()

        print("Inserted HERO: \(aaaaa)")
    }
}
