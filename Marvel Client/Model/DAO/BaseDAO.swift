//
//  DAOProtocol.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 4/3/22.
//

import Foundation
import CoreData

// Disabling variable name in Swiflint because protocol defined funcs
// swiftlint:disable variable_name
public protocol BaseDAO {

    associatedtype Item
    associatedtype ItemDTO

    // DaoProtocol

    func insert(_ e: ItemDTO) async throws ->  Item

    func delete(_ e: ItemDTO) async throws ->  Int

    func update(_ e: ItemDTO) async throws ->  Item
    func load(id: String) async throws -> Item

    // WordsetCategoryDaoProtocol
    func update(_ entities: [ItemDTO]) async throws -> [Item]
}
