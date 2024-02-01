//
//  NetworkSession.swift
//  NetworkLayer
//
//  Created by Marcos Santos
//  Copyright © 2020 Marcos Santos. All rights reserved.
//

import Foundation

public protocol NetworkSession {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

    mutating func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult)
    -> NetworkSessionDataTask
}

extension URLSession: NetworkSession {
    public func dataTask(with request: URLRequest,
                         completionHandler: @escaping DataTaskResult) -> NetworkSessionDataTask {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}
