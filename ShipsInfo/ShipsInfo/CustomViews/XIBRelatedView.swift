//
//  XIBRelatedView.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 19.12.24.
//

import UIKit

protocol LoadableFromNib {
    var nibName: String! { get }
}

class XIBRelatedView: UIView, LoadableFromNib {
    private(set) var nibName: String!
    
    private var view: UIView!
    
    func loadViewFromNib() -> UIView {
        guard let nibName else { return UIView() }
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self)[0] as! UIView
        
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
}
