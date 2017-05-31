//
//  String+Extension.swift
//  Hypebeast
//
//  Created by EricHo on 14/1/2016.
//  Copyright © 2016 EricHo. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    //reference: http://stackoverflow.com/questions/30450434/figure-out-size-of-uilabel-based-on-string-in-swift
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    //create shaddowEffect of NSAttributedString from String
    func shaddowEffect(_ pickedFont:UIFont?, foregroundColor:UIColor, shadowColor:UIColor?) -> NSAttributedString? {
        if let titleFont = pickedFont {
            let shadow : NSShadow = NSShadow()
            shadow.shadowOffset = CGSize(width: 1.0, height: 1.0)
            shadow.shadowColor = shadowColor
            
            let attributes = [
                NSFontAttributeName : titleFont,
                //NSUnderlineStyleAttributeName : 1,
                NSForegroundColorAttributeName : foregroundColor,
                NSTextEffectAttributeName : NSTextEffectLetterpressStyle,
                NSStrokeWidthAttributeName : 2.0,
                NSShadowAttributeName : shadow] as [String : Any]
            
            return NSAttributedString(string: self, attributes: attributes)
        }
        return nil
    }
}
