//
//  GateAnimatorDelegate.swift
//  PSZGateTransitioning
//
//  Created by Paweł Sporysz on 28.01.2015.
//  Copyright (c) 2015 Paweł Sporysz. All rights reserved.
//

import Foundation

public protocol GateAnimatorDelegate {
    
    // it must be cell's subview
    func animatedCellSubViewForGateAnimator(gateAnimator:GateAnimator) -> UIView?
    
    func animatedCellSubViewDestinationFrame(gateAnimator:GateAnimator) -> CGRect
    
}