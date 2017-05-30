//
//  UICollectionViewCell+Extension.swift
//  Hypebeast
//
//  Created by Eric Ho on 19/2/2017.
//  Copyright © 2017 EricHo. All rights reserved.
//

import UIKit
import FLAnimatedImage
import SDWebImage


extension UICollectionViewCell {
    
    //note: targetImageView and activityView need to be an optional - since they might come from IBOutlet
    internal func displayImage(url:URL, targetAnimatedImageView:FLAnimatedImageView?, activityView:UIActivityIndicatorView? = nil, enablePlaceHolderImage:Bool = true, motionEffectGroup: UIMotionEffectGroup? = nil) {
        
        let animationTime = 0.6
        let animationEffect = false
        
        DispatchQueue.main.async(execute: { () -> Void in
            activityView?.startAnimating()
        })
        
        var sdOptions:SDWebImageOptions = SDWebImageOptions.retryFailed
        if url.path.hasSuffix(".gif") {
            sdOptions = [SDWebImageOptions.retryFailed, SDWebImageOptions.lowPriority]
        }
        
        let placeHolderImage:UIImage? = enablePlaceHolderImage ? UIImage(named: "teaser-placeholder") : nil
        
        
        targetAnimatedImageView?.sd_setImage(with: url, placeholderImage: placeHolderImage, options: sdOptions, completed: { (image, error, cacheType, url) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                activityView?.stopAnimating()
                
                //----- apply motion effect to imageview -----
                if let effectGroup = motionEffectGroup {
                    targetAnimatedImageView?.removeMotionEffect(effectGroup)
                    targetAnimatedImageView?.addMotionEffect(effectGroup)
                }
                //--------------------------------------------
                
                if (cacheType == SDImageCacheType.memory) {
                    targetAnimatedImageView?.alpha = 1
                } else {
                    
                    // If the cache is none or disk, it's just been loaded
                    targetAnimatedImageView?.alpha = 0.3
                    
                    if animationEffect == true {
                        //animated in 
                        targetAnimatedImageView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                            targetAnimatedImageView?.alpha = 1
                            targetAnimatedImageView?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                            
                        }, completion: { (finished) in
                                if finished == true {
                                    UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                                        targetAnimatedImageView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                                    }, completion: { (finished) in
                                        
                                    })
                                }
                            }
                        )
                    } else {
                        //just fade in
//                        UIView.animate(withDuration: Constants.Animation.collectionViewCellImageAnimateTime, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: { 
//                            targetAnimatedImageView?.alpha = 1
//                        }, completion: { (finished) in
//                            
//                        })

                        UIView.animate(withDuration: animationTime, animations: { () -> Void in
                            targetAnimatedImageView?.alpha = 1
                        })
                    }
                    
                }
            })
        })
    }
}



