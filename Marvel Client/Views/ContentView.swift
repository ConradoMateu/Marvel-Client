//
//  ContentView.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 2/3/22.
//

import SwiftUI
import CoreData

struct ContentView: View {

    // Core Data Variables

    @StateObject var viewmodel = HeroesViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewmodel.result.count != 0 {
                    List {
                        ForEach(viewmodel.result, id: \.id) { hero in
                            NavigationLink {
                                DetailRow(heroe: hero,
                                          onFavoriteToggled: viewmodel.toggleFavoriteFor)
                            } label: {
                                HeroeRow(heroe: hero)
                            }.task {
                                if viewmodel.result.count > 0 {
                                    if viewmodel.result.last == hero {
                                        await viewmodel.togglePagination()
                                    }
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
                    })
                }

            }.onAppear {
                Task {
                    await viewmodel.getHeroes()
                }
            }.onDisappear {
                viewmodel.goingToDetailView()
            }.makeToolbarItems(addItem: viewmodel.addRandomHero, deleteItem: viewmodel.deleteAllHeroes)
                .navigationTitle("Heroes")
        } .navigationViewStyle(.stack)
    }

    // Required Function for deleting an element from a swipe
    func delete(at offsets: IndexSet) {
        let index = offsets[offsets.startIndex]
        Task {
            try await self.viewmodel.deleteHero(index: index)
        }
    }
}

// struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
// }
