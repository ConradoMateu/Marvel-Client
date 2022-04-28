//
//  HeroRepositoryTests.swift
//  Marvel ClientTests
//
//  Created by Conrado Mateu Gisbert on 9/3/22.
//

import XCTest
@testable import Marvel_Client
import OHHTTPStubs
import OHHTTPStubsSwift

class HeroRepositoryTests: XCTestCase {
    var heroService = HeroeService()

    @JSONFile(named: "response")
    var response: HeroeResponseDTO?

    override func tearDown() async throws {
        let dao = HeroesDao(storage: CoreDataStorage.sharedTest)
        let heroesInDB = try await dao.getAll()

        for hero in heroesInDB {
            _ = try await dao.delete(hero)
        }
    }

    func testShouldCallTheAPIWhenNoDataIsCached() async throws {

        // GIVEN an empty database
        let dao = HeroesDao(storage: CoreDataStorage.sharedTest)
        let heroRepository = HeroesRepository(service: heroService, dao: dao)
        let heroesInDB = try await dao.getAll()

        assert(heroesInDB.isEmpty)

        stub(condition: isHost("gateway.marvel.com")) { _ in

            let stubPath = OHPathForFile("response.json", JSONReusable.self)
            return fixture(filePath: stubPath!, headers: ["Content-Type": "application/json"])
        }

        // WHEN
        let newHeroes = try await heroRepository.getHeroes(limit: 0, page: 1, offset: 0)

        // THEN check that an API call was retrieving heroes
        assert(!newHeroes.isEmpty)

    }

    func testShouldReturnCachedDataWhenNoPaginationIsTriggered() async throws {

        let dao = HeroesDao(storage: CoreDataStorage.sharedTest)
        let heroRepository = HeroesRepository(service: heroService, dao: dao)
        guard let safeHeros = response?.heroes[0..<5] else {
            XCTFail("Could not return decode response")
            return
        }

        for hero in safeHeros {
            _ = await dao.addReplacing(hero)
        }

        let heroesInDB = try await dao.getAll()

        // GIVEN a populated DB to trigger Pagination
        assert(!heroesInDB.isEmpty)

        // WHEN cachedHeroes.count < limit * page should so cached data
        let newHeroes = try await heroRepository.getHeroes(limit: 2, page: 1, offset: 0)

        // THEN should returned just the hero from DB
        assert(newHeroes.count <= heroesInDB.count)

    }

    func testShouldCallTheAPIWhenPaginationIsTriggered() async throws {

        let dao = HeroesDao(storage: CoreDataStorage.sharedTest)
        let heroRepository = HeroesRepository(service: heroService, dao: dao)

        guard let safeHero = response?.heroes.first else {
            XCTFail("Could not return decode response")
            return
        }
        _ = await dao.addReplacing(safeHero)
        let heroesInDB = try await dao.getAll()

        // GIVEN a populated DB to trigger Pagination
        assert(!heroesInDB.isEmpty)

        stub(condition: isHost("gateway.marvel.com")) { _ in

            let stubPath = OHPathForFile("response.json", JSONReusable.self)
            return fixture(filePath: stubPath!, headers: ["Content-Type": "application/json"])
        }

        // WHEN triggered pagination (cachedHeroes.count / limit) < page
        let newHeroes = try await heroRepository.getHeroes(limit: 10, page: 1, offset: 10)

        // THEN check that an API call was made + the union of the other cached hero from DB
        assert(newHeroes.count == 11)

    }
}
