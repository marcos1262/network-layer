//
//  NetworkSessionMock.swift
//  NetworkLayerTests
//
//  Created by Marcos Santos
//  Copyright © 2020 Marcos Santos. All rights reserved.
//

import Foundation

@testable import NetworkLayer

struct NetworkSessionMock: NetworkSession {
    var request: URLRequest?

    var data: Data?
    var response: URLResponse? = Self.mockResponse(statusCode: 200)
    var error: Error?

    mutating func dataTask(with request: URLRequest,
                           completionHandler: @escaping Self.DataTaskResult) -> NetworkSessionDataTask {
        self.request = request

        completionHandler(data, response, error)

        return NetworkSessionDataTaskMock()
    }

    static func mockResponse(statusCode: Int) -> HTTPURLResponse? {
        return HTTPURLResponse(url: TestConstants.mockURL(), statusCode: statusCode,
                               httpVersion: nil, headerFields: nil)
    }
}
