//
//  InsetLabel.swift
//  DropDemo
//
//  Created by EricHo on 31/5/2017.
//  Copyright © 2017 EricHo. All rights reserved.
//

import UIKit

@IBDesignable
class InsetLabel: UILabel {

    var inset:UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    convenience init(text:String, inset: UIEdgeInsets? = nil) {
        self.init()
        self.text = text
        
        if let _ = inset {
            self.inset = inset!
        }
    }
    
    override func drawText(in rect: CGRect) {
        //let insets: UIEdgeInsets = UIEdgeInsets(top: inset.top, left: inset.left, bottom: inset.bottom, right: inset.right)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, self.inset))
    }
    
    override var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        
        let hSizeClass = self.traitCollection.horizontalSizeClass
        let leftPadding = Layout.cellTitleLeadingPadding(hSizeClass)
        let rightPadding = Layout.cellTitleLeadingPadding(hSizeClass)
        let availableWidth = self.frame.size.width - leftPadding - rightPadding
        let h = self.text?.heightWithConstrainedWidth(availableWidth, font: self.font) ?? 0
        let textHeight = CGFloat(ceil(Double(h)))
        
        intrinsicSuperViewContentSize.height = inset.top + inset.bottom + textHeight
        //intrinsicSuperViewContentSize.width += a + b
        //intrinsicSuperViewContentSize.height += inset.top + inset.bottom
        //intrinsicSuperViewContentSize.width += inset.left + inset.right
        return intrinsicSuperViewContentSize
    }


}
