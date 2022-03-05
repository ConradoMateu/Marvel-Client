//
//  BaseViewModelOutput.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 4/3/22.
//

import Foundation

public protocol HeroeViewModelInput {
    // Generic APICall
    func syncItems()
}

public protocol BaseViewModelOutput: ObservableObject {

   var error: Error? { get set }
   var isLoading: Bool { get set }
}
