//
//  JSONFile.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 3/3/22.
//

import Foundation

/// This Property wrapper allows to easily decoding JSON files
@propertyWrapper struct JSONFile<DataType: Decodable> {
    let named: String
    let type: String = "json"
    let fileManager: FileManager = .default
    let bundle: Bundle = .main
    let decoder = JSONDecoder()

    var wrappedValue: DataType? {
        guard let path = bundle.path(forResource: named, ofType: type) else { fatalError("Resource not found") }
        guard let data = fileManager.contents(atPath: path) else { fatalError("File not loaded") }

        // Added Decoding Errors
        do {
            let messages = try decoder.decode(DataType.self, from: data)
            return messages
        } catch DecodingError.dataCorrupted(let context) {
            print(context)
            return nil
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return nil
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return nil
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return nil
        } catch {
            print("error: ", error)
            return nil
        }
    }
}

/// Used to reuse JSON in Test Targets
class JSONReusable { }
