//
//  MD5.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 6/3/22.
//

import Foundation
import CryptoKit

extension String {
    // To generate MD5 for Marvel API
    var md5: String {
        let hash = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())

        return hash.map {
            String(format: "%02hhx", $0)
        }
        .joined()
    }
}
