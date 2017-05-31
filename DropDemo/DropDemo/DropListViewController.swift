//
//  DropListViewController.swift
//  DropDemo
//
//  Created by EricHo on 29/5/2017.
//  Copyright © 2017 EricHo. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class DropListViewController: UIViewController {
    
    @IBOutlet weak var collectionView:UICollectionView!
    
//    enum SectionType:Int {
//        case List
//        
//        var count:Int {
//            return 1
//        }
//    }
    
    let refreshControl = UIRefreshControl()
    
    
    //-----
    let preFetchingThreshold:Float = 0.9
    static let footerLoadingViewHeight:CGFloat = 40.0
    
    fileprivate var isLoadingMoreNow = false {
        didSet  {
            //whenever the isLoadingMoreNow get set, update the footer loading spinner status
            if self.isLoadingMoreNow == true {
                print("\n--> startAnimating")
                DispatchQueue.main.async { [weak self] in
                    self?.footerView?.isHidden = false
                    self?.footerView?.loadingSpinner?.startAnimating()
                }
            } else {
                print("\n--> stopAnimating")
                DispatchQueue.main.async { [weak self] in
                    self?.footerView?.isHidden = false
                    self?.footerView?.loadingSpinner?.stopAnimating()
                }
            }
        }
    }
    //-----
    
    
    fileprivate var footerView:FooterLoadingReusableView? /*  = {
        let loadingFooterView = FooterLoadingReusableView()
        var frame = loadingFooterView.frame
        frame.size.height = DropListViewController.footerLoadingViewHeight
        loadingFooterView.frame = frame
        //loadingFooterView.backgroundColor = UIColor.orange
        return loadingFooterView
    }() */
    
    fileprivate var requestLink:String {
        let links = ["https://hypebeast.com/?limit=30","https://hypebeast.com/hk/?limit=30","https://hypebeast.com/jp/?limit=30"]
        let index = Int(arc4random() % UInt32(links.count))
        let returnLink = links[index]
        return returnLink
    }
    
    
    //-----
    var itemInfo:IndicatorInfo
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: "DropListViewController", bundle: nil)
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
    }
    //-----
    
    
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
        
        // Do any additional setup after loading the view.
        
        self.setup()
        
        self.dataFetcherManager.getDropFeedFromLink(self.requestLink)
        
        self.refreshControl.addTarget(self, action: #selector(ListViewController.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        if #available(iOS 10.0, *) {
            self.collectionView?.refreshControl = self.refreshControl
        } else {
            self.collectionView?.addSubview(refreshControl)
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
    
    private func setup() {
        
        self.dataFetcherManager.delegate = self
        
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        self.collectionView?.backgroundColor = UIColor.groupTableViewBackground
        
        self.collectionView.register(UINib(nibName: "HBDropProductCell", bundle: Bundle.main), forCellWithReuseIdentifier: "Cell_DropProduct")
        self.collectionView.register(UINib(nibName: "FooterLoadingReusableView", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Cell_Footer")
        
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        //self.dataFetcherManager.getNextFeed()
        self.dataFetcherManager.getDropFeedFromLink(self.requestLink)
        
        self.refreshControl.endRefreshing()
    }
    
    
    //MARK:
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
        
        if let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            print("--# invalidate layout and reload data")
            flowLayout.invalidateLayout()
            //note: if we are not reloading the data, the collection view might using the wrong cell (e.g. in search mode, leftright cell -> vertical cell)
            self.collectionView.reloadData()
        }
    }


}

// MARK: - IndicatorInfoProvider
extension DropListViewController: IndicatorInfoProvider {
    
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

// MARK: - UICollectionViewDelegateFlowLayout
extension DropListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
        
        let sectionType = SectionType.getSectionTypeWithRawValue(indexPath.section)
        
