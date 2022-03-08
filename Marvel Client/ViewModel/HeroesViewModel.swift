//
//  HeroesViewModel.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 8/3/22.
//

import Foundation

import Combine
import SwiftUI

@MainActor
class HeroesViewModel: ObservableObject {

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

    // Prevent requesting heroes when coming back from detailed view
    var comingFromDetailView: Bool = false

    private var cancellableBag = Set<AnyCancellable>()

    required init(repository: HeroesRepository = DependencyInjector.getHeroesRepository()) {
        self.repository = repository
    }

    func goingToDetailView() {
        comingFromDetailView = true
    }

    func getHeroes(isRefreshing: Bool = false) async {
        cleanErrors()
        do {

            guard  !comingFromDetailView || isRefreshing else {
                self.comingFromDetailView.toggle()
                return
            }

            page += 1
            let newResult = try await repository.getHeroes(limit: limit, page: page, offset: nextOffset).sortedByFavorite()
            withAnimation {
                result = newResult
            }

        } catch {
            self.error = error
        }
    }

    func addRandomHero() async {
        let randomUser = HeroeDTO.random
        withAnimation {
            self.result.append(randomUser)
            self.result = result.sortedByFavorite()
        }

        Task {
            await self.repository.add(hero: randomUser)
        }
    }

    func toggleFavoriteFor(_ hero: HeroeDTO) async {

        let heroeIndex = result.indices.filter { result[$0].id == hero.id }.first

        if let safeIndex = heroeIndex {
            result[safeIndex].isFavorite =  !result[safeIndex].isFavorite
            self.result = result.sortedByFavorite()
            let heroToUpdate = result[safeIndex]
            _ = await self.repository.update(hero: heroToUpdate)

        } else {
            self.error = HeroesViewModelError.couldNotUpdateHeroe
        }

    }

    func togglePagination() async {
        if result.count > limit - 1 {
            do {
                page += 1

                let newResult = try await repository.getHeroes(limit: limit, page: page, offset: nextOffset)

                withAnimation {
                    result = newResult.sortedByFavorite()
                }
            } catch {
                self.error = error
            }
        }
    }

    func cleanErrors() {
        self.error = nil
    }

    func deleteAllHeroes() async {
        do {
            withAnimation {
                self.result = []
            }

            self.page = 0
            try await self.repository.deleteHeroes()
        } catch {
            self.error = error
        }
    }

    func deleteHero(index: Int) async throws {
        withAnimation {
            _ = self.result.remove(at: index)
        }
        let heroeToRemove = result[index]

        _ = try await self.repository.delete(hero: heroeToRemove)
    }
}

enum HeroesViewModelError: Error {
    case couldNotUpdateHeroe
    case notConnectedToInternet
}
