//
//  HeroesViewModel.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 8/3/22.
//

import Foundation

import Combine

class HeroesViewModel: BaseViewModel {

    @Published var result: [HeroeDTO] = []

    // RequestError from service or CoreDataError from dao
    @Published var error: Error?

    var repository: HeroesRepository

    var page: Int = 0
    // Number of heroes the API would return
    var limit: Int { 10 }
    // Parameter required for pagination in order to retrieve heroes
    var offset: Int = 0
    // For getting next X = limit results
    var nextOffset: Int { result.count + limit }

    required init(repository: HeroesRepository) {
        self.repository = repository
    }

    func getHeroes() async {
        cleanErrors()
        page += 1
        do {
            result = try await repository.getHeroes(limit: limit, page: page, offset: nextOffset)
        } catch {
            self.error = error
        }
    }

    func deleteHeroes() async {
        page = 0
        do {
            try await self.repository.deleteHeroes()
        } catch {
            self.error = error
        }
    }

    func addRandomHero() async {
        let randomUser = HeroeDTO.random
        self.result.append(randomUser)
        Task {
            await self.repository.add(hero: randomUser)
        }
    }

    func toggleFavoriteFor(_ hero: HeroeDTO) async throws {

        let heroeIndex = result.indices.filter { result[$0].id == hero.id }.first

        if let safeIndex = heroeIndex {
            result[safeIndex].isFavorite.toggle()

            _ = await self.repository.update(hero: result[safeIndex])
        } else {
            throw HeroesViewModelError.couldNotUpdateHeroe
        }

    }

    func cleanErrors() {
        self.error = nil
    }

    func deleteAllHeroes() async throws {
        do {
            try await self.repository.deleteHeroes()
        } catch {
            self.error = error
        }
    }
}

enum HeroesViewModelError: Error {
    case couldNotUpdateHeroe
    case notConnectedToInternet
}

struct DependencyInjector {
    static func getHeroesRepository() -> HeroesRepository {
        return HeroesRepository(service: HeroeService(), dao: HeroesDao())
    }
}
