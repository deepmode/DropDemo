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
    
    //static let interCellSpacingForCollectionView:CGFloat = 20.0
    
    static var interCellSpacingForCollectionView: CGFloat {
        
        var hSizeClass:UIUserInterfaceSizeClass = .unspecified
        
        if let applicationWindow = UIApplication.shared.keyWindow /* UIApplication.sharedApplication().windows.first */ {
            switch applicationWindow.traitCollection.horizontalSizeClass  {
            case .compact:
                hSizeClass = .compact
            case .regular:
                hSizeClass = .regular
            case .unspecified:
                hSizeClass = .unspecified
            }
        }
        
        let cols = numberOfColumn(hSizeClass)
        
        if cols <= 1 {
            return 16.0
        } else {
            return 30.0
        }
    }
    
    
    static let cellTopPadding:CGFloat = interCellSpacingForCollectionView
    static let cellBottomPadding:CGFloat = interCellSpacingForCollectionView
    static let cellLeftPadding:CGFloat = interCellSpacingForCollectionView
    static let cellRightPadding:CGFloat = interCellSpacingForCollectionView
    
    static func numberOfColumn(_ sizeClass:UIUserInterfaceSizeClass) -> Int {
        switch sizeClass {
        case .compact:
            return 1
        case .regular:
            return 3
        default:
            return 1
        }
    }
    
    static func cellTitleLeadingPadding(_ sizeClass:UIUserInterfaceSizeClass) -> CGFloat {
        switch sizeClass {
            case .compact: return 0.0
            case .regular: return 10.0
            default: return 0.0
        }
    }
    
    static func cellTitleTrailingPadding(_ sizeClass:UIUserInterfaceSizeClass) -> CGFloat {
        switch sizeClass {
            case .compact: return 0.0
            case .regular: return 10.0
            default: return 0.0
        }
    }
    
    static func cellTitleTopPadding(_ sizeClass:UIUserInterfaceSizeClass) -> CGFloat {
        switch sizeClass {
            case .compact: return 0.0
            case .regular: return 0.0
            default: return 0.0
        }
    }
    
    static func cellTitleBottomPadding(_ sizeClass:UIUserInterfaceSizeClass) -> CGFloat {
        switch sizeClass {
            case .compact: return 0.0
            case .regular: return 0.0
            default: return 0.0
        }
    }
    
    
    static func minimumLineSpacingForSection(_ sectionType:SectionType) -> CGFloat {
        switch sectionType {
        case .feature:
            return 0.0
        case .channel:
            return 0.0
        case .newsfeed:
            return Layout.interCellSpacingForCollectionView
        case .unknown:
            return 0.0
        }
    }
    
    static func sectionCellSize(containerWidth:CGFloat, sectionType:SectionType, numberOfColumn:Int? = nil) -> CGSize {
        
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
                
                let imageRatio:CGFloat = 3/2
                let contentToImageHeightRatio:CGFloat = 0.5
                let imageHeight = cellWidth * 1 / imageRatio
                let cellHeight = imageHeight + imageHeight * contentToImageHeightRatio
                
                return CGSize(width: cellWidth, height: cellHeight)
            } else {
                //fixed height
                
                let imageRatio:CGFloat = 3/2
                let contentToImageHeightRatio:CGFloat = 0.55
                let imageHeight = cellWidth * 1 / imageRatio
                let cellHeight = imageHeight + imageHeight * contentToImageHeightRatio
                
                return CGSize(width: cellWidth,height: cellHeight)
            }
        case .unknown:
            return CGSize(width: 0,height: 0)
        }
    }
    
    static func insetForSectionType(_ sectionType:SectionType) -> UIEdgeInsets {
        let leftPadding:CGFloat = Layout.cellLeftPadding
        let rightPadding:CGFloat = Layout.cellRightPadding
        let topPadding:CGFloat = Layout.cellTopPadding
        let bottomPadding:CGFloat = Layout.cellBottomPadding
        
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
