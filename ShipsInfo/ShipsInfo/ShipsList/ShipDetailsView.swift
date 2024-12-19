//
//  ShipDetailsView.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 19.12.24.
//

import UIKit

final class ShipDetailsView: UIView {
    
    @IBOutlet weak var shipImageView: RoundedImageView!
    @IBOutlet weak var nameLabel: DataLabel!
    @IBOutlet weak var typeLabel: DataLabel!
    @IBOutlet weak var yearLabel: DataLabel!
    @IBOutlet weak var weightLabel: DataLabel!
    @IBOutlet weak var portLabel: DataLabel!
    @IBOutlet weak var rolesTextView: LabeledTextView!
    
    private var entity: ShipEntityUIRepresentation! {
        didSet {
            guard entity != nil else { return }
            
            nameLabel?.valueText = entity.name
            typeLabel?.valueText = entity.type
            yearLabel?.valueText = entity.year
        }
    }
    
    func configureView(with entity: ShipEntity) {
        self.entity = ShipEntityUIRepresentation(with: entity)
    }
}
