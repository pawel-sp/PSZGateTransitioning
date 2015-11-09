//
//  UITableView+PSZGateTransitioning.swift
//  PSZGateTransitioning
//
//  Created by Paweł Sporysz on 28.01.2015.
//  Copyright (c) 2015 Paweł Sporysz. All rights reserved.
//

import Foundation

public extension UITableView {
    
    public var selectedCell:UITableViewCell? {
        if let selectedIndexPath = indexPathForSelectedRow {
            return cellForRowAtIndexPath(selectedIndexPath)
        }
        return nil
    }
    
    public var selectedCellFrame:CGRect {
        return selectedCell?.frame ?? CGRectZero
    }
    
    public func absoluteFrameForCellAtIndexPath(indexPath:NSIndexPath) -> CGRect {
        if let cell = cellForRowAtIndexPath(indexPath) {
            return cell.frame.offsetBy(dx: 0, dy: -contentOffset.y)
        }
        return CGRectZero
    }
    
    public var absoluteFrameForSelectedCell:CGRect {
        if let selectedIndexPath = indexPathForSelectedRow {
            return absoluteFrameForCellAtIndexPath(selectedIndexPath)
        }
        return CGRectZero
    }
    
    public var snapShotViews:SnapshotViews {
        let absoluteSelectedCellFrame   = absoluteFrameForSelectedCell
        let cellBelowTheTableViewCenter = absoluteSelectedCellFrame.origin.y + absoluteSelectedCellFrame.height/2 > frame.height/2
        
        let upperSnapShotViewFrame = CGRectMake(
            0,
            contentOffset.y,
            frame.width,
            (cellBelowTheTableViewCenter ? absoluteSelectedCellFrame.origin.y : absoluteSelectedCellFrame.height + absoluteSelectedCellFrame.origin.y)
        )
        
        let lowerSnapShotViewFrame = CGRectMake(
            0,
            contentOffset.y + upperSnapShotViewFrame.height,
            frame.width,
            frame.height - upperSnapShotViewFrame.height
        )
        
        let upperSnapshotView = resizableSnapshotViewFromRect(upperSnapShotViewFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
        let lowerSnapshotView = resizableSnapshotViewFromRect(lowerSnapShotViewFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
        lowerSnapshotView.frame.offsetInPlace(dx: 0, dy: upperSnapShotViewFrame.height)
        
        return (upperSnapshotView,lowerSnapshotView)
    }
    
}