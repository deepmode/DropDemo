//
//  DropDetailCell.swift
//  DropDemo
//
//  Created by Eric Ho on 3/6/2017.
//  Copyright © 2017 EricHo. All rights reserved.
//

import UIKit

class DropDetailCell: UITableViewCell {
    
    fileprivate weak var mediaContainerTopConstraint: NSLayoutConstraint!
    fileprivate weak var mediaContainerBottomConstraint: NSLayoutConstraint!
    fileprivate weak var mediaContainerLeadingConstraint: NSLayoutConstraint!
    fileprivate weak var mediaContainerTrailingConstraint: NSLayoutConstraint!
    
    
    @IBOutlet fileprivate weak var viewLeadingConstraint:NSLayoutConstraint!
    @IBOutlet fileprivate weak var viewTrailingConstraint:NSLayoutConstraint!
    
    @IBOutlet fileprivate weak var stackView:UIStackView!
    
    @IBOutlet fileprivate weak var mediaViewAspectRatioConstraint:NSLayoutConstraint!
    @IBOutlet fileprivate weak var mediaViewContainer:UIView!  //This view will hold a imageVC'c
    
    @IBOutlet fileprivate weak var titleTopLabel:UILabel!
    @IBOutlet fileprivate weak var titleLabel:UILabel!
    
    @IBOutlet fileprivate weak var releaseDateTopLabel:UILabel!
    @IBOutlet fileprivate weak var releaseDateLabel:UILabel!
    
    @IBOutlet fileprivate weak var priceTopLabel:UILabel!
    @IBOutlet fileprivate weak var priceLabel:UILabel!
    
    @IBOutlet fileprivate weak var colorTopLabel:UILabel!
    @IBOutlet fileprivate weak var colorLabel:UILabel!
    
    @IBOutlet fileprivate weak var styleCodeTopLabel:UILabel!
    @IBOutlet fileprivate weak var styleLabel:UILabel!
        
    @IBOutlet fileprivate weak var detailText:UITextView!
    
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
        
        self.detailText?.text = Layout.testText
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addHostedView(_ hostedView:UIView) {
        
        let topPadding:CGFloat = 0.0
        let bottomPadding:CGFloat = 0.0
        let leadingPadding:CGFloat = 0.0
        let trailingPadding:CGFloat = 0.0
        
        
        self.mediaViewContainer.addSubview(hostedView)
        hostedView.translatesAutoresizingMaskIntoConstraints = false
        
        self.mediaContainerTopConstraint = NSLayoutConstraint(item: hostedView, attribute: .top, relatedBy: .equal, toItem: self.mediaViewContainer, attribute: .top, multiplier: 1.0, constant: topPadding)
        
        
        self.mediaContainerBottomConstraint = NSLayoutConstraint(item: hostedView, attribute: .bottom, relatedBy: .equal, toItem: self.mediaViewContainer, attribute: .bottom, multiplier: 1.0, constant: -bottomPadding)
        self.mediaContainerLeadingConstraint = NSLayoutConstraint(item: hostedView, attribute: .leading, relatedBy: .equal, toItem: self.mediaViewContainer, attribute: .leading, multiplier: 1.0, constant: leadingPadding)
        self.mediaContainerTrailingConstraint = NSLayoutConstraint(item: hostedView, attribute: .trailing, relatedBy: .equal, toItem: self.mediaViewContainer, attribute: .trailing, multiplier: 1.0, constant: -trailingPadding)
        
        self.mediaContainerBottomConstraint.priority = 999
        NSLayoutConstraint.activate([self.mediaContainerTopConstraint, mediaContainerBottomConstraint,mediaContainerLeadingConstraint,mediaContainerTrailingConstraint])
        
        self.updateUI()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.viewLeadingConstraint?.constant = Layout.DropDetailCell.viewLeadingPadding(containerWidth: self.bounds.width)
        self.viewTrailingConstraint?.constant = Layout.DropDetailCell.viewTrailingPadding(containerWidth: self.bounds.width)
        
        self.updateUI()
        
        
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
    
    fileprivate func updateUI() {
        self.mediaContainerTopConstraint?.constant = 0.0
        self.mediaContainerBottomConstraint?.constant = 0.0
        self.mediaContainerTopConstraint?.constant = 0.0
        self.mediaContainerTrailingConstraint?.constant = 0.0
    }
    
}
