//
//  Untitled.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 19.12.24.
//

struct ShipEntityUIRepresentation {
    let name: String
    let type: String
    let year: String
    let weight: String
    let homePort: String
    let roles: [String]
    
    init(with entity: ShipEntity) {
        self.name = entity.name
        self.type = entity.type ?? "-"
        self.year = entity.builtYear != nil ? String(entity.builtYear!) : "-"
        self.weight = entity.weight != nil ? String(entity.weight!) : "-"
        self.homePort = entity.homePort ?? "-"
        self.roles = entity.roles
    }
}
