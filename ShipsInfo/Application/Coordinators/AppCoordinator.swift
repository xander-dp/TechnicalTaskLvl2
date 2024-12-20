//
//  AppCoordinator.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 19.12.24.
//

import UIKit

final class AppCoordinator {
    private let window: UIWindow
    
    private var shipsListCoordinator: ShipsListCoordinator?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        startShipsListCoordinator()
    }
    
    private func startShipsListCoordinator() {
        self.shipsListCoordinator = ShipsListCoordinator() { [weak self] in
            self?.shipsListCoordinator = nil
        }
        
        self.shipsListCoordinator?.start()
        
        if let viewController = shipsListCoordinator?.rootViewController {
            self.window.rootViewController = viewController
        }
    }
}
