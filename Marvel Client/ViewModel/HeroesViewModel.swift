//
//  HeroesViewModel.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 8/3/22.
//

import Foundation

import Combine
import SwiftUI

// Marked as main actor because is attach to the view, an actor execute actions in the main thread
@MainActor
class HeroesViewModel: ObservableObject {

    @Published var result: [HeroeDTO] = []

    // RequestError from service or CoreDataError from dao
    @Published var error: Error?

    @Published var isLoading: Bool = false

    @Published var triggerInternetAlert: Bool = false
    @Published var triggerErrorAlert: Bool = false

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
            withAnimation {
                isLoading.toggle()
            }
            page += 1
            let newResult = try await repository.getHeroes(limit: limit,
                                                           page: page,
                                                           offset: nextOffset).sortedByFavorite()
            isLoading.toggle()
            withAnimation {
                result = newResult
            }
        } catch RequestError.offline {
            self.triggerInternetAlert = true
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.error = error
            self.triggerErrorAlert = true
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
            cleanErrors()
            do {
                page += 1

                let newResult = try await repository.getHeroes(limit: limit, page: page, offset: nextOffset)

                withAnimation {
                    result = newResult.sortedByFavorite()
                }
            } catch RequestError.offline {
                self.triggerInternetAlert = true
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.error = error
                self.triggerErrorAlert = true
            }
        }
    }

    func cleanErrors() {
        self.error = nil
        self.triggerInternetAlert = false
        self.triggerErrorAlert = false
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
