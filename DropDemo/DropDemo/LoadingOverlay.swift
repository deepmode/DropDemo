//
//  LoadingOverlay.swift
//  Hypebeast
//
//  Created by Eric Ho on 1/5/2017.
//  Copyright © 2017 EricHo. All rights reserved.
//

import Foundation
import UIKit

public class LoadingOverlay{
    
    private var overlayView = UIView()
    private var activityIndicator = UIActivityIndicatorView()
    
//    class var shared: LoadingOverlay {
//        struct Static {
//            static let instance: LoadingOverlay = LoadingOverlay()
//        }
//        return Static.instance
//    }
//    
//    public func showOverlay(view: UIView) {
//        overlayView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
//        overlayView.center = view.center
//        overlayView.backgroundColor = UIColor(white: 0, alpha: 0.7)
////        overlayView.clipsToBounds = true
////        overlayView.layer.cornerRadius = 10
//        
//        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//        activityIndicator.activityIndicatorViewStyle = .white
//        activityIndicator.center =  CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
//        
//        overlayView.addSubview(activityIndicator)
//        view.addSubview(overlayView)
//        
//        activityIndicator.startAnimating()
//    }
//    
//    public func hideOverlayView() {
//        activityIndicator.stopAnimating()
//        overlayView.removeFromSuperview()
//    }
    
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    init(){
        self.overlayView = UIView()
        self.activityIndicator = UIActivityIndicatorView()
        
        overlayView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        overlayView.backgroundColor = UIColor(white: 0, alpha: 0.1)
//        overlayView.clipsToBounds = true
//        overlayView.layer.cornerRadius = 10
//        overlayView.layer.zPosition = 1
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        activityIndicator.activityIndicatorViewStyle = .gray
        overlayView.addSubview(activityIndicator)
    }
    
    //note: if no view is provided, we will use the window's view
    public func showOverlay(view: UIView? = nil) {
        let targetView = view ?? UIApplication.shared.windows.first!
    
        overlayView.center = targetView.center
        overlayView.bounds = targetView.bounds
        activityIndicator.center =  CGPoint(x: targetView.bounds.width / 2, y: targetView.bounds.height / 2)
        activityIndicator.startAnimating()
        targetView.addSubview(overlayView)
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}
