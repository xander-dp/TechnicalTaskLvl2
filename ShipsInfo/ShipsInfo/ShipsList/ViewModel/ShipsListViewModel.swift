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
    
    private let dataService: ShipsDataService
    private var cancellables: Set<AnyCancellable>
    
    init(dataService: ShipsDataService) {
        self.dataService = dataService
        self.cancellables = Set<AnyCancellable>()
    }
    
    func getData() {
        Task {
            let fetchResult = await self.dataService.fetchData()
            
            if case .success(let data) = fetchResult {
                self.dataSource = data
            }
        }
        .store(in: &cancellables)
    }
    
    func viewRequestedRefresh() {
        Task {
            await self.dataService.synchronizeData()
            self.getData()
        }
        .store(in: &cancellables)
    }
    
    func viewRequestedSelection(at index: Int) {
        self.selectedEntity = self.dataSource[index]
    }

    func viewRequestedDeletion(at index: Int) {
        let deletedEntity = self.dataSource.remove(at: index)
        Task {
            await self.dataService.delete(deletedEntity)
        }
        .store(in: &cancellables)
    }
}
