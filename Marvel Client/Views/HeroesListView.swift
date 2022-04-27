//
//  HeroesListView.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 2/3/22.
//

import SwiftUI
import CoreData

struct HeroesListView: View {
    /// Waiting for Swift 6 for this warning https://twitter.com/andresr_develop/status/1509287460961927186?s=21
    @StateObject var viewmodel = HeroesViewModel()

    @State var query: String = ""
    var body: some View {
        NavigationView {
            VStack {

                if viewmodel.heroes.count != 0 {
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

                    }.refreshable {
                        await viewmodel.getHeroes(isRefreshing: true)
                    }
                } else {

                    Button( action: {
                        Task {
                            await viewmodel.getHeroes()
                        }
                    }, label: {
                        Text("Get Heroes")
                    }).buttonStyle(.borderedProminent)
                        .controlSize(.large)
                }

            }                .alert(isPresented: $viewmodel.triggerInternetAlert, content: {
                return Alert(title: Text("No Internet Connection"),
                             message: Text("Please enable Wifi or Cellular data"),
                             dismissButton: .default(Text("OK")))
            })

            .onAppear {
                Task {
                    await viewmodel.getHeroes()
                }
            }.onDisappear {
                viewmodel.goingToDetailView()
            }.makeToolbarItems(addItem: viewmodel.addRandomHero, deleteItem: viewmodel.deleteAllHeroes)
                .navigationTitle("Heroes")
        }.navigationViewStyle(.stack)
            .alert(isPresented: $viewmodel.triggerErrorAlert, content: {
                return Alert(title: Text("An Error Has Occurred"),
                             message: Text(viewmodel.error?.localizedDescription ?? ""),
                             dismissButton: .default(Text("OK")))
            }).searchable(text: $query) .onChange(of: query) { newQuery in
                    viewmodel.triggerSearch(for: newQuery)
                }

            .loaderViewWrapper(isLoading: viewmodel.isLoading)
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
