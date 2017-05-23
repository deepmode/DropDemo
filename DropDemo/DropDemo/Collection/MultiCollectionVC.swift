//
//  MultiCollectionVC.swift
//  MultiCollection
//
//  Created by EricHo on 11/8/2016.
//  Copyright © 2016 E H. All rights reserved.
//

import UIKit
import XLPagerTabStrip

enum SectionType:Int {
    
    case feature = 0
    case channel
    case newsfeed
    case unknown
    
    
    static func getSectionTypeWithRawValue(_ rawValue:Int) -> SectionType {
        switch rawValue {
        case 0:
            return SectionType.feature
        case 1:
            return SectionType.channel
        case 2:
            return SectionType.newsfeed
        default:
            return SectionType.unknown
        }
    }
}


struct Layout {
    
    static let interCellSpacingForCollectionView:CGFloat = 20.0
    
    static let cellTopPadding:CGFloat = interCellSpacingForCollectionView
    static let cellBottomPadding:CGFloat = interCellSpacingForCollectionView
    static let cellLeftPadding:CGFloat = interCellSpacingForCollectionView
    static let cellRightPadding:CGFloat = interCellSpacingForCollectionView
    
    static func numberOfColumn(_ sizeClass:UIUserInterfaceSizeClass) -> Int {
        switch sizeClass {
        case .compact:
            return 2
        case .regular:
            return 4
        default:
            return 1
        }
    }
    
    static func minimumLineSpacingForSection(_ sectionType:SectionType) -> CGFloat {
        switch sectionType {
        case .feature:
            return 0.0
        case .channel:
            return 0.0
        case .newsfeed:
            return Layout.interCellSpacingForCollectionView
        case .unknown:
            return 0.0
        }
    }
    
    static func sectionCellSize(containerWidth:CGFloat, sectionType:SectionType, numberOfColumn:Int? = nil) -> CGSize {
        
        let interCellSpacing:CGFloat = Layout.interCellSpacingForCollectionView
        
        switch sectionType {
        case .feature:
            return CGSize(width: containerWidth, height: 250)
        case .channel:
            return CGSize(width: containerWidth, height: 100)
        case .newsfeed:
            
            //default to single column
            var cols:CGFloat = 1.0
            
            if let numberOfColumn = numberOfColumn {
                cols = CGFloat(numberOfColumn)
            }
            
            let cellWidth = (containerWidth - ((cols + 1) * interCellSpacing)) / cols
            
            if cols > 1 {
                //fixed height
                return CGSize(width: cellWidth, height: cellWidth)
            } else {
                let cellHeight = CGFloat(arc4random() % 150) + 100
                return CGSize(width: cellWidth,height: cellHeight)
            }
        case .unknown:
            return CGSize(width: 0,height: 0)
        }
    }
    
    static func insetForSectionType(_ sectionType:SectionType) -> UIEdgeInsets {
        let leftPadding:CGFloat = Layout.cellLeftPadding
        let rightPadding:CGFloat = Layout.cellRightPadding
        let topPadding:CGFloat = Layout.cellTopPadding
        let bottomPadding:CGFloat = Layout.cellBottomPadding
        
        switch sectionType {
        case .feature:
            return UIEdgeInsetsMake(0, 0, 0, 0)
        case .channel:
            return UIEdgeInsetsMake(0, 0, 0, 0)
        case .newsfeed:
            return UIEdgeInsetsMake(topPadding, leftPadding, bottomPadding, rightPadding)
        case .unknown:
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
}


struct Constants {
    static let BackgroundColor = UIColor.lightGray
    static let cellIdentifier = "CollectionViewCell"
    static let cellIdentifierFeature = "FeatureCell"
    static let numberOfSection = 3
    
}


func generateRandomData() -> [[UIColor]] {
    let numberOfRows = Constants.numberOfSection
    let numberOfItemsPerRow = 100
    
    return (0..<numberOfRows).map { _ in
        return (0..<numberOfItemsPerRow).map { _ in UIColor.randomColor() }
    }
}



class MultiCollectionVC: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    //hold the latest size of VC's view bound
    fileprivate var currentSize:CGSize?
    
    fileprivate var featureSectionCell:FeatureCell?
    fileprivate var featureVC:FeatureVC?
    
    var dataSrc:[[UIColor]] = {
        
        var colors = [[UIColor]]()
        
        colors.append([UIColor.red])
        
        colors.append([UIColor.orange])
        
        var temp = [UIColor]()
        for each in 0..<100 {
            temp.append(UIColor.randomColor())
        }
        colors.append(temp)
        return colors
    }()
    
    var itemInfo:IndicatorInfo
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: "MultiCollectionVC", bundle: nil)
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
        self.collectionView?.backgroundColor = Constants.BackgroundColor
        
