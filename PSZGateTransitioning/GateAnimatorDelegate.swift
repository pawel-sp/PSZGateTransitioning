//
//  GateAnimatorDelegate.swift
//  PSZGateTransitioning
//
//  Created by Paweł Sporysz on 28.01.2015.
//  Copyright (c) 2015 Paweł Sporysz. All rights reserved.
//

import Foundation

public typealias SnapshotViews = (upperSnapshotView:UIView, lowerSnapshotView:UIView)

public protocol GateAnimatorDelegate {
    
    func snapShotViewsFrameForGateAnimator(gateAnimator:GateAnimator) -> SnapshotViews
    
    func gateAnimator(gateAnimator:GateAnimator, animationWillStartForOperation operation:UINavigationControllerOperation)
    func gateAnimator(gateAnimator:GateAnimator, animatedSubviewStartFrameForOperation operation:UINavigationControllerOperation) -> CGRect?
    func gateAnimator(gateAnimator:GateAnimator, animatedSubviewForOperation operation:UINavigationControllerOperation) -> UIView?
    func gateAnimator(gateAnimator:GateAnimator, animatedSubviewDestinationFrameForOperation operation:UINavigationControllerOperation) -> CGRect?
    
}