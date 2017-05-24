//
//  PageAViewController.swift
//  DropDemo
//
//  Created by EricHo on 22/5/2017.
//  Copyright © 2017 EricHo. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PageAViewController: UIViewController, IndicatorInfoProvider {
    
    var itemInfo:IndicatorInfo
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: "PageAViewController", bundle: nil)
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
        
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: 
    
    func setup() {
        HBDropManager.shareInstance.getNewsFeed("https://hypebeast.com/") { (request, response, dropItems, nextURLString, error) in
            
        }
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return self.itemInfo
    }
    
    
    
}

