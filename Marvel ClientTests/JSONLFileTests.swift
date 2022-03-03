//
//  Marvel_ClientTests.swift
//  Marvel ClientTests
//
//  Created by Conrado Mateu Gisbert on 2/3/22.
//

import XCTest
@testable import Marvel_Client

class JSONFileTests: XCTestCase {

    @JSONFile(named: "response")
    var response: HeroeResponse?

    func testShouldProperlyDecodeLocalJSON() throws {
        assert(response != nil)
        assert(response?.data.heroes.count == 10)
    }
}
