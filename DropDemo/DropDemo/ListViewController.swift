//
//  ListViewController.swift
//  DropDemo
//
//  Created by Eric Ho on 27/5/2017.
//  Copyright © 2017 EricHo. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ListViewController: UIViewController, IndicatorInfoProvider {
    
    enum SectionType:Int {
        case List
        
        var count:Int {
            return 1
        }
    }
    
    
    @IBOutlet weak var tableView:UITableView!
    
    let refreshControl = UIRefreshControl()
    
    //-----
    let preFetchingThreshold:Float = 0.9
    static let footerLoadingViewHeight:CGFloat = 25.0
    
    fileprivate var isLoadingMoreNow = false {
        didSet  {
            //whenever the isLoadingMoreNow get set, update the footer loading spinner status
            if self.isLoadingMoreNow == true {
                
                DispatchQueue.main.async { [weak self] in
                    self?.footerView.isHidden = false
                    self?.footerView.loadingSpinner?.startAnimating()
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.footerView.isHidden = false
                    self?.footerView.loadingSpinner?.stopAnimating()
                }
            }
        }
    }
    //-----
    
    lazy var footerView:FooterLoadingView = {
        //let loadingFooterView = FooterLoadingView.loadFromXib() as! FooterLoadingView
        let loadingFooterView = FooterLoadingView()
        var frame = loadingFooterView.frame
        frame.size.height = ListViewController.footerLoadingViewHeight
        loadingFooterView.frame = frame
        //loadingFooterView.backgroundColor = UIColor.orange
        return loadingFooterView
    }()
    
    var requestLink:String {
        let links = ["https://hypebeast.com", "https://hypebeast.com/kr/"]
        let index = Int(arc4random() % 2)
        let returnLink = links[index]
        return returnLink
    }
    
    var itemInfo:IndicatorInfo
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: "ListViewController", bundle: nil)
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
    }
    
    override func loadView() {
        super.loadView()
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
        // Do any additional setup after loading the view.
        
        //self.tableView.register(UITableViewCell(), forCellReuseIdentifier: "Cell_list")
        
        self.setup()
        
        self.dataFetcherManager.getDropFeedFromLink("https://hypebeast.com")
        
        self.refreshControl.addTarget(self, action: #selector(ListViewController.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        if #available(iOS 10.0, *) {
            self.tableView?.refreshControl = self.refreshControl
        } else {
            self.tableView?.addSubview(refreshControl)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: 
    var dataFetcherManager:HBDataFetcherManager = {
        let manager = HBDataFetcherManager()
        return manager
    }()
    
    func setup() {
        
        //NotificationCenter.default.addObserver(self, selector: #selector(self.refreshHandler(_:)), name: NSNotification.Name(rawValue: HBDataFetcherManagerNotificaton.FetchStateDidUpdate), object: self.dataFetcherManager)
        
        self.dataFetcherManager.delegate = self
        
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        
        self.tableView?.tableFooterView = self.footerView
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        //self.dataFetcherManager.getNextFeed()
        self.dataFetcherManager.getDropFeedFromLink(self.requestLink)
        
        self.refreshControl.endRefreshing()
    }
    
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return self.itemInfo
    }
    
}

extension ListViewController: HBDataFetcherManagerDelegate {
    
    func hbDataFetcherManager(manager: HBDataFetcherManager, fetchStateDidUpdateToState: HBDataFetcherManager.FetchState) {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
        print("FetchState: \(fetchStateDidUpdateToState)")
    }
    
    func hbDataFetcherManagerDidUpdateTheDataSrc() {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
        self.tableView?.reloadData()
    }

}

extension ListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
        
        return SectionType(rawValue: 0)!.count
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if SectionType.List.rawValue == section {
//            return 0.0
//        }
//        
//        return 0.0
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
        
        return self.dataFetcherManager.dataSrc.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell_list") //tableView.dequeueReusableCell(withIdentifier: "Cell_List", for: indexPath)
        cell.textLabel?.text = ""
        cell.detailTextLabel?.text = ""
        
        if indexPath.row < self.dataFetcherManager.dataSrc.count {
            let d = self.dataFetcherManager.dataSrc[indexPath.row]
            switch d {
            case .PostDrop(let dropItem):
                cell.textLabel?.text = dropItem.title
                cell.detailTextLabel?.text = dropItem.date.dateString
            }
        }
        
        if self.isLoadingMoreNow == false {
            let totalNumberOfRows = self.tableView.numberOfRows(inSection: 0)
            if (Float(indexPath.row) / Float(totalNumberOfRows)) > self.preFetchingThreshold {
                
                if self.isLoadingMoreNow == false {
                    self.isLoadingMoreNow = true
                    print("\n\n--> Pre-Fetching if possibale")
                    self.dataFetcherManager.getNextDropFeed(completionHandler: { (request, response, error) in
                        self.isLoadingMoreNow  = false
                        DispatchQueue.main.async {

                        }
                    })
                }
            }
        }
        
        return cell
    }
}


extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(self.dataFetcherManager.dataSrc.count > 1 ){
            if(indexPath.row == self.dataFetcherManager.dataSrc.count - 1){

            }
        }
    }
}



