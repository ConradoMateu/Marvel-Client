//
//  Toolbar.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 3/3/22.
//

import Foundation
import SwiftUI

struct Toolbar: ViewModifier {

    // Used To Change Theme Programmatically
    @AppStorage("isDarkMode") private var isDarkMode = false

    var addItem: () -> Void
    var deleteAllItems: () -> Void

    func body(content: Content) -> some View {
        content
            .themeSwitcher()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                ToolbarItem {
                    Button(action: deleteAllItems) {
                        Text("Clear")
                    }
                }
        }
    }
}

extension View {
    func makeToolbarItems(addItem: @escaping () -> Void, deleteItem: @escaping () -> Void) -> some View {
        modifier(Toolbar(addItem: addItem, deleteAllItems: deleteItem))
    }
}
