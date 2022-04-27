//
//  ErrorHandling.swift
//  Marvel Client
//
//  Created by Conrado Mateu on 27/4/22.
//

import Foundation
import SwiftUI

protocol GenericErrorEnum: Error, Identifiable {
    var title: String { get }
    var errorDescription: String { get }
}

struct HandleErrorsByShowingAlertViewModifier<T>: ViewModifier where T: GenericErrorEnum {
    @Binding var error: T?

    func body(content: Content) -> some View {
        content
            // Applying the alert for error handling using a background element
            // is a workaround, if the alert would be applied directly,
            // other .alert modifiers inside of content would not work anymore
            .background(
                EmptyView()
                    .alert(item: $error) { viewModelError in
                        return Alert(title: Text(viewModelError.title),
                                     message: Text(viewModelError.errorDescription),
                                     dismissButton: .default(Text("OK")))

                    }
            )
    }
}

extension View {
    func withErrorHandling<T: GenericErrorEnum>(error: Binding<T?>) -> some View {
        modifier(HandleErrorsByShowingAlertViewModifier(error: error))
    }
}
