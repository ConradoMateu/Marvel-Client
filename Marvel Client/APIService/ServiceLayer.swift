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

        var request = URLComponents(string: endpoint.url)!

        if let parameters = endpoint.parameters {
            request.queryItems = parameters
        }

        guard let url = request.url else { return .failure(RequestError.invalidURL)  }

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = endpoint.method

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest, delegate: nil)
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
