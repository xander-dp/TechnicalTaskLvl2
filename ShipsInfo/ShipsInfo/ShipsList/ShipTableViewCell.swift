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
    @IBOutlet weak var shipImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    private var entity: ShipEntityRepresentation! {
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
    
    override func layoutSubviews() {
        setImageCornerRadius()
    }
    
    func configureCell(with entity: ShipEntity) {
        self.entity = ShipEntityRepresentation(with: entity)
    }
    
    private func configureLayer() {
        self.contentWrapperView.layer.masksToBounds = true
        self.contentWrapperView.layer.cornerRadius = 12
        self.contentWrapperView.layer.borderColor = UIColor.systemCyan.cgColor
        self.contentWrapperView.layer.borderWidth = 3
    }
    
    private func setImageCornerRadius() {
        guard let iv = self.shipImageView else { return }
        
        let measure = iv.bounds.width < iv.bounds.height ? iv.bounds.width : iv.bounds.height
        let mask = CAShapeLayer()
        let maskRectX = iv.bounds.midX - measure / 2
        let maskRectY = iv.bounds.midY - measure / 2
        mask.path = UIBezierPath(
            ovalIn: CGRect(
                x: maskRectX,
                y: maskRectY,
                width: measure,
                height: measure
            )
        ).cgPath
        iv.layer.mask = mask
    }
}

fileprivate struct ShipEntityRepresentation {
    let name: String?
    let type: String
    let year: String
    
    init(with entity: ShipEntity) {
        self.name = entity.name
        self.type = entity.type ?? "-"
        self.year = entity.builtYear != nil ? String(entity.builtYear!) : "-"
    }
}
