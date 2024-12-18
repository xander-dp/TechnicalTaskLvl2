//
//  ShipEntity.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 17.12.24.
//
//struct implemented according to schema https://github.com/r-spacex/SpaceX-API/blob/master/docs/ships/v4/schema.md

struct ShipEntity: Codable, Hashable {
    let name: String
    let type: String?
    let builtYear: Int?
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case type
        case builtYear = "year_built"
        case image
    }
}
