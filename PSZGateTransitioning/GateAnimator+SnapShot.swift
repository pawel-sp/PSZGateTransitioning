//
//  GateAnimator+SnapShot.swift
//  PSZGateTransitioning
//
//  Created by Paweł Sporysz on 28.01.2015.
//  Copyright (c) 2015 Paweł Sporysz. All rights reserved.
//

import Foundation

typealias SnapshotViews = (upperSnapshotView:UIView, lowerSnapshotView:UIView)

extension GateAnimator {
    
    func snapShotViewsForTableView(tableView:UITableView) -> SnapshotViews {
        let absoluteSelectedCellFrame   = tableView.absoluteFrameForSelectedCell
        let cellBelowTheTableViewCenter = absoluteSelectedCellFrame.origin.y + absoluteSelectedCellFrame.height/2 > tableView.frame.height/2
        
        let upperSnapShotViewFrame = CGRectMake(
            0,
            tableView.contentOffset.y,
            tableView.frame.width,
            (cellBelowTheTableViewCenter ? absoluteSelectedCellFrame.origin.y : absoluteSelectedCellFrame.height + absoluteSelectedCellFrame.origin.y)
        )
        
        let lowerSnapShotViewFrame = CGRectMake(
            0,
            tableView.contentOffset.y + upperSnapShotViewFrame.height,
            tableView.frame.width,
            tableView.frame.height - upperSnapShotViewFrame.height
        )

        let upperSnapshotView = tableView.resizableSnapshotViewFromRect(upperSnapShotViewFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
        let lowerSnapshotView = tableView.resizableSnapshotViewFromRect(lowerSnapShotViewFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
        lowerSnapshotView.frame.offset(dx: 0, dy: upperSnapShotViewFrame.height)
        
        return (upperSnapshotView,lowerSnapshotView)
    }
    
}