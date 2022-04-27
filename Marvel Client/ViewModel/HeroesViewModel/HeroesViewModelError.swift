//
//  HeroesViewModelError.swift
//  Marvel Client
//
//  Created by Conrado Mateu on 27/4/22.
//

import Foundation

enum HeroesViewModelError: GenericErrorEnum {
    // In order to make it Identifiable
    var id: Self { self }

    case couldNotDeleteHeroe
    case couldNotUpdateHeroe
    case notConnectedToInternet
    case unknown
    case none

    var title: String {
        switch self {
        case .notConnectedToInternet:
            return "No Internet Connection"
        default:
            return "Error"
        }
    }

    var errorDescription: String {
        switch self {
        case .couldNotUpdateHeroe, .couldNotDeleteHeroe:
            return "Heroes Could not be updated"
        case .notConnectedToInternet:
            return "Please enable Wifi or Cellular data"
        case .unknown:
            return "An Unknown Error has occurred"
        case .none:
            return ""
        }
    }
}
