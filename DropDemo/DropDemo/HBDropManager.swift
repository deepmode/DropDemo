//
//  HBDropManager.swift
//  DropDemo
//
//  Created by EricHo on 24/5/2017.
//  Copyright © 2017 EricHo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class HBDropManager {
    
    fileprivate let alamofireSessionManager:SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 15 // seconds
        //configuration.timeoutIntervalForRequest = HBCommon.timeoutIntervalForRequestShort // seconds
        let alamofireManager = Alamofire.SessionManager(configuration: configuration)
        return alamofireManager
    }()
    
    static let shareInstance:HBDropManager = {
        let manager = HBDropManager()
        
        return manager
    }()
    
    typealias JwtToken = String
    
    fileprivate var jwtToken:JwtToken?  {
        return nil
        //return HBDataManager.shareInstance.jwtToken()
    }
    
    fileprivate var deviceToken:String? {
        return nil
        //return HBDataManager.shareInstance.fcmToken
    }
    
    fileprivate var deviceType:String?  {
        return nil
    }
    
    fileprivate var osType:String? {
        return nil
    }
    
    fileprivate var apiVersionQueryString:String {
        return "version=2.5"
    }
    
    var requestHeaders: [String : String] {
        
        var requestHeader:[String:String] = [:]

        requestHeader["Authorization"] = self.jwtToken ?? ""
        requestHeader["DeviceToken"] = self.deviceToken ?? ""
        requestHeader["Accept"] = "application/json"
        requestHeader["Content-Type"] = "application/json"
        requestHeader["Device-Type"] = self.deviceType ?? ""
        requestHeader["Os-Type"] = self.osType ?? ""
        
        return requestHeader
    }
    
    func testJSONData() -> NSData? {
        if let path = Bundle.main.path(forResource: "testdata", ofType: "json") {
            let url = URL(fileURLWithPath: path)
            let jsonData = NSData(contentsOf: url)
            return jsonData
        }
        return nil
        
//        let masterDataUrl: URL = Bundle.main.url(forResource: "testdata", withExtension: "json")
//        let jsonData: NSData = NSData(contentsOfURL: masterDataUrl as URL)!
//        let jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: nil) as! NSDictionary
//        var persons : NSArray = jsonResult["person"] as! NSArray
        
    }
    
    
    func getNewsFeed(_ urlString: String, completionHandler: @escaping (_ request: URLRequest?, _ response: HTTPURLResponse?, _ dropItems:[HBDropItem]?, _ nextPageUrlString:String?, _ error: NSError?) -> ())  {
        
        alamofireSessionManager.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default, headers: self.requestHeaders).responseJSON { [weak self] (dataResponse) in
            switch dataResponse.result {
            case .success(let returnJson):
                if let jsonData = self?.testJSONData() {
                    
                    let jsonObj = JSON(jsonData)
                    
                    var dropItems:[HBDropItem] = []
                    let nextPageHref = jsonObj["drops"]["_links"]["next"]["href"].string
                    
                    let itemArray = jsonObj["drops"]["_embedded"]["items"].arrayValue
                    for eachItem in itemArray {
                        if let dropItem = self?.convertToDropItemFrom(dropJson: eachItem) {
                            dropItems.append(dropItem)
                        }
                    } //end forloop
                    
                    print("dropItems: \(dropItems)")
                    return completionHandler(dataResponse.request, dataResponse.response, dropItems, nextPageHref, dataResponse.result.error as NSError?)
                } else {
                    return completionHandler(dataResponse.request, dataResponse.response, nil, nil,  dataResponse.result.error as NSError?)
                }
            case .failure( _):
                return completionHandler(dataResponse.request, dataResponse.response, nil, nil,  dataResponse.result.error as NSError?)
            }
        }
    }
    
    fileprivate func convertToDropItemFrom(dropJson:JSON) -> HBDropItem? {
        
        let id = dropJson["id"].int
        
        let slug = dropJson["slug"].string ?? ""
        let title = dropJson["title"].string ?? ""
        let herf = dropJson["_links"]["self"]["href"].string ?? ""
        
        var thumbnails:[ImageSizeType:String] = [:]
        thumbnails[ImageSizeType.small] = dropJson["_links"]["thumbnail"]["small"]["href"].stringValue
        thumbnails[ImageSizeType.large] = dropJson["_links"]["thumbnail"]["large"]["href"].stringValue
        
        let brandArray = dropJson["_links"]["brand"].arrayValue
        
        var brands = [HBBrand]()
        for eachBrand in brandArray {
            if let name = eachBrand["name"].string {
                brands.append(HBBrand(name: name, href: eachBrand["href"].stringValue))
            }
        }
        
        let dropPriceEnable = dropJson["drop_price"]["enable"].bool ?? false
        let dropPricePrice = dropJson["drop_price"]["price"].stringValue
        let dropPriceCurrency = dropJson["drop_price"]["currency"].stringValue
        let price = HBPrice(isEnable: dropPriceEnable, price: dropPricePrice, currency: dropPriceCurrency)
        
        
        let releaseDate = dropJson["release_date"]["date"].stringValue
        let releaseCountry = dropJson["release_date"]["country"].stringValue
        let release = HBReleaseDate(dateString: releaseDate, country: releaseCountry)
        
        if let _ = id {
            return HBDropItem(id: id!, slug: slug, title: title, href: herf, thunbnail: thumbnails, brand: brands, price: price, date: release)
        }
        
        return nil
    }
}


