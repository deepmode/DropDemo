//
//  HBLayout.swift
//  DropDemo
//
//  Created by Eric Ho on 30/5/2017.
//  Copyright © 2017 EricHo. All rights reserved.
//

import Foundation
import UIKit

enum SectionType:Int {
    
    case feature = 0
    case channel
    case newsfeed
    case unknown
    
    
    static func getSectionTypeWithRawValue(_ rawValue:Int) -> SectionType {
        switch rawValue {
        case 0:
            return SectionType.feature
        case 1:
            return SectionType.channel
        case 2:
            return SectionType.newsfeed
        default:
            return SectionType.unknown
        }
    }
    
    static var count:Int {
        return 4
    }
}




struct Layout {
    
    enum DisplayMode {
        case compact    //for left right cell,
        case regular    //vertical and multi-line cell
    }
    
    //static let interCellSpacingForCollectionView:CGFloat = 20.0
    
    static var dropTitleFont:UIFont {
        return Layout.DropCell.newsfeedTitleFontWith(displaySytle: .regular)
    }
    
    struct DropCell {
        
        static var numberOfLinesForNewsfeedTitle:Int {
            return Layout.numberOfColumn(.regular) <= 1 ? 0 : 3
        }

        static let FontNameRegular:String = {
            
            return "Roboto-Medium"
            
//            switch HBCommon.SelectAppType {
//            case .Hypebeast:
//                return "Roboto-Medium"
//            case .Hypebae:
//                return "JosefinSans"
//            }
        }()
        
        static let FontNameBold:String = {
            
            return "Roboto-Medium"
            
//            switch HBCommon.SelectAppType {
//            case .Hypebeast:
//                return "Roboto-Medium"
//            case .Hypebae:
//                return "JosefinSans-SemiBold"
//            }
        }()
        
        static func newsfeedTitleFontWith(displaySytle:DisplayMode) -> UIFont {
            
            var targetFontSize:CGFloat = 18.0
            
//            switch HBCommon.SelectAppType {
//            case .Hypebeast:
//                targetFontSize = 18.0
//            case .Hypebae:
//                targetFontSize = targetFontSize + 2.0
//                
//            }
            
            
            //note: Changing the size will also affect the calculation of collection view cell height

            switch Layout.currentHSizeClass {
                case .compact:
                    switch displaySytle {
                        case .compact: break
                        case .regular: targetFontSize = targetFontSize + 1.0
                    }
                    return  UIFont(name: Layout.DropCell.FontNameBold, size: targetFontSize) ?? UIFont.systemFont(ofSize: targetFontSize)
                case .regular:
                    return UIFont(name: Layout.DropCell.FontNameBold, size: targetFontSize) ?? UIFont.systemFont(ofSize: targetFontSize)
                case .unspecified:
                    return UIFont(name: Layout.DropCell.FontNameBold, size: targetFontSize) ?? UIFont.systemFont(ofSize: targetFontSize)
            }

            
        }
        
        static let belowImageSpaceHeight:CGFloat = 8.0
        
        static let belowTitleSpaceHeight:CGFloat = 8.0 //only apply when columns = 1
        
        static let toolViewHeight:CGFloat = 30.0
        
        static var belowToolViewSpaceHeight:CGFloat {
            
            let hSizeClass = Layout.currentHSizeClass
            let cols = Layout.numberOfColumn(hSizeClass)
            
            let result = cols <= 1 ? 0.0 : 8.0
            return CGFloat(result)
        }
    }
    
    
    struct DropDetailCell {
        
        static func viewLeadingPadding(containerWidth:CGFloat) -> CGFloat {
            switch Layout.currentHSizeClass {
            case .compact: return 0.0
            case .regular: return containerWidth * 0.2 / 2
            case .unspecified: return 0.0
            }
        }
        
        static func viewTrailingPadding(containerWidth:CGFloat) -> CGFloat {
            switch Layout.currentHSizeClass {
            case .compact: return 0.0
            case .regular: return containerWidth * 0.2 / 2
            case .unspecified: return 0.0
            }
        }
    }
    

    static var currentScreenSize:CGSize? {
        if let applicationWindow = UIApplication.shared.keyWindow {
            return applicationWindow.frame.size
        }
        return nil
    }
    
