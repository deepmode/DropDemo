//
//  HBScrollView.swift
//  Hypebeast
//
//  Created by EricHo on 15/12/2015.
//  Copyright © 2015 EricHo. All rights reserved.
//

import UIKit

final class HBScrollView: UIScrollView{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superview?.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superview?.touchesMoved(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superview?.touchesCancelled(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superview?.touchesEnded(touches, with: event)
    }

}
