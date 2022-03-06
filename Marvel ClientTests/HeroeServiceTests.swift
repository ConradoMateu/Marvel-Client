//
//  HeroeServiceTests.swift
//  Marvel ClientTests
//
//  Created by Conrado Mateu Gisbert on 5/3/22.
//

import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift

@testable import Marvel_Client
class HeroeServiceTests: XCTestCase {

    var heroeService: HeroeService!

    override func setUpWithError() throws {
        self.heroeService = HeroeService()

        /// Configures Mocker Framework in order to hijack URL Session

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAPI() async throws {

        stub(condition: isHost("gateway.marvel.com")) { _ in
            let stubPath = OHPathForFile("response.json", JSONReusable.self)

            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("response.json", JSONReusable.self)!,
              statusCode: 200,
              headers: ["Content-Type":"application/json"])
        }

        do {
            let res = try await heroeService.getHeroes()

            switch res {
            case .failure(let error):
                print(error)
                XCTFail("API Should return success response")

            case .success(let heroeResponse):

                assert(heroeResponse.heroes.count == 10)
            }
        } catch {
            XCTFail("Could not get Data Response")
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
