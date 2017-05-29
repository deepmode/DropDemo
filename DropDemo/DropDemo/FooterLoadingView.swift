//
//  FooterLoadingView.swift
//  DropDemo
//
//  Created by EricHo on 29/5/2017.
//  Copyright © 2017 EricHo. All rights reserved.
//

import UIKit

class FooterLoadingView: UIView {
    
    @IBOutlet private var view: FooterLoadingView!
    @IBOutlet weak var loadingSpinner:UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if self.subviews.count == 0 {
            commonInit()
        }
    }
    
    private func commonInit() {
        //TODO: Do some stuff
        
        // 1. Load the nib
        // 2. Add the 'FooterLoadingView' to self
        
        if let v = UINib(nibName: "FooterLoadingView", bundle: nil).instantiate(withOwner: self, options: nil).first as? FooterLoadingView {
            v.frame = self.bounds
            v.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            self.addSubview(v)
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