        switch sectionType {
        case .feature:
            let s = Layout.sectionCellSize(containerWidth: self.view.bounds.width, sectionType: sectionType, numberOfColumn: 1)
            return s
            
        case .channel:
            let s = Layout.sectionCellSize(containerWidth: self.view.bounds.width, sectionType: sectionType, numberOfColumn: 1)
            return s
            
        case .newsfeed:
            var cols = 1
            
            switch self.traitCollection.horizontalSizeClass {
            case .compact:
                cols = 1
            case .regular:
                cols = 3
            case .unspecified:
                cols = 1
            }
            let s = Layout.sectionCellSize(containerWidth: self.view.bounds.width, sectionType: sectionType, numberOfColumn: cols)
            return s
            
        case .unknown:
            
            let s = Layout.sectionCellSize(containerWidth: self.view.bounds.width, sectionType: sectionType, numberOfColumn: 1)
            return s
        }
        
//
//        let w = self.view.bounds.width * 0.95 / CGFloat(cols)
//        let imageRatio:CGFloat = 3/2
//        let contentToImageHeightRatio:CGFloat = 0.5
//        let imageHeight = w * 1 / imageRatio
//        let cellHeight = imageHeight + imageHeight * contentToImageHeightRatio
//        return CGSize(width: w, height:cellHeight )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let sectionType = SectionType.getSectionTypeWithRawValue(section)
        return Layout.insetForSectionType(sectionType)
        
        //return UIEdgeInsetsMake(Layout.cellTopPadding, Layout.cellLeftPadding, Layout.cellBottomPadding, Layout.cellRightPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //return self.collectionViewCellVerticalSeparatorSpacing //provide spacing between vertial cell
        
        let sectionType = SectionType.getSectionTypeWithRawValue(section)
        return Layout.minimumLineSpacingForSection(sectionType)
    }
    
}

// MARK: - UICollectionViewDelegate
extension DropListViewController: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDataSource
extension DropListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
        
        let sectionType = SectionType.getSectionTypeWithRawValue(section)
        switch sectionType {
        case .feature:
            return CGSize(width: self.view.bounds.size.width, height: 0.0)
        case .channel:
            return CGSize(width: self.view.bounds.size.width, height: 0.0)
        case .newsfeed:
            return CGSize(width: self.view.bounds.size.width, height: DropListViewController.footerLoadingViewHeight);
        case .unknown:
            return CGSize(width: self.view.bounds.size.width, height: 0.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
        
        if kind == UICollectionElementKindSectionFooter {
            self.footerView = self.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Cell_Footer", for: indexPath) as? FooterLoadingReusableView
            return self.footerView!
        }
        
        //if anything else, return a default footer view with nothing inside
        let defaultView = self.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Cell_Footer", for: indexPath) as! FooterLoadingReusableView
        defaultView.loadingSpinner?.stopAnimating()
        return defaultView
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
//        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
//    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
        return SectionType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
        
        let sectionType = SectionType.getSectionTypeWithRawValue(section)
        switch sectionType {
        case .feature:
            return 0
        case .channel:
            return 0
        case .newsfeed:
            return self.dataFetcherManager.dataSrc.count
        case .unknown:
            return 0
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_DropProduct", for: indexPath) as! HBDropProductCell
        
        let sectionType = SectionType.getSectionTypeWithRawValue(indexPath.section)
        
        switch sectionType {
        case .feature:
            //return feature cell
            break
        case .channel:
            //return channel cell
            break
        case .newsfeed:
            
            if indexPath.row < self.dataFetcherManager.dataSrc.count {
                
                let d = self.dataFetcherManager.dataSrc[indexPath.row]
                switch d {
                case .PostDrop(let dropItem):
                    cell.setupCell(post: dropItem)
                }
            }
            
            if self.isLoadingMoreNow == false {
                
                let totalNumberOfRows = self.collectionView.numberOfItems(inSection: indexPath.section)
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

        case .unknown:
            break
        }
        
        return cell
        
    }
}
