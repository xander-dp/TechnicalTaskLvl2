//
//  ShipsListViewModel.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 19.12.24.
//

import Foundation
import Combine

final class ShipsListViewModel: ObservableObject {
    @Published var ships: [ShipEntityUIRepresentation] = []
    @Published var selectedEntity: ShipEntity?
    
    private var dataSource: [ShipEntity] = [] {
        didSet {
            self.ships = dataSource.map { ShipEntityUIRepresentation(with: $0) }
        }
    }
    
    func viewRequestedRefresh() {
        self.dataSource = ShipsListViewModel.getHardcodedData()
    }
    
    func viewRequestedSelection(at index: Int) {
        self.selectedEntity = self.dataSource[index]
    }

    func viewRequestedDeletion(at index: Int) {
        self.dataSource.remove(at: index)
    }
}

//TEMP hardcoded data
private extension ShipsListViewModel {
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
