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

protocol HBDataFetcherManagerDelegate:class {
    func hbDataFetcherManager(manager:HBDataFetcherManager, fetchStateDidUpdateToState: HBDataFetcherManager.FetchState)
    func hbDataFetcherManagerDidUpdateTheDataSrc()
}

//Define PostItemType
enum HBPostItemType{
    //case Post(Post)
    case PostDrop(HBDropItem)
    //case Ad(HBAd)
}

struct HBDataFetcherManagerNotificaton {
    static let FetchStateDidUpdate = "FetchStateDidUpdate"
}

class HBDataFetcherManager {
    
    //Internal use only.
    enum FetchState {
        case Fetching
        case Idle
    }
    
//    static let shareInstance:HBDataFetcherManager = {
//        let manager = HBDataFetcherManager()
//        return manager
//    }()
    
    weak var delegate: HBDataFetcherManagerDelegate?
    
    var dataSrc:[HBPostItemType] = []
    
    static let serialQueue = DispatchQueue(label: "SerialQueue")
    
    static let backgroundQueue = DispatchQueue.global(qos: .userInitiated)
    
    //internal use only. Set this via fetchingState property
    fileprivate var _fetchingState:FetchState = .Idle
    
    var fetchingState: FetchState {
        
        set(newFetchingState) {
            
            //atomic locking for accessing the privateFetchingState
            HBDataFetcherManager.serialQueue.sync { [weak self] in
                self?._fetchingState = newFetchingState
            }
            
            switch newFetchingState {
            case .Idle:
                break
            case .Fetching:
                break
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: HBDataFetcherManagerNotificaton.FetchStateDidUpdate), object: self, userInfo: nil)
            self.delegate?.hbDataFetcherManager(manager: self, fetchStateDidUpdateToState: _fetchingState)
        }
        
