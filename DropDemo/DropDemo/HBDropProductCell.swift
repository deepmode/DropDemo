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
    
    
    func setupCell(post:HBDropItem) {
        
        self.titleLabel?.text = post.title
        
        let link = post.thumbnail[ImageSizeType.small] ?? ""
        if let url = URL(string: link) {
            self.displayImage(url: url, targetAnimatedImageView: self.imageView, activityView: nil, enablePlaceHolderImage: true)
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    deinit {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
    }

}
