//
//  Marvel_ClientApp.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 2/3/22.
//

import SwiftUI

@main
struct MarvelApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