    static var currentHSizeClass:UIUserInterfaceSizeClass {
        
        var hSizeClass:UIUserInterfaceSizeClass = .unspecified
        
        if let applicationWindow = UIApplication.shared.keyWindow /* UIApplication.sharedApplication().windows.first */ {
            switch applicationWindow.traitCollection.horizontalSizeClass  {
            case .compact: hSizeClass = .compact
            case .regular: hSizeClass = .regular
            case .unspecified: hSizeClass = .unspecified
            }
        }
        return hSizeClass
    }
    
    static var interCellSpacingForCollectionView: CGFloat {
        
        let hSizeClass = Layout.currentHSizeClass
        let cols = numberOfColumn(hSizeClass)
        
        let result = cols <=  1 ? 0.0 : 30.0
        return CGFloat(result)
    }
    
    static var interStackViewTopPadding:CGFloat {
        let hSizeClass = Layout.currentHSizeClass
        let cols = numberOfColumn(hSizeClass)
        
        let result = cols <= 1 ? 16.0 : 0.0
        return CGFloat(result)
    }
    
    static var interStackViewBottomPadding:CGFloat {
        let hSizeClass = Layout.currentHSizeClass
        let cols = numberOfColumn(hSizeClass)
        
        //----------------
        //SUPER IMPORTANT
        //note: when in single column, to make the cell top and bottom padding balance, we need to subtract e.g. 8pt (height of dummy space below tool view)
        //----------------

        let result = cols <= 1 ? 16.0 : 0.0
        return CGFloat(result)
    }
    
    static var interStackViewLeadingPadding:CGFloat {
        let hSizeClass = Layout.currentHSizeClass
        let cols = numberOfColumn(hSizeClass)
        
        let result = cols <= 1 ? 16.0 : 0.0
        return CGFloat(result)
    }
    
    static var interStackViewTrailingPadding:CGFloat {
        let hSizeClass = Layout.currentHSizeClass
        let cols = numberOfColumn(hSizeClass)
        
        let result = cols <= 1 ? 16.0 : 0.0
        return CGFloat(result)
    }
    
    static func numberOfColumn(_ sizeClass:UIUserInterfaceSizeClass) -> Int {

        //sizeClass no longer in user to determine the number of columns
//        switch sizeClass {
//            case .compact: return 1
//            case .regular: return 3
//            case .unspecified: return 1
//        }
        
        var numberOfCellsPerRow = 1
        let extraColoum = 0
        
        if let applicationWindow = UIApplication.shared.keyWindow {
            
            let screenWidth = applicationWindow.frame.size.width
            
            if screenWidth <= 320 {
                numberOfCellsPerRow = 1
            } else if screenWidth <= 375 /* 375 or ipad pro protrait split view small*/ {
                numberOfCellsPerRow = 1
            } else if screenWidth <= 414 /* 414 */{
                numberOfCellsPerRow = 1
            } else if screenWidth <= 438 /* ipad air portrait ~2/3 */ {
                numberOfCellsPerRow = 2
            } else if screenWidth <= 480 {
                numberOfCellsPerRow = 3
            } else if screenWidth <= 507 /* ipad air 2 split half (landscape) */ {
                numberOfCellsPerRow = 2
            } else if screenWidth <= 568 {
                numberOfCellsPerRow = 3
            } else if screenWidth <= 639 /* ipad pro protrait split ~2/3*/ {
                numberOfCellsPerRow = 2
            } else if screenWidth <= 667 {
                numberOfCellsPerRow = 3
            } else if screenWidth <= 678 /* ipad pro landscape split half */{
                numberOfCellsPerRow = 2 + extraColoum
            } else if screenWidth <= 694 /* ipad air landscape split ~2/3 */{
                numberOfCellsPerRow = 2 + extraColoum
            } else if screenWidth <= 736 {
                numberOfCellsPerRow = 3
            } else if screenWidth <= 768 { /* ipad air portrait */
                numberOfCellsPerRow = 2 + extraColoum
            } else if screenWidth <= 981  /* ipad pro landscape split view */{
                numberOfCellsPerRow = 3
            } else if screenWidth <= 1024 /* ipad air landscape */{
                numberOfCellsPerRow = 3 + extraColoum
            } else if screenWidth <= 1366 /* ipad pro protrait full */{
                numberOfCellsPerRow = 4
            } else {
                numberOfCellsPerRow = 4
            }
        }
        return numberOfCellsPerRow
    }
    
