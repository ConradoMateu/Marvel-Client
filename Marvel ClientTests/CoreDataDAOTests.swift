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

    var hero: HeroeDTO!

    override func setUpWithError() throws {

        hero = heroesWithComics.randomElement()
        // Set in memory for testing purposes to do not persist in SQL DB
        self.storage = CoreDataStorage(isInMemoryStore: true)
    }

    func testShouldCreateHeroeInDB() async throws {
        let heroesDAO = HeroesDao(storage: storage)

        _ = await heroesDAO.addReplacing(hero)

        let dbHeroes = try await heroesDAO.getAll()

        assert(dbHeroes.first == hero)
    }

    func testShouldReplaceHeroeInDB() async throws {
        let heroesDAO = HeroesDao(storage: storage)

        _ = await heroesDAO.addReplacing(hero)

        let newHero = HeroeDTO(id: hero.id,
                               name: "Another Name To Test",
                               description: "Another Description",
                               imageURLString: "http://i.annihil.us.jpg",
                               comics: hero.comics,
                               isFavorite: hero.isFavorite)

        _ = await heroesDAO.addReplacing(newHero)
        let dbHeroes = try await heroesDAO.getAll()

        assert(dbHeroes.first == newHero)
    }

    func testShouldDeleteSingleHero() async throws {
        let heroesDAO = HeroesDao(storage: storage)
        let someHeroes = heroesWithComics[0...2]

        for hero in someHeroes {
            _ = await heroesDAO.addReplacing(hero)
        }

        _  = try await heroesDAO.delete(someHeroes.first!)

        let dbHeroes = try await heroesDAO.getAll()

        assert(someHeroes.count - 1 == dbHeroes.count)
        assert(!dbHeroes.contains(someHeroes.first!))
    }

    func testShouldAddComicInDB() async throws {
        let randomComic: ComicDTO! = hero.comics.randomElement()
        let comicsDAO = ComicsDao(storage: storage)

        _ = await comicsDAO.addReplacing(randomComic)
        let result = try await comicsDAO.getAll()

        assert(result.first == randomComic)
    }

    func testShouldRepalceComicInDB() async throws {
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
}
