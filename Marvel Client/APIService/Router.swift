//
//  Router.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 4/3/22.
//

import Foundation
import CryptoKit

enum Router: Equatable {
    case heroes(offset: String = "0", limit: String = "10")

    var url: String {scheme + "://" + host + path}
    var scheme: String {API.scheme}
    var host: String {API.URL}

    var path: String {
        switch self {
        case .heroes:
            return "/characters"

        }
    }

    var parameters: [URLQueryItem]? {
        switch self {
        case .heroes(let offset, let limit):
            return [URLQueryItem(name: "ts", value: API.timeStamp),
                    URLQueryItem(name: "apikey", value: API.publicKey),
                    URLQueryItem(name: "hash", value: API.hash),
                    URLQueryItem(name: "limit", value: limit),
                    URLQueryItem(name: "offset", value: offset )]
        }
    }

    var method: String {
        switch self {
        case .heroes:
            return "GET"
        }
    }

}

struct API {
    static var hash: String { "\(timeStamp)\(privateKey)\(publicKey)".md5 }
    static var publicKey: String { "Enter your PUBLIC KEY" }
    static var privateKey: String { "Enter your PRIVATE KEY" }
    static var timeStamp: String { formatter.string(from: Date()) }
    static var schemeURL: String {scheme + "://" + URL}
    static var scheme: String {return "https"}
    static var URL: String {
        "gateway.marvel.com:443/v1/public"
    }

    private static let formatter: DateFormatter = {
        let form = DateFormatter()
        form.dateFormat = "yyyyMMddHHmmss"
          return form
          }()

}
