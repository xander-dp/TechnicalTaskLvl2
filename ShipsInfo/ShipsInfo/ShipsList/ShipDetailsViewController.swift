//
//  ShipDetailsViewController.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 19.12.24.
//

import UIKit

final class ShipDetailsViewController: UIViewController {
    var entity: ShipEntity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let entity,
              let detailsView = self.view as? ShipDetailsView
        else { return }
        
        detailsView.configureView(with: entity)
    }
    
    @IBAction func closeDetailsController() {
        self.dismiss(animated: true)
    }
}
