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
    
    @IBOutlet weak var tableView:UITableView!
    let refreshControl = UIRefreshControl()
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
        
        self.dataFetcherManager.getFeedFromLink("https://hypebeast.com")
        
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
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        //self.dataFetcherManager.getNextFeed()
        self.dataFetcherManager.getFeedFromLink(self.requestLink)
        
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataFetcherManager.dataSrc.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell_list") //tableView.dequeueReusableCell(withIdentifier: "Cell_List", for: indexPath)
        if indexPath.row < self.dataFetcherManager.dataSrc.count {
            let d = self.dataFetcherManager.dataSrc[indexPath.row]
            switch d {
            case .PostDrop(let dropItem):
                cell.textLabel?.text = dropItem.title
                cell.detailTextLabel?.text = dropItem.date.dateString
            }
        }
        
        return cell
        
    }
}


extension ListViewController: UITableViewDelegate {
    
}



