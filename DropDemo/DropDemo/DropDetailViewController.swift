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
        
        let imageHeight = ceil((tableView.bounds.width - adaptLeading - adaptTrailing - 8 - 8) * 2 / 3) + 8 + 8
        let spaceBelowImage:CGFloat = 8.0
        
        let availableWidth = tableView.bounds.width - adaptLeading - adaptTrailing - 16.0 - 16.0
    
        let titleText = self.item?.title ?? "" //"Pharrell Williams x addidas Originals Hu Tennis"
        
        let font = Layout.dropTitleFont
        let titleHeight = ceil(titleText.heightWithConstrainedWidth(availableWidth, font: font)) + 8.0 + 8.0
        let lineSpaceBelowTitle:CGFloat = 0.5
        
        let text = "The interest or the promise of prefab is nothing new, but it's been reignited, and gasoline continues to be poured on the fire, says Joseph Tanney of Resolution: 4 Architecture, a New York-based firm that has been developing modular housing systems since 2002. And because more architects are participating in this base, the level of design is increasing across the board. \n\nFirms such as Snøhetta -- known for their work on the Norwegian National Opera & Ballet and Bibliotheca Alexandrina -- are embracing the possibilities of this once-maligned form. We wanted to make quality architecture available to more people, says Snøhetta's Anne Cecilie Haug. If that all sounds a little expensive, major retailers are also getting into prefab -- including minimalist high street brand Muji -- who developed the Mujihut, coming soon in Japan."
        let detailTextViewHeight = ceil(text.heightWithConstrainedWidth(availableWidth, font: UIFont.systemFont(ofSize: 17.0))) + 16.0 + 16.0
        let lineSpaceBelowDescription:CGFloat = 0.5
        let whereToBuyHeight:CGFloat = 47.0
        let inTheNewsHeight:CGFloat = 47.0
        let buffer:CGFloat = 0.0
        
        let finalHeight = imageHeight + spaceBelowImage + titleHeight + lineSpaceBelowTitle + (4 * 47.0) + detailTextViewHeight + lineSpaceBelowDescription + whereToBuyHeight + inTheNewsHeight + buffer
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
        }
        
        //cell.stackView?.axis = .horizontal
        return cell
    }
    
}
