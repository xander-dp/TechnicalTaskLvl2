//
//  ShipDetailsViewModel.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 19.12.24.
//

import Foundation

final class ShipDetailsViewModel: ObservableObject {
    @Published var shipData: ShipEntityUIRepresentation
    
    init(shipEntity: ShipEntity) {
        self.shipData = ShipEntityUIRepresentation(with: shipEntity)
    }
}
