//
//  MapperHelper.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 5/3/22.
//

import Foundation
import CoreData

extension Optional where Wrapped == NSSet {
    func array<T: Hashable>(type: T.Type) -> [T] {
        if let set = self as? Set<T> {
            return Array(set)
        }
        return [T]()
    }
}
