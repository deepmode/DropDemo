//
//  DropListViewController.swift
//  DropDemo
//
//  Created by EricHo on 29/5/2017.
//  Copyright © 2017 EricHo. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class DropListViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    enum SectionType:Int {
        case List
        
        var count:Int {
            return 1
        }
    }
    
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

    
    //MARK:  VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        
        self.dataFetcherManager.getFeedFromLink("https://hypebeast.com")
        
        self.refreshControl.addTarget(self, action: #selector(ListViewController.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        if #available(iOS 10.0, *) {
            self.collectionView?.refreshControl = self.refreshControl
        } else {
            self.collectionView?.addSubview(refreshControl)
        }

        // Do any additional setup after loading the view.
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
    
    private func setup() {
        
        self.dataFetcherManager.delegate = self
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        self.collectionView.register(UINib(nibName: "HBDropProductCell", bundle: Bundle.main), forCellWithReuseIdentifier: "Cell_DropProduct")
        
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

// MARK: - HBDataFetcherManagerDelegate
extension DropListViewController: HBDataFetcherManagerDelegate {
    
    func hbDataFetcherManager(manager: HBDataFetcherManager, fetchStateDidUpdateToState: HBDataFetcherManager.FetchState) {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
        print("FetchState: \(fetchStateDidUpdateToState)")
    }
    
    func hbDataFetcherManagerDidUpdateTheDataSrc() {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
        self.collectionView?.reloadData()
    }
    
}

// MARK: - UICollectionViewDelegate
extension DropListViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension DropListViewController: UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionType.init(rawValue: 0)!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if SectionType.List.rawValue == section {
            return self.dataFetcherManager.dataSrc.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_DropProduct", for: indexPath) as! HBDropProductCell
        if indexPath.row < self.dataFetcherManager.dataSrc.count {
            
            let d = self.dataFetcherManager.dataSrc[indexPath.row]
            switch d {
            case .PostDrop(let dropItem):
                cell.titleLabel?.text = dropItem.title
                //cell.detailTextLabel?.text = dropItem.date.dateString
            }
        }
        
        return cell
        
    }
}
