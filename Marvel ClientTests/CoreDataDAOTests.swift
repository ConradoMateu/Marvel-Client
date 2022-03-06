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
        self.storage = CoreDataStorage(isInMemoryStore: true)
    }

    func testShouldCreateEntityInDB() async throws {
        let randomHeroe = response?.heroes.randomElement()!
        let heroesDAO = HeroesDao(storage: storage)

        await heroesDAO.update(randomHeroe!)

        let insertedHeroe = try await heroesDAO.getAll()

        print("Inserted HERO: \(insertedHeroe)")
    }
}
