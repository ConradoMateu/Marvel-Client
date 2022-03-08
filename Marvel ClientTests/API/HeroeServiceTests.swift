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
    }

    func testShoulDecodeAPIResponse() async throws {

        // GIVEN
        // Hijacks URLSession in order to return mock success response
        stub(condition: isHost("gateway.marvel.com")) { _ in

            let stubPath = OHPathForFile("response.json", JSONReusable.self)
            return fixture(filePath: stubPath!, headers: ["Content-Type": "application/json"])
        }

        do {
            // WHEN
            let res = try await heroeService.getHeroes()

            // THEN
            switch res {
            case .failure:
                XCTFail("API Should return success response")
            case .success(let heroeResponse):
                assert(heroeResponse.heroes.count == 10)
            }
        } catch {
            XCTFail("Could not get Data Response")
        }
    }

    func testShouldReturnDecodingError() async throws {

        // GIVEN
        stub(condition: isHost("gateway.marvel.com")) { _ in
            if let data = try? JSONEncoder().encode("Error JSON") {
                return HTTPStubsResponse(data: data,
                                         statusCode: 200,
                                         headers: ["Content-Type": "application/json"])
            }

            fatalError("Could not encode data")
        }

        do {
            // WHEN
            let res = try await heroeService.getHeroes()
            switch res {
            case .failure(let error):
                // THEN
                assert(error == .decode)
            case .success:
                XCTFail("Should throw decoding error")
            }
        } catch {
            XCTFail("Could not get Data Response")
        }
    }

    func testShouldReturnUnauthorisedError() async throws {

        // GIVEN
        stub(condition: isHost("gateway.marvel.com")) { _ in
            if let data = try? JSONEncoder().encode("Error JSON") {
                return HTTPStubsResponse(data: data,
                                         statusCode: 401,
                                         headers: ["Content-Type": "application/json"])
            }

            fatalError("Could not encode data")
        }

        do {
            // WHEN
            let res = try await heroeService.getHeroes()
            switch res {
            // THEN
            case .failure(let error):
                assert(error == .unauthorised)
            case .success:
                XCTFail("Should throw unauthorised error")
            }
        } catch {
            XCTFail("Could not get Data Response")
        }
    }

    func testShouldReturnUnexpectedStatusError() async throws {

        // GIVEN
        stub(condition: isHost("gateway.marvel.com")) { _ in
            if let data = try? JSONEncoder().encode("Error JSON") {
                return HTTPStubsResponse(data: data,
                                         statusCode: 500,
                                         headers: ["Content-Type": "application/json"])
            }

            fatalError("Could not encode data")
        }

        do {

            // WHEN
            let res = try await heroeService.getHeroes()
            switch res {

            // THEN
            case .failure(let error):
                assert(error == .unexpectedStatusCode)
            case .success:
                XCTFail("Should throw unauthorised error")
            }
        } catch {
            XCTFail("Could not get Data Response")
        }
    }

    func testShouldReturnUnknownError() async throws {

        // GIVEN
        stub(condition: isHost("gateway.marvel.com")) { _ in
                return HTTPStubsResponse(error: RequestError.unknown)
        }

        do {

            // WHEN
            let res = try await heroeService.getHeroes()
            switch res {

            // THEN
            case .failure(let error):
                assert(error == .unknown)
            case .success:
                XCTFail("Should throw unknown error")
            }
        } catch {
            XCTFail("Could not get Data Response")
        }
    }

}
