//
//  NetworkManagerSpec.swift
//  NetworkLayerTests
//
//  Created by Marcos Santos
//  Copyright © 2020 Marcos Santos. All rights reserved.
//

import Quick
import Nimble

@testable import NetworkLayer

class NetworkManagerSpec: QuickSpec {

    class override func spec() {

        var session: NetworkSessionMock!
        var networkManager: NetworkManager!

        beforeEach {
            session = NetworkSessionMock()
            networkManager = NetworkManager(session: session)
        }

        describe("Network Manager request") {

            it("should return decoded model on success") {

                let expectedUser = UserMock.testInstance()
                var user: UserMock?

                session.data = try? expectedUser.encoded()
                networkManager.session = session

                networkManager.request(NetworkServiceMock.success) { (result: Result<UserMock, Error>) in
                    user = try? result.get()
                }
                expect(user).to(equal(expectedUser))
            }

            it("should be cancellable") {

                networkManager.request(NetworkServiceMock.success) { (_: Result<UserMock, Error>) in
                }
                expect(networkManager.task?.state).to(equal(.running))

                networkManager.cancel()
                expect(networkManager.task?.state).to(equal(.canceling))
            }

            context("when doing post (sending data and headers)") {

                let user = UserMock.testInstance()
                var networkManager = NetworkManager(session: NetworkSessionMock())

                networkManager.request(NetworkServiceMock.post(user)) { (_: Result<UserMock, Error>) in
                }
                let session = networkManager.session as? NetworkSessionMock

                it("should set request headers") {
                    expect(session?.request?.allHTTPHeaderFields)
                        .to(equal(NetworkServiceMock.post(user).headers))
                }

                it("should encode request body") {
                    expect(session?.request?.httpBody).to(equal(try? user.encoded()))
                }
            }
        }
    }
}
