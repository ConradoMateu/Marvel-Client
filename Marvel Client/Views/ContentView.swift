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

    @JSONFile(named: "response")
    var response: HeroeResponseDTO?
    @State var isNavigationActive = false

    var heroes: [HeroeDTO]? {
        response?.heroes
    }

    var body: some View {
        NavigationView {
            VStack {
                if let safeHeroes = heroes {
                    List(safeHeroes, id: \.name) { item in
                        VStack {
                            NavigationLink {
                                DetailRow(heroe: item)
                            } label: {
                                HeroeRow(heroe: item)
                            }
                        }
                    }
                }
                Text("Select A Hero To See Details")
            }.makeToolbarItems(addItem: addItem, deleteItem: deleteAllItems)
                .navigationTitle("Heroes")
        } .navigationViewStyle(.stack)
    }

    // TODO: Delete this functions, provide a ViewModel Solution
    private func addItem() { }

    private func deleteAllItems() { }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

// struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
// }
