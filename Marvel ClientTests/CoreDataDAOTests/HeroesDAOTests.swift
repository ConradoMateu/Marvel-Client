//
//  CoreDataDAOTests.swift
//  Marvel ClientTests
//
//  Created by Conrado Mateu Gisbert on 6/3/22.
//

import XCTest
@testable import Marvel_Client
class HeroesDAOTests: XCTestCase {

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

    func testShouldCreateHeroInDB() async throws {
        // GIVEN
        let heroesDAO = HeroesDao(storage: storage)

        // WHEN
        _ = await heroesDAO.addReplacing(hero)
        let dbHeroes = try await heroesDAO.getAll()

        // THEN
        assert(dbHeroes.first == hero)
    }

    func testShouldReplaceHeroInDB() async throws {
        // GIVEN
        let heroesDAO = HeroesDao(storage: storage)

        _ = await heroesDAO.addReplacing(hero)

        let newHero = HeroeDTO(id: hero.id,
                               name: "Another Name To Test",
                               description: "Another Description",
                               imageURLString: "http://i.annihil.us.jpg",
                               comics: hero.comics,
                               isFavorite: hero.isFavorite)

        // WHEN
        _ = await heroesDAO.addReplacing(newHero)
        let dbHeroes = try await heroesDAO.getAll()

        // THEN
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

    func testShouldDeleteAllHeroes() async throws {
        let heroesDAO = HeroesDao(storage: storage)
        let someHeroes = heroesWithComics[0...2]

        for hero in someHeroes {
            _ = await heroesDAO.addReplacing(hero)
        }

        for hero in someHeroes {
            _  = try await heroesDAO.delete(hero)
        }

        let dbHeroes = try await heroesDAO.getAll()

        assert(dbHeroes.isEmpty)
    }
}
