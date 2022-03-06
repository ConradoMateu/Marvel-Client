//
//  MockedData.swift
//  Marvel ClientTests
//
//  Created by Conrado Mateu Gisbert on 5/3/22.
//

import Foundation
@testable import Marvel_Client

public final class MockedData {

    static let HeroesResponse: URL = Bundle(for: JSONReusable.self).url(forResource: "response", withExtension: "json")!
}
