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
class HeroesViewModel: BaseViewModel {

    var repository: HeroesRepository
    var page: Int = 0

    /// Number of heroes the API would return
    var limit: Int { 10 }

    /// Parameter required for pagination in order to retrieve heroes
    var offset: Int = 0

    /// For getting next X = limit results
    var nextOffset: Int { result.count + limit }

    /// Prevent requesting heroes when coming back from detailed view
    var comingFromDetailView: Bool = false

    var result: [HeroDTO] = [] {
        didSet {
            withAnimation {
                heroes = result
            }
        }
    }

    var filteredResults: [HeroDTO] = [] {
        didSet {
            withAnimation {
                if !filteredResults.isEmpty {
                    heroes = filteredResults
                } else {
                    heroes = result
                }
            }
        }
    }

    @Published var heroes: [HeroDTO] = []
    @Published var viewModelError: HeroesViewModelError?
    @Published var isLoading: Bool = true

    required init(repository: HeroesRepository = DependencyInjector.getHeroesRepository()) {
        self.repository = repository
    }

    // MARK: CRUD Methods

    func getHeroes(isRefreshing: Bool = false) async {
        cleanErrors()
        do {
            guard  !comingFromDetailView || isRefreshing else {
                self.comingFromDetailView.toggle()
                return
            }

            withAnimation {
                isLoading = true
            }
            page += 1
            let newResult = try await repository.getHeroes(limit: limit,
                                                           page: page,
                                                           offset: nextOffset).sortedByFavorite()

            withAnimation {
                isLoading = false
            }

            result = newResult

        } catch RequestError.offline {
            self.viewModelError = .notConnectedToInternet
            self.isLoading = false
        } catch {
            self.viewModelError = .couldNotDeleteHeroe
            self.isLoading = false
        }
    }

    func addRandomHero() async {
        let randomUser = HeroDTO.random
        self.result.append(randomUser)
        self.result = result.sortedByFavorite()
        Task {
            await self.repository.add(hero: randomUser)
        }
    }

    func deleteAllHeroes() async {
        do {
            self.result = []
            self.page = 0
            try await self.repository.deleteHeroes()
        } catch {
            self.viewModelError = .couldNotDeleteHeroe
        }
    }

    func deleteHero(index: Int) async throws {
        _ = self.result.remove(at: index)
        let heroeToRemove = result[index]
        _ = try await self.repository.delete(hero: heroeToRemove)
    }

    // MARK: ViewHelpers

    func canTriggerPagination(for hero: HeroDTO) -> Bool {
        return result.count > 0 &&
        filteredResults.isEmpty &&
        result.last == hero ? true : false
    }

    func toggleFavoriteFor(_ hero: HeroDTO) async {
        let heroeIndex = result.indices.filter { result[$0].id == hero.id }.first
        if let safeIndex = heroeIndex {
            result[safeIndex].isFavorite =  !result[safeIndex].isFavorite
            let heroToUpdate = result[safeIndex]
            self.result = result.sortedByFavorite()
            _ = await self.repository.update(hero: heroToUpdate)
        } else {
            self.viewModelError = .couldNotUpdateHeroe
        }

    }

    func togglePagination() async {
        if result.count > limit - 1 {
            do {
                page += 1
                let newResult = try await repository.getHeroes(limit: limit, page: page, offset: nextOffset)
                result = newResult.sortedByFavorite()
            } catch RequestError.offline {
                self.viewModelError = .notConnectedToInternet
                self.isLoading = false
            } catch {
                self.isLoading = false

                // When a Task is cancelled
                guard (error as NSError?)?.code == NSURLErrorCancelled  else {
                    self.viewModelError = .unknown
                    return
                }
            }
        }
    }

    func triggerSearch(for query: String) {
        if query == "" {
            filteredResults = []
        } else {
            filteredResults = result.filter {
                $0.name.lowercased().contains(query.lowercased()) || $0.description.lowercased().contains(query.lowercased())
            }
        }
    }

    func cleanErrors() {
        self.viewModelError = nil
    }

    func goingToDetailView() {
        comingFromDetailView = true
    }
}
