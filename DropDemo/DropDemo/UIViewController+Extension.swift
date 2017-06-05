//
//  UIViewController+Extension.swift
//  Hypebeast
//
//  Created by Eric Ho on 13/12/2015.
//  Copyright © 2015 EricHo. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

extension UIViewController {
    
    var contentViewController: UIViewController? {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController
        } else {
            return self
        }
    }
    
    func alertWithErrorInMainQueue(_ error:Error?) {
        let delayTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime, execute: { [weak self] in
            //alert user if there are any error
            if let errorMessage = error?.localizedDescription {
                self?.alertWithTitle("Alert", message: errorMessage, okTitle: "ok")
            }
        })
    }
    
    func alertWithTitle(_ title:String, message:String, okTitle:String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        ac.addAction(
            UIAlertAction(title: okTitle, style: UIAlertActionStyle.default, handler: { (alertAction) -> Void in /* code goes here */})
        )
        self.present(ac, animated: true) { () -> Void in}
    }
    
    func openURLinkInSFViewController(_ url:URL, fromViewController:UIViewController?) {
        if let fromVC = fromViewController {
            if #available(iOS 9.0, *) {
                if UIApplication.shared.canOpenURL(url) {
                    //Important note: make sure to check the url using canOpenURL as SFSafariViewController might crash if it can't open the provide url.
                    let svc = SFSafariViewController(url:url,  entersReaderIfAvailable: false)
                    fromVC.present(svc, animated: true, completion: nil)
                    return
                }
            } else {
                // Fallback on earlier versions
                //UIApplication.sharedApplication().openURL(url)
            }
        } else {
            // Fallback if fromViewController is nil
            //UIApplication.sharedApplication().openURL(url)
        }
        // Fallback for all other case
        // Fallback if fromViewController is nil or canOpenURL is false or iOS 9.0 below
        UIApplication.shared.openURL(url)
    }
    
//    func isModal() -> Bool {
//        if((self.presentingViewController) != nil) {
//            return true
//        }
//        
//        if(self.presentingViewController?.presentedViewController == self) {
//            return true
//        }
//        
//        if(self.navigationController?.presentingViewController?.presentedViewController == self.navigationController) {
//            return true
//        }
//        
//        if((self.tabBarController?.presentingViewController?.isKindOfClass(UITabBarController)) != nil) {
//            return true
//        }
//        
//        return false
//    }
}
