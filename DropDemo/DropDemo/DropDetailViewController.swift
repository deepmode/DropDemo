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
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DropDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
        
        //cell.stackView?.axis = .horizontal
        return cell
    }
}
