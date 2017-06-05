//
//  HBImageSliderVC.swift
//  HBImageSliderVC
//
//  Created by EricHo on 10/12/2015.
//  Copyright © 2015 EricHo. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


private let reuseIdentifier = "Cell_HBImageView"

class HBImageSliderVC: UIViewController {
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var leftArrow: UIImageView!
    @IBOutlet weak var rightArrow: UIImageView!
    
    var photosLink:[String] = [String]() {
        didSet {
            self.pageControl?.numberOfPages = self.photosLink.count
            self.pageControl?.isHidden = true
            self.rightArrow?.isHidden = true
            self.leftArrow?.isHidden = true
            self.updateUI()
            self.collectionView?.reloadData()
        }
    }
    
    func generatePhotoLink() -> [String] {
        var links:[String] = [String]()
        for index in 1...10 {
            links.append("http://lorempixel.com/300/200/sports/" + "\(index)")
        }
        return links
    }
    
    //###########################
    fileprivate var newSize:CGSize?
    //###########################
    
    // MARK: - viewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.backgroundColor = UIColor.white
        
        //self.photosLink = self.generatePhotoLink()
        self.pageControl.numberOfPages = self.photosLink.count
        self.pageControl.isHidden = true
        self.rightArrow.isHidden = true
        self.leftArrow.isHidden = true
        
        self.updateUI()
        
        self.setupArrowsAction()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
        print("--# @@@@ collection view bound: \(self.collectionView.bounds.size)")
        print("--# @@@@ item size: \((self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)!.itemSize )")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
        print("--# @@@@ collection view bound: \(self.collectionView.bounds.size)")
        print("--# @@@@ item size: \((self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)!.itemSize )")
        

        //############################
        //############################
        //update the variable "newSize" and use this size for next collectionViewCell reload
        
        let width = self.collectionView.bounds.width
        let height = self.collectionView.bounds.height
        self.newSize = CGSize(width: width, height: height)
        let layout = (self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)!
        layout.invalidateLayout()
        self.collectionView.layoutIfNeeded()
        //############################
        //############################
        
