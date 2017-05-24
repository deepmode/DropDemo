//
//  HBDropItem.swift
//  DropDemo
//
//  Created by EricHo on 24/5/2017.
//  Copyright © 2017 EricHo. All rights reserved.
//


import Foundation
import UIKit

enum ImageSizeType  {
    
    case small, medium, large, xlarge
    
    func sizeType() -> ImageSizeType {
        
        let isPadPro =  max(UIScreen.main.bounds.width,UIScreen.main.bounds.height) >= 1024 ? true : false
        let deviceType =  UIDevice.current.userInterfaceIdiom
        let deviceScale = UIScreen.main.scale
        
        switch deviceType {
        case .pad:
            return isPadPro ? .xlarge : .large
        case .phone:
            return deviceScale <= 2.0 ? .medium : .medium
        default:
            return deviceScale <= 2.0 ? .medium : .large
        }
    }
}

struct HBPrice {
    var isEnable:Bool
    var price:String
    var currency:String
}

struct HBBrand {
    var name:String
    var href:String
}

struct HBReleaseDate {
    var dateString:String {
        didSet {
            //convert the dateString to Date
        }
    }
    var country:String
    var date:Date?
}

struct HBDropItem {
    var id:Int
    var slug:String
    var title:String
    var href:String
    var thunbnail:[ImageSizeType:String]
    var brand:[HBBrand]
    var price:HBPrice
    var date:HBReleaseDate
}
