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

    var addItem: () async -> Void
    var deleteAllItems: () async -> Void

    func body(content: Content) -> some View {
        content
            .themeSwitcher()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {Task {
                        _ = await addItem()

                    } }, label: {
                        Label("Add Item", systemImage: "plus")
                    })
                }
                ToolbarItem {
                    Button(action: { Task {
                         _ = await deleteAllItems() }
                    }, label: {
                        Text("Clear")
                    })
                }
        }
    }
}

extension View {
     func makeToolbarItems(addItem: @escaping () async -> Void, deleteItem: @escaping () async -> Void) -> some View {
        modifier(Toolbar(addItem: addItem, deleteAllItems: deleteItem))
    }
}
