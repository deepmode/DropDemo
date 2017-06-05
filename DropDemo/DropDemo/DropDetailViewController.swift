//
//  DropDetailViewController.swift
//  DropDemo
//
//  Created by Eric Ho on 3/6/2017.
//  Copyright © 2017 EricHo. All rights reserved.
//

import UIKit

class DropDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    
    var item:HBDropItem?
    
    var imageSliderVC:HBImageSliderVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -- setup
    fileprivate func setup() {
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        
        //------------------
        // setup tableView to support dynamic tableview cell height
        self.tableView.estimatedRowHeight = self.tableView.rowHeight;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        //------------------
        
        self.tableView?.register(UINib(nibName: "DropDetailCell", bundle: Bundle.main), forCellReuseIdentifier: "Cell_DropDetail")
        
        //add the footer view to cover the line separator at the end of the table view
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 20.0)
        footerView.backgroundColor = UIColor.white
        self.tableView?.tableFooterView = footerView
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.tableView?.reloadData()
    }

}

extension DropDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //adjust the padding based on H compact or regular screen size (e.g. for iphone & ipad)
        
        let adaptLeading = Layout.DropDetailCell.viewLeadingPadding(containerWidth: self.view.bounds.width)
        let adaptTrailing = Layout.DropDetailCell.viewTrailingPadding(containerWidth: self.view.bounds.width)
        
        let mediaContainerLeading:CGFloat = 0.0
        let mediaContainerTrailing:CGFloat = 0.0
        let mediaContainerTop:CGFloat = 0.0
        let mediaContainerBottom:CGFloat = 0.0
        
        let imageHeight = ceil((tableView.bounds.width - adaptLeading - adaptTrailing - mediaContainerLeading - mediaContainerTrailing) *  (1 / Layout.contentImageRatio) ) + mediaContainerTop + mediaContainerBottom
        let spaceBelowImage:CGFloat = 8.0
        
        let availableWidth = tableView.bounds.width - adaptLeading - adaptTrailing - 16.0 - 16.0
    
        let titleText = self.item?.title ?? "" //"Pharrell Williams x addidas Originals Hu Tennis"
        
        let font = Layout.dropTitleFont
        let titleHeight = ceil(titleText.heightWithConstrainedWidth(availableWidth, font: font)) + 8.0 + 8.0
        let lineSpaceBelowTitle:CGFloat = 0.5
        
        let text = Layout.testText
        let detailTextViewHeight = ceil(text.heightWithConstrainedWidth(availableWidth, font: UIFont.systemFont(ofSize: 17.0))) + 16.0 + 16.0
        let lineSpaceBelowDescription:CGFloat = 0.5
        let whereToBuyHeight:CGFloat = 47.0
        let inTheNewsHeight:CGFloat = 47.0
        let buffer:CGFloat = 20.0 //for textView adjustment
        
        let finalHeight = imageHeight + spaceBelowImage + titleHeight + lineSpaceBelowTitle + (4 * 50.0) + detailTextViewHeight + lineSpaceBelowDescription + whereToBuyHeight + inTheNewsHeight + buffer
        
        return finalHeight
    }
    
}

extension DropDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_DropDetail", for: indexPath) as! DropDetailCell
        
        if let _ = self.item {
            cell.setupCell(item: self.item!)
            
//            if self.imageSliderVC == nil {
//                if let vc = UIStoryboard(name: "HBImageSlider", bundle: nil).instantiateViewController(withIdentifier: "SBID_HBImageSliderVC") as? HBImageSliderVC {
//                
//                    self.imageSliderVC = vc
//                    
//                    //#######################
//                    //controller containment
//                    self.addChildViewController(vc)
//                    vc.didMove(toParentViewController: self)
//                    
//                    cell.addHostedView(vc.view)
//
//                    //#######################
//                }
//            }
//            
//            
//            self.imageSliderVC?.photosLink = [
//                "https://hypebeast.imgix.net/http%3A%2F%2Fhypebeast.com%2Fimage%2F2017%2F06%2Fcdg-converse-ss-17-chuck-taylor-2.jpg?fit=max&fm=pjpg&ixlib=php-1.1.0&q=90&w=800&s=4b92b8ba5919c02ace5b2a2ad3a909a1",
//                "https://hypebeast.imgix.net/http%3A%2F%2Fhypebeast.com%2Fimage%2F2017%2F06%2Fcdg-converse-ss-17-chuck-taylor-3.jpg?fit=max&fm=pjpg&ixlib=php-1.1.0&q=90&w=800&s=7d960c63fe5370de821600e02f054c3d",
//                "https://hypebeast.imgix.net/http%3A%2F%2Fhypebeast.com%2Fimage%2F2017%2F06%2Fcdg-converse-ss-17-chuck-taylor-4.jpg?fit=max&fm=pjpg&ixlib=php-1.1.0&q=90&w=800&s=82af85c2a8f0f426ec1613a19f93f76a",
//                "https://hypebeast.imgix.net/http%3A%2F%2Fhypebeast.com%2Fimage%2F2017%2F06%2Fcdg-converse-ss-17-chuck-taylor-5.jpg?fit=max&fm=pjpg&ixlib=php-1.1.0&q=90&w=800&s=498a5500afdc68466a87bbd078a438b7",
//                "https://hypebeast.imgix.net/http%3A%2F%2Fhypebeast.com%2Fimage%2F2017%2F06%2Fcdg-converse-ss-17-chuck-taylor-7.jpg?fit=max&fm=pjpg&ixlib=php-1.1.0&q=90&w=800&s=0a9f269696b516645bef2dda110726c8"
//            ]
        }
        
        //cell.stackView?.axis = .horizontal
        return cell
    }
    
}