        self.collectionView.register(FeatureCell.classForCoder(), forCellWithReuseIdentifier: Constants.cellIdentifierFeature)
        self.collectionView.register(UINib(nibName: "FeatureCell", bundle: Bundle.main), forCellWithReuseIdentifier:Constants.cellIdentifierFeature)
        
        self.collectionView.register(UINib(nibName: "CollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier:Constants.cellIdentifier)
        
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        if let layout  = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
        print("toSize: \(size)")
        //######################
        //self.currentSize (hold the latest size of VC's view bound)
        self.currentSize = size
        //######################
        
        
        var updateFrame = self.featureSectionCell?.frame
        updateFrame!.size.width = size.width
        self.featureSectionCell?.frame = updateFrame!
        
        if let flowlayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowlayout.invalidateLayout()
        }
        self.collectionView.reloadData()
    }
}

extension MultiCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        let sectionType = SectionType.getSectionTypeWithRawValue(section)
        return Layout.insetForSectionType(sectionType)
        
        //return UIEdgeInsetsMake(Layout.cellTopPadding, Layout.cellLeftPadding, Layout.cellBottomPadding, Layout.cellRightPadding)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        //return self.collectionViewCellVerticalSeparatorSpacing //provide spacing between vertial cell
        
        let sectionType = SectionType.getSectionTypeWithRawValue(section)
        return Layout.minimumLineSpacingForSection(sectionType)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSrc.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSrc[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let section = indexPath.section
        let sectionType = SectionType.getSectionTypeWithRawValue(section)
        
        let column =  Layout.numberOfColumn(self.traitCollection.horizontalSizeClass)
        
        var size = Layout.sectionCellSize(containerWidth: width, sectionType: sectionType, numberOfColumn: column)
        if let newWidth  = self.currentSize?.width {
            size = Layout.sectionCellSize(containerWidth: newWidth, sectionType: sectionType, numberOfColumn: column)
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let sectionType = SectionType.getSectionTypeWithRawValue(indexPath.section)
        switch sectionType {
        case .feature:
            if self.featureSectionCell == nil {
                self.featureSectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifierFeature, for: indexPath) as? FeatureCell
            }
            return self.featureSectionCell!
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as! CollectionViewCell
            cell.backgroundColor = self.dataSrc[indexPath.section][indexPath.row]
            cell.setupCell("\(indexPath.row)")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let sectionType = SectionType.getSectionTypeWithRawValue(indexPath.section)
        switch sectionType {
        case .feature:
            if let featureCell = cell as? FeatureCell, self.featureVC == nil  {
                print("SectionType.FeatureBanner")
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SBID_FeatureVC") as? FeatureVC {
                    self.featureVC = vc
                    
                    //#######################
                    //controller containment
                    self.addChildViewController(vc)
                    self.featureVC?.didMove(toParentViewController: self)
                    
                    //must set to 0 in order to scroll the page properly
                    let topPadding:CGFloat = 0.0
                    let bottomPadding:CGFloat = 0.0
                    let leadingPadding:CGFloat = 0.0
                    let trailingPadding:CGFloat = 0.0
                    
                    let hostedView = vc.view
                    hostedView?.frame = cell.frame
                    featureCell.contentView.addSubview(hostedView!)
                    hostedView?.translatesAutoresizingMaskIntoConstraints = false
                    
                    let topPaddingConstraint = NSLayoutConstraint(item: hostedView, attribute: .top, relatedBy: .equal, toItem: featureCell.contentView, attribute: .top, multiplier: 1.0, constant: topPadding)
                    let bottomPaddingConstraint = NSLayoutConstraint(item: hostedView, attribute: .bottom, relatedBy: .equal, toItem: featureCell.contentView, attribute: .bottom, multiplier: 1.0, constant: -bottomPadding)
                    let leadingPaddingConstraint = NSLayoutConstraint(item: hostedView, attribute: .leading, relatedBy: .equal, toItem: featureCell.contentView, attribute: .leading, multiplier: 1.0, constant: leadingPadding)
                    let trailingPaddingConstraint = NSLayoutConstraint(item: hostedView, attribute: .trailing, relatedBy: .equal, toItem: featureCell.contentView, attribute: .trailing, multiplier: 1.0, constant: -trailingPadding)
                    
                    bottomPaddingConstraint.priority = 999
                    
                    NSLayoutConstraint.activate([topPaddingConstraint, bottomPaddingConstraint, leadingPaddingConstraint,trailingPaddingConstraint])
                    
                    //#######################
                    
                }
            }
        default:
            break
        }
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return self.itemInfo
    }
    
}
