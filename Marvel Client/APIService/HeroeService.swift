//
//  HeroeService.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 5/3/22.
//

import Foundation

protocol HeroeServiceProtocol {
    func getHeroes(offset: String, limit: String) async throws -> HeroeResponseDTO
}

struct HeroeService: HTTPClient, HeroeServiceProtocol {
    func getHeroes(offset: String = "0", limit: String = "10") async throws -> HeroeResponseDTO {
        return try await sendRequest(endpoint: .heroes(offset: offset), responseModel: HeroeResponseDTO.self)
    }
}
