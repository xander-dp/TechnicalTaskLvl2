//
//  SceneDelegate.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 17.12.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)

        appCoordinator = AppCoordinator(window: window!)
        appCoordinator?.start()

        window?.makeKeyAndVisible()
    }
}

