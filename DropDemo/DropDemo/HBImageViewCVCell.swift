//
//  HBImageViewCVCell.swift
//  HBImageSliderVC
//
//  Created by EricHo on 10/12/2015.
//  Copyright © 2015 EricHo. All rights reserved.
//

import UIKit
import SDWebImage
import FLAnimatedImage

class HBImageViewCVCell: UICollectionViewCell, UIScrollViewDelegate {
    @IBOutlet weak var imageview:FLAnimatedImageView!
    @IBOutlet weak fileprivate var activityView:UIActivityIndicatorView!

    @IBOutlet weak fileprivate var scrollView:UIScrollView? // can be not set (e.g. use in HBImageSliderVC)
    
    var imageLink:String? //For displaying image in FLAnimatedImageView - object reference checking in loading and setting in collection view cell (async call back reference checking)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageLink = nil
    }

    func setupCell(_ link:String, minZoomScale:CGFloat, maxZoomScale:CGFloat, scrollViewContentSize:CGSize) {
        
        //###############
        self.scrollView?.delegate = self
        //###############
        
        self.scrollView?.minimumZoomScale = minZoomScale
        self.scrollView?.maximumZoomScale = maxZoomScale
        self.scrollView?.contentSize = scrollViewContentSize
        self.scrollView?.zoomScale = 1.0
        self.clipsToBounds = true
        self.scrollView?.clipsToBounds = true
        self.scrollView?.isUserInteractionEnabled = true
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(HBImageViewCVCell.handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        self.imageview.isUserInteractionEnabled = true
        self.imageview.addGestureRecognizer(doubleTap)
        
        self.setupCell(link)
    }
    
    func setupCell(_ link:String) {
        
        self.imageLink = link
        
        if let url = URL(string: link) {
            
            self.displayImage(url: url, targetAnimatedImageView: self.imageview, activityView: self.activityView, enablePlaceHolderImage: false)
        
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        //print("--> \(NSStringFromClass(self.classForCoder)).\(__FUNCTION__)")
        
        return self.imageview
        /*
        for eachView in scrollView.subviews where ((eachView as? UIImageView) != nil) {
            return eachView
        }
        return nil
        */
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        //self.centerScrollContent()
    }
    
    func centerScrollContent(){
        
        let screenSize = self.scrollView!.bounds.size
        let boundsSize = CGSize(width: screenSize.width, height: screenSize.height )
        
        var contentsFrame = self.imageview.frame
        
        if (contentsFrame.size.width < boundsSize.width) {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0;
        }
        
        if (contentsFrame.size.height < boundsSize.height) {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        self.imageview.frame = contentsFrame;
    }
    
    // MARK: - Double tap to zoom in
    
    func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        if self.scrollView!.zoomScale >= 2 {
            self.scrollView!.setZoomScale(0.0, animated: true)
        }else{
            let  pointInView = sender.location(in: self.imageview)
            
            var newZoomScale = self.scrollView!.zoomScale * 2
            newZoomScale = min(newZoomScale, self.scrollView!.maximumZoomScale);
            
            let scrollViewSize = self.scrollView!.bounds.size;
            
            let w = scrollViewSize.width / newZoomScale;
            let h = scrollViewSize.height / newZoomScale;
            let x = pointInView.x - (w / 2.0);
            let y = pointInView.y - (h / 2.0);
            
            let rectToZoomTo = CGRect(x: x, y: y, width: w, height: h);
            
            self.scrollView!.zoom(to: rectToZoomTo, animated: true)
        }
    }
    
    deinit {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
    }
    

}
