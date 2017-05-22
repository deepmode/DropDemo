//
//  FeatureCell.swift
//  MultiCollection
//
//  Created by Eric Ho on 13/8/2016.
//  Copyright © 2016 E H. All rights reserved.
//

import UIKit

class FeatureCell: UICollectionViewCell {
    
    @IBOutlet weak var textLabel:UILabel!
    
    fileprivate var title:String? {
        didSet {
            self.textLabel?.text = title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(_ title:String) {
        self.title = title
    }
}