        //############################
        //adjust the position (e.g. after rotation or re-sizing)
        if self.photosLink.count > 0 {
            let index = self.pageControl.currentPage
            self.collectionView?.scrollToItem(at: IndexPath(row: index, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        }
        //############################
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: left and right arrow action
    fileprivate func setupArrowsAction() {
        let leftTap = UITapGestureRecognizer(target: self, action: #selector(self.previousPage(_:)))
        leftTap.numberOfTapsRequired = 1
        self.leftArrow.addGestureRecognizer(leftTap)
        self.leftArrow.isUserInteractionEnabled = true
        
        let rightTap = UITapGestureRecognizer(target: self, action: #selector(self.nextPage(_:)))
        rightTap.numberOfTapsRequired = 1
        self.rightArrow.addGestureRecognizer(rightTap)
        self.rightArrow.isUserInteractionEnabled = true
    }
    
    func nextPage(_ tapGR:UITapGestureRecognizer) {
        print("next")
        if tapGR.state == UIGestureRecognizerState.recognized {
            print("regonize")
            let index = self.pageControl.currentPage
            let nextIndex = index + 1
            print("index: \(nextIndex)")
            if nextIndex < self.photosLink.count {
                let indexPath = IndexPath(row: nextIndex, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                self.pageControl.currentPage = nextIndex
                self.updateUI()
            }
        }
        
    }
    
    func previousPage(_ tapGR:UITapGestureRecognizer) {
        print("previous")
        if tapGR.state == UIGestureRecognizerState.recognized {
            print("regonize")
            let index = self.pageControl.currentPage
            let previousIndex = index - 1
            print("index: \(previousIndex)")
            if previousIndex < self.photosLink.count && previousIndex >= 0 {
                let indexPath = IndexPath(row: previousIndex, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                self.pageControl.currentPage = previousIndex
                self.updateUI()
            }
        }
    }
    
    // MARK: -
    
    let dotToArrowStartingPoint = 0 // e.g 0 -> use allow only, 3 -> arrow will be use when items greater than 3
    func updateUI() {
        
        //note: the ui element (e.g, self.pageControl, left arrow, right arrow) might be optional but guarnteen to be set the VC get fully loaded (IBOutlet might not be set when we set the photosLink which than trigger the updateUI method)
        DispatchQueue.main.async { () -> Void in
            
            if self.photosLink.count < 2 {
                self.pageControl?.isHidden = true
            }
            
            if self.photosLink.count >= 2 && self.photosLink.count <=  self.dotToArrowStartingPoint {
                self.pageControl?.isHidden = false
            }
            
            if self.photosLink.count > self.dotToArrowStartingPoint {
                
                if self.pageControl?.currentPage <= 0 {
                    self.leftArrow?.isHidden = true
                } else {
                    self.leftArrow?.isHidden = false
                }
                
                if self.pageControl?.currentPage  >=  (self.photosLink.count - 1) {
                    self.rightArrow?.isHidden = true
                } else {
                    self.rightArrow?.isHidden = false
                }
            }
        }
    }
    
    //MARL: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
        //note:special case - indexPathsForVisibleItems might return more than 1 items as a result of getting incorrect collection view cell index. Solution: Resolve this by delay the checking.
        if (self.collectionView.indexPathsForVisibleItems.count > 1) {
            let delayTime = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                if let indexPath = self.collectionView.indexPathsForVisibleItems.first {
                    self.pageControl.currentPage = indexPath.row
                    self.updateUI()
                }
            }
        } else {
            if let indexPath = self.collectionView.indexPathsForVisibleItems.first {
                self.pageControl.currentPage = indexPath.row
                self.updateUI()
            }
        }
    }
    
  
    // MARK: IBAction
    
    @IBAction func closeAction(_ sender: AnyObject) {
        self.dismiss(animated: true) { () -> Void in }
    }
    
    func removeUnwantItem() {
    }
    
    deinit {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
    }
}



extension HBImageSliderVC: UICollectionViewDataSource,UICollectionViewDelegate {
    //Use for size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
            
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
        
        if self.newSize == nil {
            print("--# CollectionView size: \(self.collectionView.bounds), return size: \((self.collectionView?.bounds.size)!)")
            return (self.collectionView?.bounds.size)!
        } else {
            print("--# CollectionView size: \(self.collectionView.bounds), return size: \(String(describing: self.newSize))")
            return self.newSize!
        }
    }
    
    //Use for interspacing
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
            return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
            return 0.0
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.photosLink.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? HBImageViewCVCell
        print("--# cell bounds: \(String(describing: cell?.bounds))")
        //print("--# cell scrollview bounds: \(cell?.scrollView.bounds)")
        //print("--# cell scrollview content size: \(cell?.scrollView.contentSize)")
        
        cell?.setupCell(self.photosLink[indexPath.row])
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.imgsScrlViewLongPressed(_:)))
        cell?.imageview.isUserInteractionEnabled = true
        cell?.imageview.addGestureRecognizer(longPressRecognizer)
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("--> \(NSStringFromClass(self.classForCoder)).\(#function)")
        
        //ensure the pageControl's current page in sync with the selected index
        self.pageControl.currentPage = indexPath.row
        self.performSegue(withIdentifier: "Segue_FullImage", sender: self)
    
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.contentViewController as? HBZoomableImageSliderVC, segue.identifier == "Segue_FullImage" {
            vc.photosLink = self.photosLink
            vc.selectedPage = self.pageControl.currentPage
            vc.minZoomScale = 1.0
            vc.maxZoomScale = 3.0
        }
    }
    
    // MARK: Image saving handler
    func imgsScrlViewLongPressed(_ sender: UILongPressGestureRecognizer)
    {
        print("longpressed")
        if (sender.state == UIGestureRecognizerState.ended) {
            print("Long press Ended");
            
        } else if (sender.state == UIGestureRecognizerState.began) {
            print("Long press detected.");
            
            if let imgView  = sender.view as? UIImageView, (imgView.image != nil)   {
                let saveImgAS = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                saveImgAS.addAction(UIAlertAction(title: "Save Image", style: .default, handler: { [weak self] (action) -> Void in
                    // Save image here
                    UIImageWriteToSavedPhotosAlbum(imgView.image!, self, #selector(HBImageSliderVC.image(_:didFinishSavingWithError:contextInfo:)), nil)
                }))
                
                saveImgAS.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                //###########
                //setting for popover (ipad)
                let pointInView = sender.location(in: imgView)
                let xAdjustment:CGFloat = 30
                saveImgAS.modalPresentationStyle = UIModalPresentationStyle.popover
                saveImgAS.popoverPresentationController?.sourceRect = CGRect(x: pointInView.x - xAdjustment, y: pointInView.y,width: 1,height: 1)
                saveImgAS.popoverPresentationController?.sourceView = imgView
                //###########
                self.present(saveImgAS, animated: true, completion: nil)
            }
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error == nil {
            let ac = UIAlertController(title: "Success!", message: "Image has been saved.", preferredStyle: .alert)
            present(ac, animated: true, completion: nil)
            
            let delayTime = DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                ac.dismiss(animated: true, completion: nil)
            }
            
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }

}
