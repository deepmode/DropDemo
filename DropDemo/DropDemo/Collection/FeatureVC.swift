//
//  FeatureVC.swift
//  MultiCollection
//
//  Created by Eric Ho on 12/8/2016.
//  Copyright © 2016 E H. All rights reserved.
//

import UIKit

class FeatureVC: UIViewController {
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    var dataSrc:[UIColor] = {
        
        var colors = [UIColor]()
        for each in 0..<100 {
            colors.append(UIColor.randomColor())
        }
        return colors
    }()
    
    //hold the latest size of VC's view bound
    fileprivate var currentSize:CGSize?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor = UIColor.green
        self.collectionView.register(UINib(nibName: "FeatureCell", bundle: Bundle.main), forCellWithReuseIdentifier:Constants.cellIdentifierFeature)
        
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        if let layout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        self.collectionView.isPagingEnabled = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("----- \(NSStringFromClass(self.classForCoder)).\(#function) -----")
        print("toSize: \(size)")
        
        //######################
        //self.currentSize (hold the latest size of VC's view bound)
        self.currentSize = size
        //######################
        
        //update the FeatureVC's frame
        var updateFrame = self.view.frame
        updateFrame.size.width = size.width
        self.view.frame = updateFrame

        
        if let flowlayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowlayout.invalidateLayout()
        }
        self.collectionView.reloadData()
    }
}

extension FeatureVC:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        let sectionType = SectionType.getSectionTypeWithRawValue(section)
        let edgeInserts = Layout.insetForSectionType(sectionType)
        return edgeInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        //return self.collectionViewCellVerticalSeparatorSpacing //provide spacing between vertial cell
        let sectionType = SectionType.getSectionTypeWithRawValue(section)
        let minimumLineSpacingForSection = Layout.minimumLineSpacingForSection(sectionType)
        return minimumLineSpacingForSection
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifierFeature, for: indexPath) as! FeatureCell
        
        cell.backgroundColor = self.dataSrc[indexPath.row]
        cell.setupCell("\(indexPath.row)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("----- \(NSStringFromClass(self.classForCoder)).\(#function) -----")
        print("collectionView bound: \(collectionView.bounds)  cell bound: \(cell.bounds)")
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSrc.count
    }
    
    
}
