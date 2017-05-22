//
//  CollectionViewCell.swift
//  MultiCollection
//
//  Created by EricHo on 12/8/2016.
//  Copyright © 2016 E H. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!

    @IBOutlet weak var textLabel:UILabel!
    
    fileprivate var title:String? {
        didSet {
            self.textLabel?.text = title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(_ title:String) {
        self.title = title
    }
    
//    func setCollectionViewDataSourceDelegate <D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>(dataSourceDelegate: D, forRow row: Int) {
//        self.collectionView?.delegate = dataSourceDelegate
//        self.collectionView?.dataSource = dataSourceDelegate
//        self.collectionView?.tag = row
//        self.collectionView?.reloadData()
//    }

}
