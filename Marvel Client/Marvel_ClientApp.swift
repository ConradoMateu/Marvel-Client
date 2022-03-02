//
//  Marvel_ClientApp.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 2/3/22.
//

import SwiftUI

@main
struct Marvel_ClientApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
