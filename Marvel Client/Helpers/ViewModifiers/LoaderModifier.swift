//
//  LoaderModifier.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 8/3/22.
//

import Foundation
import SwiftUI

/// Toolbar View Modifier In Order to Abstract this layer (thinking about maintenance if the project becomes bigger)

struct LoaderModifier: ViewModifier {

    var isLoading: Bool

    func body(content: Content) -> some View {

        ZStack {
            content
                .disabled(isLoading)
                .blur(radius: isLoading ? 3 : 0)

            if isLoading {
                VStack {
                    Text("Loading...")
                    ProgressView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.secondary.colorInvert().ignoresSafeArea())
                .foregroundColor(Color.primary)
                .opacity(isLoading ? 1 : 0)

            }
        }
    }
}

extension View {
    func loaderViewWrapper(isLoading: Bool) -> some View {
        modifier(LoaderModifier(isLoading: isLoading))
    }
}
