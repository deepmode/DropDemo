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
    @IBOutlet weak var dateLabel:UILabel!
    
    @IBOutlet weak var stackViewTopPaddingConstraint:NSLayoutConstraint!
    @IBOutlet weak var stackViewBottomPaddingConstraint:NSLayoutConstraint!
    @IBOutlet weak var stackViewLeadingPaddingConstraint:NSLayoutConstraint!
    @IBOutlet weak var stackViewTrailingPaddingConstraint:NSLayoutConstraint!
    
    
    @IBOutlet weak var titleLeadingPaddingConstraint:NSLayoutConstraint!
    @IBOutlet weak var titleTrailingPaddingConstraint:NSLayoutConstraint!

    @IBOutlet weak var toolViewLeadingPaddingConstraint:NSLayoutConstraint!
    @IBOutlet weak var toolViewTrailingPaddingConstraint:NSLayoutConstraint!
    
    
    @IBOutlet weak var  belowImageSpaceHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var  toolViewHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var  belowToolViewSpaceHeightConstraint:NSLayoutConstraint!
    
    
    
    func setupCell(post:HBDropItem) {
        
        self.titleLabel?.text = post.title
        self.titleLabel?.font = Layout.dropTitleFont
        self.dateLabel?.text =  "Release Date: \(post.date.displayDate)" //"Release Date: \(post.date.date)"
        
        let link = post.thumbnail[ImageSizeType.small] ?? ""
        if let url = URL(string: link) {
            self.displayImage(url: url, targetAnimatedImageView: self.imageView, activityView: nil, enablePlaceHolderImage: true)
        }
        
        //must call this to redraw the cell (e.g. handle the changing in size)
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        //For StackView
        self.stackViewTopPaddingConstraint.constant = Layout.interStackViewTopPadding
        self.stackViewBottomPaddingConstraint.constant = Layout.interStackViewBottomPadding
        self.stackViewLeadingPaddingConstraint.constant = Layout.interStackViewLeadingPadding
        self.stackViewTrailingPaddingConstraint.constant = Layout.interStackViewTrailingPadding
        
        
        //For inner cell content (e.g. title, tool view etc)
        let leftPadding = Layout.cellTitleLeadingPadding
        let rightPadding = Layout.cellTitleTrailingPadding
    
        self.titleLeadingPaddingConstraint?.constant = leftPadding
        self.titleTrailingPaddingConstraint?.constant = rightPadding
        
        self.toolViewLeadingPaddingConstraint?.constant = leftPadding
        self.toolViewTrailingPaddingConstraint?.constant = rightPadding
        
        
        //For single column case - dynamic calculate the cell height
        self.belowImageSpaceHeightConstraint?.constant = Layout.DropCell.belowImageSpaceHeight
        self.toolViewHeightConstraint?.constant = Layout.DropCell.toolViewHeight
        //this number var depend on single or multi columns
        self.belowToolViewSpaceHeightConstraint?.constant = Layout.DropCell.belowToolViewSpaceHeight
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    deinit {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
    }

}
