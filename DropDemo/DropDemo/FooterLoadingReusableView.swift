//
//  FooterLoadingReusableView.swift
//  DropDemo
//
//  Created by Eric Ho on 29/5/2017.
//  Copyright © 2017 EricHo. All rights reserved.
//

import UIKit

class FooterLoadingReusableView: UICollectionReusableView {
    
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    deinit {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
    }
    
}
