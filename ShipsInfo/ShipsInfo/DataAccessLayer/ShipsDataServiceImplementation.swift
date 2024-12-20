//
//  ShipsDataServiceImplementation.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 20.12.24.
//

import os
import Foundation

final class ShipsDataServiceImplementation: ShipsDataService {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: ShipsDataServiceImplementation.self)
    )
    
    private let dataStorage: ShipsStorage
    private let apiService: ShipsAPIService
    private let apiLink: String
    
    init(dataStorage: ShipsStorage, apiService: ShipsAPIService, apiLink: String) {
        self.dataStorage = dataStorage
        self.apiService = apiService
        self.apiLink = apiLink
    }
    
    func fetchData() async -> Result<[ShipEntity], Error> {
        do {
            let data = try self.dataStorage.read()
            return .success(data)
        } catch {
            Self.logger.error("\(Self.getErrorDesciption(error: error))")
            return .failure(error)
        }
    }
    
    func synchronizeData() async {
        do {
            let receivedData = try await self.apiService.getShipsData(stringURLRepresentation: self.apiLink)
            try dataStorage.write(entities: receivedData)
        } catch {
            Self.logger.error("\(Self.getErrorDesciption(error: error))")
        }
    }
    
    func delete(_ entity: ShipEntity) async {
        do {
            try self.dataStorage.delete(entity: entity)
        } catch {
            Self.logger.error("\(Self.getErrorDesciption(error: error))")
        }
    }
    
    private static func getErrorDesciption(error: Error) -> String {
        let errorInfo = (error as NSError).userInfo
        if errorInfo.isEmpty {
            return error.localizedDescription
        } else {
            return errorInfo.debugDescription
        }
    }
}
