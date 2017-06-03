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
        settings.style.buttonBarHeight = 40.0
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
            
            if changeCurrentIndex == true && newCell != nil {
                print("changeCurrentIndex: \(changeCurrentIndex) \t o: \(String(describing: oldCell?.label?.text!)) \t  n: \(String(describing: newCell?.label?.text!))" )
                print("last currentIndex: \(self?.currentIndex ?? -1)")
            }
            
            guard changeCurrentIndex == true else {
                return
            }
            
            oldCell?.label.textColor = UIColor.lightGray
            newCell?.label.textColor = self?.themeColor
        }
        
        
        changeCurrentIndex = { [weak self] (_ oldCell: ButtonBarViewCell?, _ newCell: ButtonBarViewCell?, _ animated: Bool) -> Void in
            //note: this one not execute, check the documentation
        }
        
        super.viewDidLoad()
        self.moveToViewController(at: 2, animated: true)
    }
    
    // MARK: - PagerTabStripDataSource
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
//        let sb = UIStoryboard(name: "ListViewController", bundle: nil)
//        let child_0 = sb.instantiateViewController(withIdentifier: "SBID_ListViewController") as! ListViewController
        let child_a = DropListViewController(itemInfo:"Upcoming", requestLink:"https://hypebeast.com/?limit=20")
        let child_b = DropListViewController(itemInfo:"New Releases", requestLink:"https://hypebeast.com/kr/?limit=20")
        let child_c = DropListViewController(itemInfo:"China", requestLink:"https://hypebeast.cn/?limit=20")
        let child_d = DropListViewController(itemInfo:"Japan", requestLink:"https://hypebeast.com/jp/?limit=20")
        let child_e = DropListViewController(itemInfo:"Hong Kong", requestLink:"https://hypebeast.com/hk/?limit=20")
        
        let child_0 = ListViewController(itemInfo: "Listing")
        let child_1 = PageAViewController(itemInfo: "Upcoming")
        let child_2 = PageBViewController(itemInfo: "Latest")
        let child_3 = MultiCollectionVC(itemInfo:"MultiCollection")
        
        
//        let child_4 = MultiCollectionVC(nibName: "MultiCollectionVC", bundle: nil)
//        let child_5 = PageBViewController(nibName: "PageBViewController", bundle: nil) //ChildExampleViewController(itemInfo: "YOU")
//        let child_6 = PageBViewController(nibName: "PageBViewController", bundle: nil) //ChildExampleViewController(itemInfo: "YOU")
        return [child_a, child_b, child_c, child_d, child_e, child_0, child_1, child_2,child_3/*, child_4, child_5, child_6 */]
    }
}

