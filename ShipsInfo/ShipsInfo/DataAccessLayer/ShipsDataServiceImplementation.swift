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
    
    init(dataStorage: ShipsStorage) {
        self.dataStorage = dataStorage
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
            let receivedData = Self.getHardcodedData()
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

//TEMP hardcoded data
private extension ShipsDataServiceImplementation {
    static func getHardcodedData() -> [ShipEntity] {
        let jsonData = readLocalJSONFile(forName: "SampleRecords")
        if let data = jsonData {
            if let sampleRecordsList = parse(jsonData: data) {
                return sampleRecordsList
            } else {
                fatalError("unable to parse file")
            }
        } else {
            fatalError("unable to read file")
        }
    }
    
    static func parse(jsonData: Data) -> [ShipEntity]? {
        do {
            let decodedData = try JSONDecoder().decode([ShipEntity].self, from: jsonData)
            return decodedData
        } catch {
            print("error: \(error)")
        }
        return nil
    }
    
    static func readLocalJSONFile(forName name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
}
