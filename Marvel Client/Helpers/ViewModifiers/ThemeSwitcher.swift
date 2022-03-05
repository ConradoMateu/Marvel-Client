//
//  ThemeSwitcher.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 3/3/22.
//

import Foundation
import SwiftUI

/// Toolbar View Modifier In Order to Abstract this layer (thinking about maintenance if the project becomes bigger)
struct ThemeSwitcher: ViewModifier {

    // Used To Change Theme Programmatically
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
