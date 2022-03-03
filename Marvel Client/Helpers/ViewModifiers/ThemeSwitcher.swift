//
//  ThemeSwitcher.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 3/3/22.
//

import Foundation
import SwiftUI

struct ThemeSwitcher: ViewModifier {

    // Used To Change Theme Programatically
    @AppStorage("isDarkMode") private var isDarkMode = false

    func body(content: Content) -> some View {
        content.toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: toggleThemeChange) {
                    Label("Change Theme", systemImage: isDarkMode ? "sun.max.fill" : "moon.fill")
                }
            }
        }
    }

    func toggleThemeChange() {
        withAnimation {
                isDarkMode.toggle()
        }
    }
}

extension View {
    func themeSwitcher() -> some View {
        modifier(ThemeSwitcher())
    }
}
