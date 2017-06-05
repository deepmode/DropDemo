//
//  HBZoomableImageSliderVC.swift
//  Hypebeast
//
//  Created by EricHo on 16/12/2015.
//  Copyright © 2015 EricHo. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell_HBZoomableImageView"

class HBZoomableImageSliderVC: HBImageSliderVC {
    
    var selectedPage:Int = 0 {
        willSet {
            if newValue < 0 { self.selectedPage = 0 } else { self.selectedPage = newValue }
        }
    }
    
    var minZoomScale:CGFloat = 1.0 {
        willSet {
            if newValue <= 0.0 { self.minZoomScale = 1.0 } else { self.minZoomScale = newValue }
        }
    }
    
    var maxZoomScale:CGFloat = 1.0 {
        willSet {
            if newValue <= 0.0 { self.maxZoomScale = 1.0 } else { self.maxZoomScale = newValue }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.pageControl.currentPage = self.selectedPage
        
        //set the collection view's alpha to 0 and animaite in view will appear 
        //reason: hide the scrolling of collection view cell
        self.collectionView.alpha = 0.0
        
        
        //###############################
        //hide the status bar when the view appear
        self.hideStatusBar()
        //###############################
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.photosLink.count > 0 {
            let index = self.pageControl.currentPage
            self.collectionView?.scrollToItem(at: IndexPath(row: index, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        }

        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.collectionView.alpha = 1.0
            }, completion: { (finished) -> Void in
                
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //###############################
        //IMPORTANT: related to orientation support, restore to the correct orientation after any presented VC.
        //for restoring the viewController in the right orientation (e.g. if the presented VC has rotate and than dismiss) - Check the method in func application (application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?)
        //For iphone, it only support Portrait in most of the screen except image gallary or video play back which rotation of screen is allow.
        //For iPad, it will support different orientation
        //For setting the UIDevice user interface orientation to portrait, this allow any VC under the presented VC (e.g. image gallary) to rotate back to the our supported orientation (which is Portrait)
    
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        default:
            break
        }
        //###############################
        
        
        //###############################
        //show the status bar when the view disappear
        self.showStatusBar()
        //###############################
        
    }

    // MARK: -- show & hide status bar methods
    fileprivate func hideStatusBar() {
        //UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.fade)
        UIView.animate(withDuration: 0.5) { () -> Void in
            UIApplication.shared.isStatusBarHidden = true
        }
    }
    fileprivate func showStatusBar() {
        //UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.fade)
        UIView.animate(withDuration: 0.5) { () -> Void in
            UIApplication.shared.isStatusBarHidden = false
        }
    }
    
    // MARK: -
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
        print("--# CollectionView size: \(self.collectionView.bounds), return size: \((self.collectionView?.bounds.size)!)")
        return (self.collectionView?.bounds.size)!

    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.photosLink.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? HBImageViewCVCell
        //print("--# cell bounds: \(cell?.bounds)")
        //print("--# cell scrollview bounds: \(cell?.scrollView.bounds)")
        //print("--# cell scrollview content size: \(cell?.scrollView.contentSize)")
        
        cell?.setupCell(self.photosLink[indexPath.row],minZoomScale: self.minZoomScale, maxZoomScale: self.maxZoomScale, scrollViewContentSize: (cell?.bounds.size)!)

        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.imgsScrlViewLongPressed(_:)))
        cell?.imageview.isUserInteractionEnabled = true
        cell?.imageview.addGestureRecognizer(longPressRecognizer)
        
        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
    }
}

