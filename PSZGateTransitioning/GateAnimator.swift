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
    var animatedSubviewDestinationFrame:CGRect?
    var animatedSourceSubview:UIView?
    var animatedDestinationView:UIView?
    var animatedSourceSubviewSnapshot:UIView?

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
        return reversedDirection ? 5.0 : 5.5
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // Properties
        let containerView                             = transitionContext.containerView()
        let duration                                  = transitionDuration(transitionContext)
        let toVC                                      = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromVC                                    = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let operation:UINavigationControllerOperation = reversedDirection ? .Pop : .Push

        animatedSourceSubview                         = delegate.gateAnimator(self, animatedSubviewForOperation: operation)
        
        // Setup
        toVC.view.alpha = 0
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
 
        
        
        if reversedDirection && snapshotViews != nil {

            // Properties
            let upperSnapshotView = snapshotViews!.upperSnapshotView
            let lowerSnapshotView = snapshotViews!.lowerSnapshotView
            
            // Setup
            animatedSourceSubviewSnapshot = animatedSourceSubview?.snapshotViewAfterScreenUpdates(false)
            //animatedSourceSubview?.alpha  = 0
            animatedSubviewDestinationFrame   = delegate.gateAnimator(self, animatedSubviewDestinationFrameForOperation: .Pop)
            
            if let frame = delegate.gateAnimator(self, animatedSubviewStartFrameForOperation: .Pop) {
                animatedSourceSubviewSnapshot?.frame  = frame
            }
            if animatedSourceSubviewSnapshot != nil {
                containerView.superview!.addSubview(animatedSourceSubviewSnapshot!)
            }
            
            // Animation
            popAnimation(fromVC: fromVC, toVC: toVC, snapshotViews: snapshotViews!, duration: duration, delay: 0) {
                toVC.view.alpha                   = 1
                upperSnapshotView.removeFromSuperview()
                lowerSnapshotView.removeFromSuperview()
                self.animatedSourceSubviewSnapshot?.removeFromSuperview()
                self.delegate.gateAnimator(self, animatedSubviewForOperation: .Push)?.alpha = 1
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
            
        } else {

            // Properties
            animatedSourceSubview?.alpha      = 0
            snapshotViews                     = delegate.snapShotViewsFrameForGateAnimator(self)
            animatedSubviewDestinationFrame   = delegate.gateAnimator(self, animatedSubviewDestinationFrameForOperation: .Push)
            animatedSourceSubview?.alpha      = 1
            animatedSourceSubviewSnapshot     = animatedSourceSubview?.snapshotViewAfterScreenUpdates(false)
            
            //animatedSourceSubview?.alpha      = 0
            delegate.gateAnimator(self, animationWillStartForOperation: operation)
            
            let upperSnapshotView             = snapshotViews!.upperSnapshotView
            let lowerSnapshotView             = snapshotViews!.lowerSnapshotView
            let animatedDestinationSubview    = delegate.gateAnimator(self, animatedSubviewForOperation: .Pop)
            animatedDestinationSubview?.alpha = 0
            upperSnapshotView.alpha           = 0
            lowerSnapshotView.alpha           = 0
            containerView.backgroundColor     = fromVC.view.backgroundColor
            toVC.view.alpha                   = 0
            
            // Setup
            containerView.addSubview(snapshotViews!.upperSnapshotView)
            containerView.addSubview(snapshotViews!.lowerSnapshotView)

            if let frame = delegate.gateAnimator(self, animatedSubviewStartFrameForOperation: .Push) {
                animatedSourceSubviewSnapshot?.frame  = frame
            }
            if animatedSourceSubviewSnapshot != nil {
                containerView.superview!.addSubview(animatedSourceSubviewSnapshot!)
            }
            
            // Animation
            pushAnimation(fromVC: fromVC, toVC: toVC, snapshotViews: snapshotViews!, duration: duration - initialDelay, delay: initialDelay) {
                animatedDestinationSubview?.alpha = 1
                self.animatedSourceSubviewSnapshot?.removeFromSuperview()
                fromVC.view.transform             = CGAffineTransformIdentity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
            
        }
    }
}
