//
//  ShipsStorageCoreData.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 20.12.24.
//

import CoreData

fileprivate let uniqueProperty = "name"

final class ShipsStorageCoreData: ShipsStorage {
    private let container: NSPersistentContainer
    
    var managedContext: NSManagedObjectContext {
        return self.container.viewContext
    }
    
    init(name: String) {
        self.container = NSPersistentContainer(name: name)
        self.container.viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyStoreTrumpMergePolicyType)
        
        self.container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    func write(entities: [ShipEntity]) throws {
        for entity in entities {
            _ = ShipEntityMO(context: self.managedContext, with: entity)
        }
        try self.managedContext.save()
    }
    
    func read() throws -> [ShipEntity] {
        let fetchRequest = ShipEntityMO.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(
            key: uniqueProperty,
            ascending: true,
            selector: #selector(NSString.localizedStandardCompare)
        )]
        
        let data = try self.managedContext.fetch(fetchRequest)
        return data.map { $0.toShipEntity() }
    }
    
    func delete(entity: ShipEntity) throws {
        let entityMO = try getEntity(with: entity.name)
        
        self.managedContext.delete(entityMO)
        try managedContext.save()
    }
    
    private func getEntity(with name: String) throws -> ShipEntityMO {
        let lhs = NSExpression(forConstantValue: name)
        let rhs = NSExpression(forKeyPath: uniqueProperty)
        let predicate = NSComparisonPredicate(
            leftExpression: lhs,
            rightExpression: rhs,
            modifier: .direct,
            type: .equalTo
        )
        
        let request = ShipEntityMO.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        
        let fetchResult = try self.managedContext.fetch(request)
        
        guard let entityFound = fetchResult.first else {
            throw NSError(
                domain: Bundle.main.bundleIdentifier ?? "",
                code: 404,
                userInfo: ["Entity not found" : name]
            )
        }
        
        return entityFound
    }
}
