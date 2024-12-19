//
//  DataLabel.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 19.12.24.
//

import UIKit

@IBDesignable final class DataLabel: XIBRelatedView {
    override var nibName:String! {
        String(describing: DataLabel.self)
    }
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var value: UILabel!
    
    @IBInspectable var fontSize: CGFloat {
        get {
            guard let value,
                  let _ = value.font
            else { return UIFont.systemFontSize }
            
            return value.font.pointSize
        }
        set(size) {
            guard let label,
                  let value,
                  let _ = label.font,
                  let _ = value.font
            else { return }
            
            label.font = label.font.withSize(size)
            value.font = value.font.withSize(size)
        }
    }
    
    @IBInspectable var labelText: String? {
        get {
            label.text
        }
        set {
            label?.text = newValue
        }
    }
    
    @IBInspectable var valueText: String? {
        get {
            value.text
        }
        set {
            value?.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
