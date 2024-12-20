//
//  ShipEntityMO.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 20.12.24.
//

import Foundation
import CoreData


final class ShipEntityMO: NSManagedObject, Identifiable {
    @NSManaged public var name: String
    @NSManaged public var type: String?
    @NSManaged public var builtYear: NSNumber?
    @NSManaged public var weight: NSNumber?
    @NSManaged public var homePort: String?
    @NSManaged public var roles: [String]
    @NSManaged public var image: String?

    static let entityName = "ShipEntity"
    @nonobjc public static func fetchRequest() -> NSFetchRequest<ShipEntityMO> {
        return NSFetchRequest<ShipEntityMO>(entityName: "ShipEntity")
    }

    convenience init(context: NSManagedObjectContext, with entity: ShipEntity) {
        self.init(context: context)

        self.name = entity.name
        self.type = entity.type
        self.builtYear = entity.builtYear != nil ? NSNumber(value: entity.builtYear!) : nil
        self.weight = entity.weight != nil ? NSNumber(value: entity.weight!) : nil
        self.homePort = entity.homePort
        self.roles = entity.roles
        self.image = entity.image
    }
    
    func toShipEntity() -> ShipEntity {
        ShipEntity(
            name: self.name,
            type: self.type,
            builtYear: self.builtYear?.intValue,
            weight: self.builtYear?.intValue,
            homePort: self.homePort,
            image: self.image,
            roles: self.roles
        )
    }
}
