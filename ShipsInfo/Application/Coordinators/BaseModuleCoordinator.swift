//
//  BaseModuleCoordinator.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 19.12.24.
//

import UIKit

protocol BaseModuleCoordinator {
    var finishAction: () -> Void { get }
    var rootViewController: UIViewController? { get }
    
    func start()
}