    static var cellTitleLeadingPadding:CGFloat {
        
        let hSizeClass = Layout.currentHSizeClass
        switch hSizeClass {
            case .compact: return 0.0
            case .regular: return 10.0
            case .unspecified: return 0.0
        }
    }
    
    static var cellTitleTrailingPadding: CGFloat {
        
        let hSizeClass = Layout.currentHSizeClass
        switch hSizeClass {
            case .compact: return 0.0
            case .regular: return 10.0
            default: return 0.0
        }
    }
    
    
    static func minimumLineSpacingForSection(_ sectionType:SectionType) -> CGFloat {
        switch sectionType {
            case .feature: return 0.0
            case .channel: return 0.0
            case .newsfeed: return Layout.interCellSpacingForCollectionView
            case .unknown: return 0.0
        }
    }
    
    static let contentImageRatio:CGFloat = 3 / 2
    
    static func sectionCellSize(containerWidth:CGFloat, sectionType:SectionType, numberOfColumn:Int? = nil, font:UIFont? = nil, text:String? = nil) -> CGSize {
        
        let interCellSpacing:CGFloat = Layout.interCellSpacingForCollectionView
        
        switch sectionType {
        case .feature:
            return CGSize(width: containerWidth, height: 250)
        case .channel:
            return CGSize(width: containerWidth, height: 100)
        case .newsfeed:
            
            //default to single column
            var cols:CGFloat = 1.0
            
            if let numberOfColumn = numberOfColumn {
                cols = CGFloat(numberOfColumn)
            }
            
            let cellWidth = (containerWidth - ((cols + 1) * interCellSpacing)) / cols
            
            if cols <= 1 {
                
                //height should be calcualted based on the text
                
                let availableInnerCellWidth = cellWidth - Layout.interStackViewLeadingPadding - Layout.interStackViewTrailingPadding
                let availableInnerTitleWidth = availableInnerCellWidth - Layout.cellTitleLeadingPadding - Layout.cellTitleTrailingPadding
        
                
                let topPadding = Layout.interStackViewTopPadding
                let imageHeight = ceil(availableInnerCellWidth *  1 / Layout.contentImageRatio)
                let h1:CGFloat = Layout.DropCell.belowImageSpaceHeight
            
                let f = font ?? Layout.dropTitleFont
                let t = text ?? ""
                let titleHeight = ceil(t.heightWithConstrainedWidth(availableInnerTitleWidth, font: f))
                let h2:CGFloat = Layout.DropCell.belowTitleSpaceHeight
                let toolViewHeight:CGFloat = Layout.DropCell.toolViewHeight
                let h3:CGFloat = Layout.DropCell.belowToolViewSpaceHeight
                let bottomPadding = Layout.interStackViewBottomPadding
                let bufferAdjustment:CGFloat = 0.0
                
                let cellHeight = topPadding + imageHeight + h1 + titleHeight + h2 + toolViewHeight + h3 + bottomPadding + bufferAdjustment
                
                return CGSize(width: cellWidth, height: cellHeight)
            } else {
                //fixed height
                
                let contentToImageHeightRatio:CGFloat = 0.58 //or 0.60
                let imageHeight = cellWidth * 1 / Layout.contentImageRatio
                let cellHeight = imageHeight + imageHeight * contentToImageHeightRatio
                
                return CGSize(width: cellWidth,height: cellHeight)
            }
        case .unknown:
            return CGSize(width: 0,height: 0)
        }
    }
    
    static func insetForSectionType(_ sectionType:SectionType) -> UIEdgeInsets {
        let leftPadding:CGFloat = Layout.interCellSpacingForCollectionView
        let rightPadding:CGFloat = Layout.interCellSpacingForCollectionView
        let topPadding:CGFloat = Layout.interCellSpacingForCollectionView
        let bottomPadding:CGFloat = Layout.interCellSpacingForCollectionView
        
        switch sectionType {
        case .feature:
            return UIEdgeInsetsMake(0, 0, 0, 0)
        case .channel:
            return UIEdgeInsetsMake(0, 0, 0, 0)
        case .newsfeed:
            return UIEdgeInsetsMake(topPadding, leftPadding, bottomPadding, rightPadding)
        case .unknown:
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
}
