//
//  DataHTTPRequester.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 20.12.24.
//

import Foundation

protocol DataHTTPRequester {
    func executeRequest(urlRequest: URLRequest) async throws -> Data
}
