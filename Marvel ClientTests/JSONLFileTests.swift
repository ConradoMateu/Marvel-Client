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
    var response: HeroeResponseDTO?

    func testShouldProperlyDecodeLocalJSON() throws {
        assert(response != nil)
        assert(response?.heroes.count == 10)
    }
}
