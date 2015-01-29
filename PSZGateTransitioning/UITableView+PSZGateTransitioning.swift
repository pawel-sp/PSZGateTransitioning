//
//  UITableView+PSZGateTransitioning.swift
//  PSZGateTransitioning
//
//  Created by Paweł Sporysz on 28.01.2015.
//  Copyright (c) 2015 Paweł Sporysz. All rights reserved.
//

import Foundation

extension UITableView {
    
    var selectedCell:UITableViewCell? {
        if let selectedIndexPath = indexPathForSelectedRow() {
            return cellForRowAtIndexPath(selectedIndexPath)
        }
        return nil
    }
    
    var selectedCellFrame:CGRect {
        return selectedCell?.frame ?? CGRectZero
    }
    
    func absoluteFrameForCellAtIndexPath(indexPath:NSIndexPath) -> CGRect {
        if let cell = cellForRowAtIndexPath(indexPath) {
            return cell.frame.rectByOffsetting(dx: 0, dy: -contentOffset.y)
        }
        return CGRectZero
    }
    
    var absoluteFrameForSelectedCell:CGRect {
        if let selectedIndexPath = indexPathForSelectedRow() {
            return absoluteFrameForCellAtIndexPath(selectedIndexPath)
        }
        return CGRectZero
    }
    
}