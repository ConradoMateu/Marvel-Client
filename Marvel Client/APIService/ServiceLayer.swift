//
//  HTTPClient.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 4/3/22.
//

import Foundation

protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Router, responseModel: T.Type) async throws -> Result<T, RequestError>
}

/// Usage let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
extension HTTPClient {
    func sendRequest<T: Decodable>(
        endpoint: Router,
        responseModel: T.Type
    ) async throws -> Result<T, RequestError> {
        guard let url = URL(string: endpoint.url) else {
            return .failure(.invalidURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body = endpoint.parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 401:
                return .failure(.unauthorised)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}