        get {
            return self._fetchingState
        }
        
        
    }
    
    fileprivate let alamofireSessionManager:SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 15 // seconds
        //configuration.timeoutIntervalForRequest = HBCommon.timeoutIntervalForRequestShort // seconds
        let alamofireManager = Alamofire.SessionManager(configuration: configuration)
        return alamofireManager
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
    
    fileprivate func testJSONData() -> NSData? {
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
    
    func resetDataSrc() {
        self.dataSrc = []
    }
    
    fileprivate var privateUrlLink:String?
    
    func getDropFeedFromLink(_ urlString:String,  completionHandler: ((_ request: URLRequest?, _ response: HTTPURLResponse?, _ error: NSError?) -> ())? = nil) {

        self.privateUrlLink = urlString
        
        let link = self.privateUrlLink!
        
        self.getDropFeed(link) { [weak self] (request, response, dropItems, nextUrlIink, error) in
            
            if let requestLink = request?.url?.absoluteString, requestLink != self?.privateUrlLink  {
                //origin request link has changed and no appending of data is needed
                
                if let _ = completionHandler {
                    completionHandler!(request,response, error)
                }
            }
            
            HBDataFetcherManager.backgroundQueue.async{
            
                if error == nil {
                    self?.privateUrlLink = nextUrlIink
                    
                    //process the dropItems and append items to the data src
                    var temp = [HBPostItemType]()
                    
                    if let _ = dropItems {
                        
                        for eachDropItem in dropItems! {
                            //append item
                            temp.append(HBPostItemType.PostDrop(eachDropItem))
                        }
                        
                        //----------
                        self?.dataSrc = []
                        //----------
                        
                        //self?.dataSrc.insert(contentsOf: temp, at: 0)
                        self?.dataSrc.append(contentsOf: temp)
                        DispatchQueue.main.async {
                            self?.delegate?.hbDataFetcherManagerDidUpdateTheDataSrc()
                        }
                        
                        
                        let totalData = self?.dataSrc
                        print("dataSrc: \(String(describing: totalData?.count))")
                    }
                }
                
                if let _ = completionHandler {
                    DispatchQueue.main.async {
                        completionHandler!(request,response,error)
                    }
                }
            }
        }
    }
    
    func getNextDropFeed(completionHandler: ((_ request: URLRequest?, _ response: HTTPURLResponse?, _ error: NSError?) -> ())? = nil) {
        
        guard self.privateUrlLink != nil else {
            print("self.privateUrlLink = \(String(describing: self.privateUrlLink))")
            let error = NSError(domain: "hypebeast.com", code: 999, userInfo: nil)
            if let _ = completionHandler {
                completionHandler!(nil, nil, error)
            }
            return
        }
        
        let link = self.privateUrlLink!
        
        self.getDropFeed(link) { [weak self] (request, response, dropItems, nextUrlIink, error) in
            
            if let requestLink = request?.url?.absoluteString, requestLink != self?.privateUrlLink  {
                //origin request link has changed and no appending of data is needed

                if let _ = completionHandler {
                    completionHandler!(request,response, error)
                }
            }
            
            HBDataFetcherManager.backgroundQueue.async{
                if error == nil {
                    self?.privateUrlLink = nextUrlIink
                    
                    //process the dropItems and append items to the data src
                    var temp = [HBPostItemType]()
                    
                    if let _ = dropItems {
                        
                        for eachDropItem in dropItems! {
                            //append item
                            temp.append(HBPostItemType.PostDrop(eachDropItem))
                        }
                        
                        //self?.dataSrc.insert(contentsOf: temp, at: 0)
                        self?.dataSrc.append(contentsOf: temp)
                        DispatchQueue.main.async {
                            self?.delegate?.hbDataFetcherManagerDidUpdateTheDataSrc()
                        }
                        
                        let totalData = self?.dataSrc
                        print("dataSrc: \(String(describing: totalData?.count))")
                    }
                }
                
                if let _ = completionHandler {
                    DispatchQueue.main.async {
                        completionHandler!(request,response,error)
                    }
                }
            }
            
            
        }
    }
    
    fileprivate func getDropFeed(_ urlString: String, completionHandler: ((_ request: URLRequest?, _ response: HTTPURLResponse?, _ dropItems:[HBDropItem]?, _ nextPageUrlString:String?, _ error: NSError?) -> ())? = nil)  {
        
        guard self.fetchingState == .Idle else {
            print("\n-------------")
            print("In the middle of fetching already!: \(Date())")
            print("-------------\n")
            return
        }
        
        print("\n------------------------------ ")
        print("fetching start: \(Date())")
        print("------------------------------\n")
        
        self.fetchingState = .Fetching
       
        alamofireSessionManager.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default, headers: self.requestHeaders).responseJSON { [weak self] (dataResponse) in
            
            switch dataResponse.result {
            
            case .success(let returnJson):

                    
                //move the expnesive task into background queue
                HBDataFetcherManager.backgroundQueue.async { [weak self] in
                    
                    let jsonObj = JSON(returnJson)
        
                    
                    var dropItems:[HBDropItem] = []
                    let nextPageHref = jsonObj["posts"]["_links"]["next"]["href"].string
                    
                    let itemArray = jsonObj["posts"]["_embedded"]["items"].arrayValue
                    for eachItem in itemArray {
                        if let dropItem = self?.convertToDropItemFrom(dropJson: eachItem) {
                            dropItems.append(dropItem)
                        }
                    } //end forloop
                    
                    print("\n------------------------------ ")
                    print("fetching end: \(Date())")
                    //print("dropItems: \(dropItems)")
                    print("------------------------------\n")
                    
                    //when complete, update the state back to .Idle
                    self?.fetchingState = .Idle
                    
                    DispatchQueue.main.async {
                        if let _ = completionHandler {
                            return completionHandler!(dataResponse.request, dataResponse.response, dropItems, nextPageHref, dataResponse.result.error as NSError?)
                        }
                    }
                }
                
            case .failure( _):
                self?.fetchingState = .Idle
                if let _ = completionHandler {
                    return completionHandler!(dataResponse.request, dataResponse.response, nil, nil,  dataResponse.result.error as NSError?)
                }
                
            } // end switch
        }
    }
    
    fileprivate func ok_getDropFeed(_ urlString: String, completionHandler: ((_ request: URLRequest?, _ response: HTTPURLResponse?, _ dropItems:[HBDropItem]?, _ nextPageUrlString:String?, _ error: NSError?) -> ())? = nil)  {
        
        guard self.fetchingState == .Idle else {
            print("\n-------------")
            print("In the middle of fetching already!: \(Date())")
            print("-------------\n")
            return
        }
        
        print("\n------------------------------ ")
        print("fetching start: \(Date())")
        print("------------------------------\n")
        
        self.fetchingState = .Fetching
        
        alamofireSessionManager.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default, headers: self.requestHeaders).responseJSON { [weak self] (dataResponse) in
            
            switch dataResponse.result {
                
            case .success(let returnJson):
                if let jsonData = self?.testJSONData() {
                    
                    //move the expnesive task into background queue
                    HBDataFetcherManager.backgroundQueue.async { [weak self] in
                        
                        let jsonObj = JSON(jsonData)
                        
                        //trigger a network loading of resources
                        //let _ = try? Data(contentsOf: URL(string: "https://lorempixel.com/1000/1000/sports/")!)
                        
                        /*
                        do {
                            let _ = try Data(contentsOf: URL(string: "https://lorempixel.com/500/500/sports/")!)
                        } catch { }
                        */
                        
                        var dropItems:[HBDropItem] = []
                        let nextPageHref = jsonObj["drops"]["_links"]["next"]["href"].string
                        
                        let itemArray = jsonObj["drops"]["_embedded"]["items"].arrayValue
                        for eachItem in itemArray {
                            if let dropItem = self?.convertToDropItemFrom(dropJson: eachItem) {
                                dropItems.append(dropItem)
                            }
                        } //end forloop
                        
                        print("\n------------------------------ ")
                        print("fetching end: \(Date())")
                        //print("dropItems: \(dropItems)")
                        print("------------------------------\n")
                        
                        //when complete, update the state back to .Idle
                        self?.fetchingState = .Idle
                        
                        DispatchQueue.main.async {
                            if let _ = completionHandler {
                                return completionHandler!(dataResponse.request, dataResponse.response, dropItems, nextPageHref, dataResponse.result.error as NSError?)
                            }
                        }
                    }
                    
                } else {
                    self?.fetchingState = .Idle
                    if let _ = completionHandler {
                        return completionHandler!(dataResponse.request, dataResponse.response, nil, nil,  dataResponse.result.error as NSError?)
                    }
                    
                    
                }
                
            case .failure( _):
                self?.fetchingState = .Idle
                if let _ = completionHandler {
                    return completionHandler!(dataResponse.request, dataResponse.response, nil, nil,  dataResponse.result.error as NSError?)
                }
                
            } // end switch
        }
    }
    
    
    fileprivate func convertToDropItemFrom(dropJson:JSON) -> HBDropItem? {
        
        let id = dropJson["id"].int
        
        let slug = dropJson["slug"].string ?? ""
        let title = dropJson["title"].string ?? ""
        let herf = dropJson["_links"]["self"]["href"].string ?? ""
        
        var thumbnails:[ImageSizeType:String] = [:]
        thumbnails[ImageSizeType.small] = dropJson["_links"]["thumbnail"]["href"].stringValue
        thumbnails[ImageSizeType.large] = dropJson["_links"]["large_thumbnail"]["href"].stringValue
        
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
        
        let releaseDate = dropJson["date"].stringValue //dropJson["release_date"]["date"].stringValue //Date().description
        let releaseCountry = dropJson["release_date"]["country"].stringValue
        let release = HBReleaseDate(dateString: releaseDate, country: releaseCountry)
        
        if let _ = id {
            return HBDropItem(id: id!, slug: slug, title: title, href: herf, thumbnail: thumbnails, brand: brands, price: price, date: release)
        }
        
        return nil
    }
    
    fileprivate func ok_convertToDropItemFrom(dropJson:JSON) -> HBDropItem? {
        
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
        
        
        let releaseDate = Date().description //dropJson["release_date"]["date"].stringValue
        let releaseCountry = dropJson["release_date"]["country"].stringValue
        let release = HBReleaseDate(dateString: releaseDate, country: releaseCountry)
        
        if let _ = id {
            return HBDropItem(id: id!, slug: slug, title: title, href: herf, thumbnail: thumbnails, brand: brands, price: price, date: release)
        }
        
        return nil
    }
}


