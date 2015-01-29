//
//  GateAnimator.swift
//  PSZGateTransitioning
//
//  Created by Paweł Sporysz on 27.01.2015.
//  Copyright (c) 2015 Paweł Sporysz. All rights reserved.
//

import UIKit

public class GateAnimator: NSObject, UIViewControllerAnimatedTransitioning {
   
    // MARK: - Internal properties
    
    var snapshotViews:SnapshotViews?
    let initialDelay = 0.1
    var cellSubviewDestinationFrame:CGRect?
    var animatedCellSubview:UIView?

    // MARK: - Pubic properties
    
    public var reversedDirection:Bool = false
    public var delegate:GateAnimatorDelegate
    
    // MARK: - Init
    
    public init(target:GateAnimatorDelegate) {
        delegate = target
        super.init()
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return reversedDirection ? 1.0 : 1.5
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // Properties
        let containerView           = transitionContext.containerView()
        let duration                = transitionDuration(transitionContext)
        let toVC                    = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromVC                  = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!

        // Setup
        toVC.view.alpha = 0
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        if reversedDirection && snapshotViews != nil {

            // Properties
            let upperSnapshotView = snapshotViews!.upperSnapshotView
            let lowerSnapshotView = snapshotViews!.lowerSnapshotView
            
            // Setup
            animatedCellSubview         = delegate.gateAnimator(self, animatedSubviewForOperation: .Pop)
            cellSubviewDestinationFrame = delegate.gateAnimator(self, animatedSubviewDestinationFrameForOperation: .Pop)
            if animatedCellSubview != nil {
                containerView.superview!.addSubview(animatedCellSubview!)
            }
            
            // Animation
            popAnimation(fromVC: fromVC, toVC: toVC, snapshotViews: snapshotViews!, duration: duration, delay: 0) {
                toVC.view.alpha = 1
                upperSnapshotView.removeFromSuperview()
                lowerSnapshotView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
            
        } else {
            
            // Properties
            snapshotViews                 = delegate.snapShotViewsFrameForGateAnimator(self)
            cellSubviewDestinationFrame   = delegate.gateAnimator(self, animatedSubviewDestinationFrameForOperation: .Push)
            animatedCellSubview           = delegate.gateAnimator(self, animatedSubviewForOperation: .Push)
            let upperSnapshotView         = snapshotViews!.upperSnapshotView
            let lowerSnapshotView         = snapshotViews!.lowerSnapshotView
            upperSnapshotView.alpha       = 0
            lowerSnapshotView.alpha       = 0
            containerView.backgroundColor = fromVC.view.backgroundColor
            toVC.view.alpha               = 0
            
            // Setup
            containerView.addSubview(snapshotViews!.upperSnapshotView)
            containerView.addSubview(snapshotViews!.lowerSnapshotView)
            
            if let frame = delegate.gateAnimator(self, animatedSubviewStartFrameForOperation: .Push) {
                animatedCellSubview?.frame  = frame
            }
            if animatedCellSubview != nil {
                containerView.superview!.addSubview(animatedCellSubview!)
            }
            
            // Animation
            pushAnimation(fromVC: fromVC, toVC: toVC, snapshotViews: snapshotViews!, duration: duration - initialDelay, delay: initialDelay) {
                self.animatedCellSubview?.removeFromSuperview()
                fromVC.view.transform = CGAffineTransformIdentity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
            
        }
    }
}
