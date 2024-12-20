//
//  ShipsAPIService.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 20.12.24.
//

import Foundation
import UIKit

protocol ShipsAPIService {
    var jsonDecoder: JSONDecoder { get }
    
    func getShipsData(stringURLRepresentation: String) async throws -> [ShipEntity]
}
