//
//  DependencyInjector.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 8/3/22.
//

import Foundation
import SwiftUI

struct DependencyInjector {
    static func getHeroesRepository() -> HeroesRepository {
        return HeroesRepository(service: HeroeService(), dao: HeroesDao())
    }

    static func fakeRepository() -> HeroesRepository {
        return HeroesRepository(service: FakeHeroService(), dao: FakeQueryDAO())
    }

}

class FakeQueryDAO: QueryDAO {
    func addReplacing(_ entity: HeroDTO) async -> HeroDTO {
        return HeroDTO.random
    }
    func getAll() async throws -> [HeroDTO] {
        return [HeroDTO.random]
    }
    func delete(_ entity: HeroDTO) async throws -> Bool {
        return true
    }
    func deleteAll() async throws -> Bool {
        return true
    }

}

class FakeHeroService: HeroeServiceProtocol {

    @JSONFile(named: "response")
     var response: HeroeResponseDTO?

    func getHeroes(offset: String = "0", limit: String = "10") async throws -> HeroeResponseDTO {

        // Delay for 3 seconds
        try await Task.sleep(nanoseconds: 3_000_000_000)
        return response!
    }
}
