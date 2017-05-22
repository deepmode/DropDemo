//
//  PageBViewController.swift
//  DropDemo
//
//  Created by EricHo on 22/5/2017.
//  Copyright © 2017 EricHo. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PageBViewController: UIViewController, IndicatorInfoProvider {
    
    var itemInfo:IndicatorInfo = IndicatorInfo(title: "BB")
    
    override func awakeFromNib() {
         super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return self.itemInfo
    }
    
}

