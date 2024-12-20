//
//  ShipsStorage.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 20.12.24.
//

protocol ShipsStorage {
    func create(entity: ShipEntity) throws
    func read() throws -> [ShipEntity]
    func delete(entity: ShipEntity) throws
}
