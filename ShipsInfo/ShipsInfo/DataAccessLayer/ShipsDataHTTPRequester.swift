//
//  ShipsDataHTTPRequester.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 20.12.24.
//

import Foundation

final class ShipsDataHTTPRequester: DataHTTPRequester {
    func executeRequest(urlRequest: URLRequest) async throws -> Data {
        let requestResult: (data: Data, response: URLResponse)
        requestResult = try await URLSession.shared.data(for: urlRequest)
        
        let httpResponse = try getHTTPResponse(from: requestResult.response)
        
        try validateReceived(statusCode: httpResponse.statusCode)
        
        return requestResult.data
    }
    
    private func getHTTPResponse(from urlResponse: URLResponse) throws -> HTTPURLResponse {
        guard let httpResponse = urlResponse as? HTTPURLResponse
        else {
            throw NSError(
                domain: Bundle.main.bundleIdentifier ?? "",
                code: 1,
                userInfo: ["Unable to procees result" : urlResponse]
            )
        }
        
        return httpResponse
    }
    
    private func validateReceived(statusCode: Int) throws {
        if !(200...299).contains(statusCode) {
            throw NSError(
                domain: Bundle.main.bundleIdentifier ?? "",
                code: 2,
                userInfo: ["Request failed with status code" : statusCode]
            )
        }
    }
}
