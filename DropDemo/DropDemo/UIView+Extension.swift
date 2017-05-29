//
//  UIView+Extension.swift
//  DropDemo
//
//  Created by EricHo on 29/5/2017.
//  Copyright © 2017 EricHo. All rights reserved.
//

import Foundation
import UIKit

public extension UIView
{
    static func loadFromXib<T>() -> T where T: UIView
    {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "\(self)", bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? T else {
            fatalError("Could not load view from nib file.")
        }
        return view
    }
}
