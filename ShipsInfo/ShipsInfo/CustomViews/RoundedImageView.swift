//
//  UIImage+Rounding.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 19.12.24.
//

import UIKit

final class RoundedImageView: UIImageView {
    override var bounds: CGRect {
        didSet {
            self.makeRound()
        }
    }
    
    private func makeRound() {
        let measure = self.bounds.width < self.bounds.height ? self.bounds.width : self.bounds.height
        let mask = CAShapeLayer()
        let maskRectX = self.bounds.midX - measure / 2
        let maskRectY = self.bounds.midY - measure / 2
        mask.path = UIBezierPath(
            ovalIn: CGRect(
                x: maskRectX,
                y: maskRectY,
                width: measure,
                height: measure
            )
        ).cgPath
        self.layer.mask = mask
    }
}
