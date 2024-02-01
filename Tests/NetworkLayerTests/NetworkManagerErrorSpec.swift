//
//  NetworkManagerErrorSpec.swift
//  NetworkLayerTests
//
//  Created by Marcos Santos
//  Copyright © 2020 Marcos Santos. All rights reserved.
//

import Quick
import Nimble

@testable import NetworkLayer

class NetworkManagerErrorSpec: QuickSpec {

    class override func spec() {

        var session: NetworkSessionMock!
        var networkManager: NetworkManager!

        beforeEach {
            session = NetworkSessionMock()
            networkManager = NetworkManager(session: session)
        }

        describe("Network Manager request") {

            it("should return error on invalid url") {
                var error: Error?
                var networkManager = NetworkManager(session: session)

                networkManager.request(NetworkServiceInvalidURLMock.invalidURL) { (result: Result<UserMock, Error>) in
                    guard case let .failure(err) = result else {
                        return fail("Expecting failure, got success")
                    }
                    error = err
                }
                expect(error?.localizedDescription).to(equal(
                    NetworkError.invalidURL.localizedDescription))
            }

            it("should return error on empty data") {
                var error: Error?

                networkManager.request(NetworkServiceMock.success) { (result: Result<UserMock, Error>) in
                    guard case let .failure(err) = result else {
                        return fail("Expecting failure, got success")
                    }
                    error = err
                }

                expect(error?.localizedDescription).to(equal(
                    NetworkError.emptyData.localizedDescription))
            }

            it("should return error on empty response") {
                var error: Error?

                session.response = nil
                networkManager.session = session

                networkManager.request(NetworkServiceMock.success) { (result: Result<UserMock, Error>) in
                    guard case let .failure(err) = result else {
                        return fail("Expecting failure, got success")
                    }
                    error = err
                }

                expect(error?.localizedDescription).to(equal(
                    NetworkError.emptyResponse.localizedDescription))
            }

            it("should return error on network error") {
                var error: Error?

                session.error = TestConstants.mockError()
                networkManager.session = session

                networkManager.request(NetworkServiceMock.error) { (result: Result<UserMock, Error>) in
                    guard case let .failure(err) = result else {
                        return fail("Expecting failure, got success")
                    }
                    error = err
                }
                expect(error?.localizedDescription.starts(with: "Request error:")).to(beTrue())
            }
        }
    }
}
