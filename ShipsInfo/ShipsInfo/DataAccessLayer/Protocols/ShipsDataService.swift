//
//  ShipsDataService.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 20.12.24.
//

protocol ShipsDataService {
    func fetchData() async -> Result<[ShipEntity], Error> 
    func synchronizeData() async
    func delete(_ entity: ShipEntity) async
}
