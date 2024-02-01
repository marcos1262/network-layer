//
//  NetworkManagerResponseErrorSpec.swift
//  NetworkLayerTests
//
//  Created by Marcos Santos
//  Copyright © 2020 Marcos Santos. All rights reserved.
//

import Quick
import Nimble
import Foundation

@testable import NetworkLayer

class NetworkManagerResponseErrorSpec: QuickSpec {

    class override func spec() {

        var session: NetworkSessionMock!
        var networkManager: NetworkManager!

        beforeEach {
            session = NetworkSessionMock()
            networkManager = NetworkManager(session: session)
        }

        describe("Network Manager request") {

            it("should return error when cant decode model") {
                var error: Error?

                let expectedUser = [
                    "uuid": Int(TestConstants.userUUIDExample.rawValue)!,
                    "nameWRONG": TestConstants.userNameExample.rawValue
                ] as [String: Any]

                session.data = try? JSONSerialization.data(withJSONObject: expectedUser, options: [])
                networkManager.session = session

                networkManager.request(NetworkServiceMock.decodeError) { (result: Result<UserMock, Error>) in
                    guard case let .failure(err) = result else {
                        return fail("Expecting failure, got success")
                    }
                    error = err
                }
                expect(error?.localizedDescription.starts(with: "Decoding error:")).to(beTrue())
            }

            it("should return error on redirecting server response") {
                mockError(statusCode: 301)
                testError(endpoint: .redirectingError, expectedError: .redirectingError(nil))
            }

            it("should return error when server responds with client error") {
                mockError(statusCode: 401)
                testError(endpoint: .clientError, expectedError: .clientError(nil))
            }

            it("should return error when server responds with server error") {
                mockError(statusCode: 500)
                testError(endpoint: .serverError, expectedError: .serverError(nil))
            }

            it("should return error when server responds with unknown error") {
                mockError(statusCode: 0)
                testError(endpoint: .unknownError, expectedError: .unknown)
            }
        }

        func mockError(statusCode: Int) {
            session.data = Data()
            session.response = NetworkSessionMock.mockResponse(statusCode: statusCode)
            networkManager.session = session
        }

        func testError(endpoint: NetworkServiceMock, expectedError: NetworkError) {
            var error: Error?

            networkManager.request(endpoint) { (result: Result<UserMock, Error>) in
                guard case let .failure(err) = result else {
                    return fail("Expecting failure, got success")
                }
                error = err
            }
            expect(error?.localizedDescription).to(equal(expectedError.localizedDescription))
        }
    }
}
