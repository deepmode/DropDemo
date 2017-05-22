//
//  ViewController.swift
//  DropDemo
//
//  Created by EricHo on 22/5/2017.
//  Copyright © 2017 EricHo. All rights reserved.
//

import UIKit
import XLPagerTabStrip




class ViewController: ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var shadowView: UIView!
    //let blueInstagramColor = UIColor(red: 37/255.0, green: 111/255.0, blue: 206/255.0, alpha: 1.0)
    let themeColor = UIColor.black
    
    override func viewDidLoad() {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = self.themeColor
        settings.style.buttonBarItemFont = .systemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.lightGray
            newCell?.label.textColor = self?.themeColor
        }
        super.viewDidLoad()
    }
    
    // MARK: - PagerTabStripDataSource
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 =  PageAViewController(nibName: "PageAViewController", bundle: nil) //TableChildExampleViewController(style: .plain, itemInfo: "FOLLOWING")
        let child_2 = PageBViewController(nibName: "PageBViewController", bundle: nil) //ChildExampleViewController(itemInfo: "YOU")
        let child_3 = MultiCollectionVC(nibName: "MultiCollectionVC", bundle: nil)
//        let child_4 = MultiCollectionVC(nibName: "MultiCollectionVC", bundle: nil)
//        let child_5 = PageBViewController(nibName: "PageBViewController", bundle: nil) //ChildExampleViewController(itemInfo: "YOU")
//        let child_6 = PageBViewController(nibName: "PageBViewController", bundle: nil) //ChildExampleViewController(itemInfo: "YOU")
        return [child_1, child_2,child_3 /*, child_4, child_5, child_6 */]
    }
    
}

