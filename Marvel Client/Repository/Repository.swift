//
//  Repository.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 5/3/22.
//

import Foundation

protocol Repository {
    associatedtype EntityDTO
    associatedtype Service

    var dao: QueryDAO { get set }
    var service: Service { get set }
    init(service: Service, dao: QueryDAO)
}
