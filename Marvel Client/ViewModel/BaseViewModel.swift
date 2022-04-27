//
//  BaseViewModel.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 8/3/22.
//

import Foundation

@MainActor
protocol BaseViewModel: ObservableObject {
    associatedtype EntityDTO
    associatedtype ErrorType
    associatedtype Repo
    var result: [EntityDTO] { get set }
    var viewModelError: ErrorType? { get set }
    var repository: Repo { get set }

    init(repository: Repo)
}
