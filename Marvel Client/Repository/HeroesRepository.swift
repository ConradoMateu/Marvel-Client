//
//  HeroesRepository.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 7/3/22.
//

import Foundation

class HeroesRepository: Repository {

    typealias EntityDTO = HeroDTO
    typealias Service = HeroeServiceProtocol

    var dao: QueryDAO
    var service: Service

    required init(service: HeroeServiceProtocol, dao: QueryDAO) {
        self.dao = dao
        self.service = service
    }

    func getHeroes(limit: Int, page: Int, offset: Int) async throws -> [HeroDTO] {
        let cachedHeroes = try await self.dao.getAll()

        // Call the API is there is no data
        guard !cachedHeroes.isEmpty else {
            let newHeroes = try await self.service.getHeroes(offset: "\(offset)", limit: String(limit)).heroes
            for hero in newHeroes {
                _ = await dao.addReplacing(hero)
            }
            return newHeroes
        }

        // When (cachedHeroes.count / limit) < page , the cached data is not enough so an API call needs to be done
        // Page 0 is false to prevent division by cero, in this case there is no need to call to the API
        let needsAPICall: Bool = page == 0 ? false : (cachedHeroes.count / limit) < page

        print("cached heroes \(cachedHeroes.count), needsAPICall? : \(needsAPICall)")

        guard needsAPICall else {

            // swiftlint:disable:next line_length
            // if there is no more cached data available in the next page, cachedHeroes array could be out of bounds if cachedHeroes[0..<maxHeroesPerPage], instead the completed cachedHeroes in DB should be returned
            let maxHeroesPerPage: Int = limit * page
            let shouldShowCachedHeroes = cachedHeroes.count < limit * page

            print(shouldShowCachedHeroes)
            // swiftlint:disable:next line_length
            // Otherwise If there is more cached data we are not in the last page, data needs to be constrained per page.
            let newHeroesToReturn  = shouldShowCachedHeroes ? cachedHeroes : Array(cachedHeroes[0..<maxHeroesPerPage])
            return newHeroesToReturn
        }

        let newHeroes = try await self.service.getHeroes(offset: "\(offset)", limit: "\(limit)").heroes

        print("NEW RESPONSE: \(newHeroes.count)")
        for hero in newHeroes {
            _ = await dao.addReplacing(hero)
        }
        // Return the union of cached heroes + newHeroes from API, removing duplicates
        return Array(Set(cachedHeroes + newHeroes))

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
