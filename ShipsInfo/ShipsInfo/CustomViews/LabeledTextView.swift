//
//  LabeledTextView.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 19.12.24.
//

import UIKit

@IBDesignable final class LabeledTextView: XIBRelatedView {
    override var nibName:String! {
        String(describing: LabeledTextView.self)
    }
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var textView: UITextView!
    
    @IBInspectable var labelText: String? {
        get {
            label.text
        }
        set {
            label?.text = newValue
        }
    }
    
    var content: [String]? {
        get {
            guard let textView,
                  let _ = textView.text
            else {
                return nil
            }
            
            let splitedText = textView.text.split(whereSeparator: { $0.isNewline })
            
            return splitedText.map({ String($0) })
        }
        set {
            guard let array = newValue
            else {
                textView?.text = nil
                return
            }
            
            var text = ""
            for (index, item) in array.enumerated() {
                text.append(item)
                if index != array.endIndex - 1 {
                    text.append("\n")
                }
            }
            
            textView.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
