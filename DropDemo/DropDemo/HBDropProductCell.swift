//
//  HBDropProductCell.swift
//  DropDemo
//
//  Created by EricHo on 29/5/2017.
//  Copyright © 2017 EricHo. All rights reserved.
//

import UIKit
import SDWebImage
import FLAnimatedImage

class HBDropProductCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView:FLAnimatedImageView!
    @IBOutlet weak var titleLabel:UILabel!
    
    @IBOutlet weak var titleLeadingPaddingConstraint:NSLayoutConstraint!
    @IBOutlet weak var titleTrailingPaddingConstraint:NSLayoutConstraint!
    
    @IBOutlet weak var toolViewLeadingPaddingConstraint:NSLayoutConstraint!
    @IBOutlet weak var toolViewTrailingPaddingConstraint:NSLayoutConstraint!
    
    
    
    func setupCell(post:HBDropItem) {
        
        self.titleLabel?.text = post.title
        
        let link = post.thumbnail[ImageSizeType.small] ?? ""
        if let url = URL(string: link) {
            self.displayImage(url: url, targetAnimatedImageView: self.imageView, activityView: nil, enablePlaceHolderImage: true)
        }
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let currentHSizeClass = self.traitCollection.horizontalSizeClass
        let leftPadding = Layout.cellTitleLeadingPadding(currentHSizeClass)
        let rightPadding = Layout.cellTitleTrailingPadding(currentHSizeClass)
        let topPadding = Layout.cellTitleTopPadding(currentHSizeClass)
        let bottomPadding = Layout.cellTitleBottomPadding(currentHSizeClass)
    
        //self.titleLabel?.inset = inset
        
        self.titleLeadingPaddingConstraint?.constant = leftPadding
        self.titleTrailingPaddingConstraint?.constant = rightPadding
        
        self.toolViewLeadingPaddingConstraint?.constant = leftPadding
        self.toolViewTrailingPaddingConstraint?.constant = rightPadding
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    deinit {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
    }

}
