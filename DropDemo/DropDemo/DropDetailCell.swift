//
//  DropDetailCell.swift
//  DropDemo
//
//  Created by Eric Ho on 3/6/2017.
//  Copyright © 2017 EricHo. All rights reserved.
//

import UIKit

class DropDetailCell: UITableViewCell {
    
    @IBOutlet weak var stackView:UIStackView!
    @IBOutlet weak var imageAspectRatioConstraint:NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let cols = Layout.numberOfColumn(self.traitCollection.horizontalSizeClass)
        if cols == 1 {
            self.stackView?.axis = .vertical
            self.stackView?.distribution = .fill
            self.imageAspectRatioConstraint?.isActive = true
        } else {
            self.stackView?.axis = .horizontal
            self.stackView?.distribution = .fillEqually
            self.imageAspectRatioConstraint?.isActive = false
            
        }
    }
    
}
