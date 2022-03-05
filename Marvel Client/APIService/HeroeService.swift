//
//  HeroeService.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 5/3/22.
//

import Foundation

protocol HeroeServiceProtocol {
    func getHeroes(offset: String) async throws -> Result<HeroeResponseDTO, RequestError>
}

struct MoviesService: HTTPClient, HeroeServiceProtocol {
    func getHeroes(offset: String) async throws -> Result<HeroeResponseDTO, RequestError> {
        return try await sendRequest(endpoint: .heroes(offset: offset), responseModel: HeroeResponseDTO.self)
    }
}
