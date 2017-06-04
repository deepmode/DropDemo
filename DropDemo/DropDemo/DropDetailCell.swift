//
//  DropDetailCell.swift
//  DropDemo
//
//  Created by Eric Ho on 3/6/2017.
//  Copyright © 2017 EricHo. All rights reserved.
//

import UIKit

class DropDetailCell: UITableViewCell {
    
    @IBOutlet weak var viewLeadingConstraint:NSLayoutConstraint!
    @IBOutlet weak var viewTrailingConstraint:NSLayoutConstraint!
    
    @IBOutlet weak var stackView:UIStackView!
    @IBOutlet weak var imageAspectRatioConstraint:NSLayoutConstraint!
    
    @IBOutlet weak var titleTopLabel:UILabel!
    @IBOutlet weak var titleLabel:UILabel!
    
    @IBOutlet weak var releaseDateTopLabel:UILabel!
    @IBOutlet weak var releaseDateLabel:UILabel!
    
    @IBOutlet weak var priceTopLabel:UILabel!
    @IBOutlet weak var priceLabel:UILabel!
    
    @IBOutlet weak var colorTopLabel:UILabel!
    @IBOutlet weak var colorLabel:UILabel!
    
    @IBOutlet weak var styleCodeTopLabel:UILabel!
    @IBOutlet weak var styleLabel:UILabel!
        
    @IBOutlet weak var detailText:UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    deinit {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
    }

    
    func setupCell(item:HBDropItem) {
        
        self.selectionStyle = .none
        
        
        self.titleLabel?.font = Layout.dropTitleFont
        self.titleLabel?.text = item.title
        
        self.releaseDateLabel?.text = item.date.displayDate
        
        self.priceLabel?.text =  "\(item.price.price) (\(item.price.currency))"
        
        self.colorLabel?.text = "BY2674"
        
        //adjust the textview padding inset (if not set, it will affect the height calculation)
        self.detailText?.textContainer.lineFragmentPadding = 0.0
        self.detailText?.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        self.detailText?.text = "The interest or the promise of prefab is nothing new, but it's been reignited, and gasoline continues to be poured on the fire, says Joseph Tanney of Resolution: 4 Architecture, a New York-based firm that has been developing modular housing systems since 2002. And because more architects are participating in this base, the level of design is increasing across the board. \n\nFirms such as Snøhetta -- known for their work on the Norwegian National Opera & Ballet and Bibliotheca Alexandrina -- are embracing the possibilities of this once-maligned form. We wanted to make quality architecture available to more people, says Snøhetta's Anne Cecilie Haug. If that all sounds a little expensive, major retailers are also getting into prefab -- including minimalist high street brand Muji -- who developed the Mujihut, coming soon in Japan."
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.viewLeadingConstraint?.constant = Layout.DropDetailCell.viewLeadingPadding(containerWidth: self.bounds.width)
        self.viewTrailingConstraint?.constant = Layout.DropDetailCell.viewTrailingPadding(containerWidth: self.bounds.width)
        
        //self.detailTextHeightConstraint?.constant = h
        
        
//        let cols = Layout.numberOfColumn(self.traitCollection.horizontalSizeClass)
//        if cols == 1 {
//            self.stackView?.axis = .vertical
//            self.stackView?.distribution = .fill
//            //self.imageAspectRatioConstraint?.isActive = true
//        } else {
//            self.stackView?.axis = .horizontal
//            self.stackView?.distribution = .fillEqually
//            //self.imageAspectRatioConstraint?.isActive = false
//            
//        }
    }
    
}
