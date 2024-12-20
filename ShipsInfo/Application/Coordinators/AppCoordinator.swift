//
//  AppCoordinator.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 19.12.24.
//

import UIKit

fileprivate let dataModelName = "ShipsInfo"
fileprivate let mainApiLink = "https://api.spacexdata.com/v4/ships"

final class AppCoordinator {
    private let window: UIWindow
    
    private var shipsListCoordinator: ShipsListCoordinator?
    
    private let dataStorage: ShipsStorage
    private let dataRequester: DataHTTPRequester
    private let apiService: ShipsAPIService
    private let dataService: ShipsDataService
    
    init(window: UIWindow) {
        self.window = window
        
        self.dataStorage = ShipsStorageCoreData(name: dataModelName)
        self.dataRequester = ShipsDataHTTPRequester()
        self.apiService = ShipsAPIServiceImplementation(dataRequester: self.dataRequester)
        self.dataService = ShipsDataServiceImplementation(
            dataStorage: self.dataStorage,
            apiService: self.apiService,
            apiLink: mainApiLink
        )
    }
    
    func start() {
        startShipsListCoordinator()
    }
    
    private func startShipsListCoordinator() {
        self.shipsListCoordinator = ShipsListCoordinator(dataService: self.dataService) { [weak self] in
            self?.shipsListCoordinator = nil
        }
        
        self.shipsListCoordinator?.start()
        
        if let viewController = shipsListCoordinator?.rootViewController {
            self.window.rootViewController = viewController
        }
    }
}
