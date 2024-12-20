//
//  ShipsAPIServiceImplementation.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 20.12.24.
//

import Foundation

final class ShipsAPIServiceImplementation: ShipsAPIService {
    let jsonDecoder: JSONDecoder
    private let dataRequester: DataHTTPRequester
    
    init(dataRequester: DataHTTPRequester, jsonDecoder: JSONDecoder? = nil) {
        self.dataRequester = dataRequester
        self.jsonDecoder = jsonDecoder ?? JSONDecoder()
    }
    
    func getShipsData(stringURLRepresentation: String) async throws -> [ShipEntity] {
        let url = try getURLFromStringRepresentation(stringURLRepresentation)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let responseData = try await dataRequester.executeRequest(urlRequest: urlRequest)
        let receivedEntities = try self.jsonDecoder.decode([ShipEntity].self, from: responseData)
        
        return receivedEntities
    }
    
    private func getURLFromStringRepresentation(_ urlRepresentation: String) throws -> URL {
        guard let url = URL(string: urlRepresentation)
        else {
            throw NSError(
                domain: Bundle.main.bundleIdentifier ?? "",
                code: 10,
                userInfo: ["Invalid URL" : urlRepresentation]
            )
        }
        
        return url
    }
}
