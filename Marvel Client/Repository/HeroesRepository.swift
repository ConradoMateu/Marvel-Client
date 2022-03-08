//
//  HeroesRepository.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 7/3/22.
//

import Foundation

class HeroesRepository: Repository {

    typealias EntityDTO = HeroeDTO
    typealias Service = HeroeService

    var dao: QueryDAO
    var service: Service

    required init(service: Service, dao: QueryDAO) {
        self.dao = dao
        self.service = service
    }

    func getHeroes(limit: Int, page: Int, offset: Int) async throws -> [HeroeDTO] {
        let cachedMovies = try await self.dao.getAll()

        // Call the API is there is no data
        guard !cachedMovies.isEmpty else {
            let newResponse = try await self.service.getHeroes(limit: String(limit))
            return newResponse.heroes
        }

        // When `cachedMovies.count / page` < 1 , the cached data is not enough so an API call needs to be done
        let needsAPICall: Bool = (cachedMovies.count / page) < 1

        guard needsAPICall else {
            return cachedMovies
        }

        let newHeroes = try await self.service.getHeroes(offset: String(offset), limit: String(limit)).heroes

        for hero in newHeroes {
            _ = await dao.addReplacing(hero)
        }
        return cachedMovies + newHeroes

    }

    func add(hero: HeroeDTO) async -> HeroeDTO {
        return await dao.addReplacing(hero)
    }

    func update(hero: HeroeDTO) async -> HeroeDTO {
        return await dao.addReplacing(hero)
    }

    func deleteHeroes() async throws {
        _ = try await dao.deleteAll()
    }

}
