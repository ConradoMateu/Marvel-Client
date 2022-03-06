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
    override func setUpWithError() throws {
        self.storage = CoreDataStorage()
    }

    func testShouldCreateEntityInDB() async throws {
        _ = response?.heroes.randomElement()!
        let heroesDAO = HeroesDao(storage: storage)

        for heroe in response!.heroes {
            _ = await heroesDAO.addReplacing(heroe)
        }

            let insertedHeroe = try await heroesDAO.getAll()

    //        assert(randomHeroe?.name == insertedHeroe.first?.name)
            print("Inserted HERO: \(insertedHeroe)")

//        await heroesDAO.addReplacing(randomHeroe!)

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
