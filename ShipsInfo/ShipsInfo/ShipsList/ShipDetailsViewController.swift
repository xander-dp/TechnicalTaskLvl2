//
//  ShipDetailsViewController.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 19.12.24.
//

import UIKit
import Combine

final class ShipDetailsViewController: UIViewController {
    private static let storyboardName = "Main"
    private var viewModel: ShipDetailsViewModel!
    
    private var cancellables = Set<AnyCancellable>()
    
    static func instantiate(viewModel: ShipDetailsViewModel) -> ShipDetailsViewController {
        let storyboard = UIStoryboard(name: Self.storyboardName, bundle: nil)
        let identifier = String(describing: ShipDetailsViewController.self)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as! ShipDetailsViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        guard let viewModel,
              let detailsView = self.view as? ShipDetailsView
        else { return }
        
        viewModel.$shipData
            .receive(on: DispatchQueue.main)
            .sink { item in
                detailsView.configureView(with: item)
            }
            .store(in: &cancellables)
    }
    
    @IBAction func closeDetailsController() {
        self.dismiss(animated: true)
    }
}
