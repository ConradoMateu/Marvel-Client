//
//  ComicsDAOTests.swift
//  Marvel ClientTests
//
//  Created by Conrado Mateu Gisbert on 7/3/22.
//

import Foundation

//
//  CoreDataDAOTests.swift
//  Marvel ClientTests
//
//  Created by Conrado Mateu Gisbert on 6/3/22.
//

import XCTest
@testable import Marvel_Client

class ComicsDAOTests: XCTestCase {

    var storage: CoreDataStorage!

    @JSONFile(named: "response")
    var response: HeroeResponseDTO?

    var heroesWithComics: [HeroDTO] {

        guard let safeHeroes = response?.heroes else {
            fatalError("JSONData Could not be decoded")
        }

        return safeHeroes.filter { $0.comics.count != 0 }
    }

    var hero: HeroDTO!

    override func setUpWithError() throws {

        hero = heroesWithComics.randomElement()
        // Set in memory for testing purposes to do not persist in SQL DB
        self.storage = CoreDataStorage(isInMemoryStore: true)
    }

    func testShouldAddComicInDB() async throws {
        let randomComic: ComicDTO! = hero.comics.randomElement()
        let comicsDAO = ComicsDao(storage: storage)

        _ = await comicsDAO.addReplacing(randomComic)
        let result = try await comicsDAO.getAll()

        assert(result.first == randomComic)
    }

    func testShouldReplaceComicInDB() async throws {
        let randomComic: ComicDTO! = hero.comics.randomElement()
        let comicsDAO = ComicsDao(storage: storage)

        _ = await comicsDAO.addReplacing(randomComic)

        let insertedComic = try await comicsDAO.getAll()

        print("Inserted HERO: \(insertedComic)")
        let newReplacementComic = ComicDTO(id: randomComic!.id, name: "Another name for testing")

        _ = await comicsDAO.addReplacing(newReplacementComic)

        let result = try await comicsDAO.getAll()

        assert(result.first == newReplacementComic)
    }

    func testShouldDeleteComicInDB() async throws {

        // GIVEN
        let randomComics: [ComicDTO]! = hero.comics
        let comicsDAO = ComicsDao(storage: storage)

        for comic in randomComics {
            _ = await comicsDAO.addReplacing(comic)
        }

        // WHEN
        let newReplacementComic = ComicDTO(id: randomComics.first!.id, name: "Another name for testing")
        _ = try await comicsDAO.delete(newReplacementComic)
        let dbComics = try await comicsDAO.getAll()

        // THEN
        assert(randomComics.count - 1 == dbComics.count)
        assert(!dbComics.contains(randomComics.first!))
    }

    func testShouldDeleteAllComicsInDB() async throws {

        // GIVEN
        let randomComics: [ComicDTO]! = hero.comics
        let comicsDAO = ComicsDao(storage: storage)

        for comic in randomComics {
            _ = await comicsDAO.addReplacing(comic)
        }

        // WHEN
        for comic in randomComics {
            _ = try await comicsDAO.delete(comic)
        }

        let dbComics = try await comicsDAO.getAll()

        // THEN
        assert(dbComics.isEmpty)
    }
}
