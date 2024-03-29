//
//  NetworkManagerMock.swift
//  NetworkLayerTests
//
//  Created by Marcos Santos
//  Copyright © 2020 Marcos Santos. All rights reserved.
//

@testable import NetworkLayer

struct NetworkManagerMock: AnyNetworkManager {
    var task: NetworkSessionDataTaskMock?
    var session: NetworkSessionMock = NetworkSessionMock()

    mutating func request<ServiceType: NetworkService, ResponseType: Decodable>(
        _ endpoint: ServiceType,
        _ completion: @escaping (Result<ResponseType, Error>) -> Void) {

    }

    mutating func cancel() {

    }
}
