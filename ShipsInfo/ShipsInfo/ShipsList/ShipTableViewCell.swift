//
//  ShipTableViewCell.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 18.12.24.
//

import UIKit

final class ShipTableViewCell: UITableViewCell {
    static let reuseIdentifier = "shipCellReuseIdentifier"
    
    @IBOutlet weak var contentWrapperView: UIView!
    @IBOutlet weak var shipImageView: RoundedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    private var entity: ShipEntityUIRepresentation! {
        didSet {
            guard entity != nil else { return }
            
            nameLabel?.text = entity.name
            typeLabel?.text = entity.type
            yearLabel?.text = entity.year
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayer()
    }
    
    func configureCell(with entity: ShipEntity) {
        self.entity = ShipEntityUIRepresentation(with: entity)
    }
    
    private func configureLayer() {
        self.contentWrapperView.layer.masksToBounds = true
        self.contentWrapperView.layer.cornerRadius = 12
        self.contentWrapperView.layer.borderColor = UIColor.systemCyan.cgColor
        self.contentWrapperView.layer.borderWidth = 3
    }
}
