//
//  HeroesRepository.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 7/3/22.
//

import Foundation

class HeroesRepository: Repository {

    typealias EntityDTO = HeroDTO
    typealias Service = HeroeService

    var dao: QueryDAO
    var service: Service

    required init(service: Service, dao: QueryDAO) {
        self.dao = dao
        self.service = service
    }

    func getHeroes(limit: Int, page: Int, offset: Int) async throws -> [HeroDTO] {
        let cachedMovies = try await self.dao.getAll()

        // Call the API is there is no data
        guard !cachedMovies.isEmpty else {
            let newHeroes = try await self.service.getHeroes(limit: String(limit)).heroes
            for hero in newHeroes {
                _ = await dao.addReplacing(hero)
            }

            return newHeroes

        }

        // When `cachedMovies.count / page` < 1 , the cached data is not enough so an API call needs to be done
        // Page 0 is false to prevent division by cero, in this case there is no need to call to the API
        print("cached movies \(cachedMovies.count), needsAPICall? : \((cachedMovies.count / limit) < page) ")
        let needsAPICall: Bool = page == 0 ? false : (cachedMovies.count / limit) < page

        guard needsAPICall else {

            // swiftlint:disable:next line_length
            // Checking if cachedMovies.count < limit * page to do not get out of bounds for getting results with pagination, not all the array
            let maxHeroesPerPage: Int = limit * page
            let shouldShowCachedMovies = cachedMovies.count < limit * page

            // if there is no more data available, all cached data should be shown
            // swiftlint:disable:next line_length
            // Otherwise If there is more cached data if we are not in the last page, data need to be constrained per page.
            let tests  = shouldShowCachedMovies ? cachedMovies : Array(cachedMovies[0..<maxHeroesPerPage])
            return Array(tests)
        }

        let newHeroes = try await self.service.getHeroes(offset: "\(offset)", limit: "\(limit)").heroes

        print("NEW RESPONSE: \(newHeroes.count)")
        for hero in newHeroes {
            _ = await dao.addReplacing(hero)
        }
        // Return the union of cached movies + heroes, removing duplicates
        return Array(Set(cachedMovies + newHeroes))

    }

    func add(hero: HeroDTO) async -> HeroDTO {
        return await dao.addReplacing(hero)
    }

    func update(hero: HeroDTO) async -> HeroDTO {
        return await dao.addReplacing(hero)
    }

    func delete(hero: HeroDTO) async throws -> Bool {
        return try await dao.delete(hero)
    }

    func deleteHeroes() async throws {

        _ = try await dao.deleteAll()
    }

}
