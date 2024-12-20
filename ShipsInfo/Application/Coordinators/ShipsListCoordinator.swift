//
//  ShipsListCoordinator.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 19.12.24.
//

import UIKit

final class ShipsListCoordinator: BaseModuleCoordinator {
    var rootViewController: UIViewController? {
        shipsListViewController
    }
    let finishAction: () -> Void

    private weak var shipsListViewController: ShipsListViewController?

    init(finishAction: @escaping () -> Void) {
        self.finishAction = finishAction
    }
    
    func start() {
        let viewModel = ShipsListViewModel()
        self.shipsListViewController = ShipsListViewController.instantiate(viewModel: viewModel)
        
        self.shipsListViewController?.delegate = self
    }
}

extension ShipsListCoordinator: ShipsViewControllerDelegate {
    func didSelectItem(_ item: ShipEntity) {
        presentDetailController(with: item)
    }
    
    func viewControllerIsDeiniting(_ sender: ShipsListViewController) {
        self.finishAction()
    }
}

private extension ShipsListCoordinator {
    func presentDetailController(with item: ShipEntity) {
        let viewModel = ShipDetailsViewModel(shipEntity: item)
        let shipDetailsViewController = ShipDetailsViewController.instantiate(viewModel: viewModel)
        self.rootViewController?.present(shipDetailsViewController, animated: true)
    }
}
