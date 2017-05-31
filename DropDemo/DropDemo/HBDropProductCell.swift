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
    @IBOutlet weak var titleLabel:InsetLabel!
    
    @IBOutlet weak var contentLeadingPaddingConstraint:NSLayoutConstraint!
    @IBOutlet weak var contentTrailingPaddingConstraint:NSLayoutConstraint!
    
    
    func setupCell(post:HBDropItem) {
        
        let currentHSizeClass = self.traitCollection.horizontalSizeClass
        let leftPadding = Layout.cellTitleLeadingPadding(currentHSizeClass)
        let rightPadding = Layout.cellTitleTrailingPadding(currentHSizeClass)
        let topPadding = Layout.cellTitleTopPadding(currentHSizeClass)
        let bottomPadding = Layout.cellTitleBottomPadding(currentHSizeClass)
        
        let inset = UIEdgeInsets(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding)
        
        self.titleLabel?.inset = inset
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
        
        let inset = UIEdgeInsets(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding)
    
        self.titleLabel?.inset = inset
        
        self.contentLeadingPaddingConstraint?.constant = leftPadding
        self.contentTrailingPaddingConstraint?.constant = rightPadding
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    deinit {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
    }

}
