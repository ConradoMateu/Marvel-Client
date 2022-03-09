//
//  Marvel_ClientApp.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 2/3/22.
//

import SwiftUI

@main
struct MarvelApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some Scene {
        WindowGroup {
            HeroesListView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
