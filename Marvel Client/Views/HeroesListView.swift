//
//  HeroesListView.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 2/3/22.
//

import SwiftUI
import CoreData

struct HeroesListView: View {
    /// Waiting for Swift 6 to see how this is handled https://twitter.com/andresr_develop/status/1509287460961927186?s=21
    @StateObject var viewmodel = HeroesViewModel()

    @State var query: String = ""
    var body: some View {
            VStack {
                if viewmodel.heroes.count != 0 {
                    heroesView()
                } else {
                    emptyView()
                }
            }
            .loaderViewWrapper(isLoading: viewmodel.isLoading)
            .withErrorHandling(error: $viewmodel.viewModelError)
            .onDisappear { viewmodel.goingToDetailView() }
            .onAppear {
                Task {
                    await viewmodel.getHeroes()
                }
            }
    }

    func heroesView() -> some View {
        NavigationView {
            List {
                ForEach(viewmodel.heroes, id: \.id) { hero in
                    NavigationLink {
                        DetailRow(hero: hero,
                                  onFavoriteToggled: viewmodel.toggleFavoriteFor)
                    } label: {
                        HeroRow(hero: hero)
                    }.task {
                        // Triggers pagination when reaching bottom
                        if viewmodel.canTriggerPagination(for: hero) {
                            await viewmodel.togglePagination()
                        }
                    }
                }.onDelete(perform: delete)
                    .listRowBackground(Color(UIColor.secondarySystemGroupedBackground))
            }.refreshable {
                await viewmodel.getHeroes(isRefreshing: true)
            }.navigationTitle("Heroes")            .makeToolbarItems(addItem: viewmodel.addRandomHero,
                                                                     deleteItem: viewmodel.deleteAllHeroes)
        }.navigationViewStyle(.stack)
        .searchable(text: $query) .onChange(of: query) { newQuery in
            viewmodel.triggerSearch(for: newQuery)
        }
    }
    
    func emptyView() -> some View {
        NavigationView {
            Button( action: {
                Task {
                    await viewmodel.getHeroes()
                }
            }, label: {
                Text("Get Heroes")
            }).buttonStyle(.borderedProminent)
                .controlSize(.large)
                .makeToolbarItems(addItem: viewmodel.addRandomHero,
                                  deleteItem: viewmodel.deleteAllHeroes)
        }
    }

    // Required Function for deleting an element from a swipe
    func delete(at offsets: IndexSet) {
        let index = offsets[offsets.startIndex]
        Task {
            try await self.viewmodel.deleteHero(index: index)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HeroesListView(viewmodel: HeroesViewModel(repository: DependencyInjector.fakeRepository()))
            .preferredColorScheme(.dark)
    }
}
