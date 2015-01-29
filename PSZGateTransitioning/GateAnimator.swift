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
            
//            animatedSubview = delegate.gateAnimator(self, animatedSubviewForOperation: .Pop)
//            containerView.superview!.addSubview(animatedSubview!)

//            
//            if let frame = delegate.gateAnimator(self, animatedSubviewStartFrameForOperation: .Pop) {
//                animatedSubview?.transform = CGAffineTransformMakeTranslation(
//                    frame.origin.x,
//                    frame.origin.y
//                )
//            }
            
//            UIView.animateWithDuration(duration, animations: { () -> Void in
//                self.animatedSubview!.transform = CGAffineTransformMakeTranslation(0, 300)
//            })
            
//            animatedSubviewDestinationFrame = delegate.gateAnimator(self, animatedSubviewDestinationFrameForOperation: .Pop)
//            if let frame = delegate.gateAnimator(self, animatedSubviewStartFrameForOperation: .Pop) {
//                animatedSourceSubview?.frame  = frame
//            }
//            if animatedSourceSubview != nil {
//                containerView.superview!.addSubview(animatedSourceSubview!)
//            }
            
            // Animation
            popAnimation(fromVC: fromVC, toVC: toVC, snapshotViews: snapshotViews!, duration: duration, delay: 0) {
                toVC.view.alpha                   = 1
                self.animatedSourceSubview?.alpha = 1
                upperSnapshotView.removeFromSuperview()
                lowerSnapshotView.removeFromSuperview()
                //self.animatedSourceSubview?.frame = CGRectMake(0, 100, 100, 100)
                //fromVC.view.addSubview(self.animatedSourceSubview!)
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
            
        } else {

            // Properties
            animatedSourceSubview           = delegate.gateAnimator(self, animatedSubviewForOperation: .Push)
            animatedSourceSubview?.alpha    = 0
            snapshotViews                   = delegate.snapShotViewsFrameForGateAnimator(self)
            animatedSubviewDestinationFrame = delegate.gateAnimator(self, animatedSubviewDestinationFrameForOperation: .Push)
            animatedSourceSubviewSnapshot   = animatedSourceSubview?.snapshotViewAfterScreenUpdates(true)
            let upperSnapshotView           = snapshotViews!.upperSnapshotView
            let lowerSnapshotView           = snapshotViews!.lowerSnapshotView
            //let animatedDestinationSubview    = delegate.gateAnimator(self, animatedSubviewForOperation: .Pop)
            //animatedDestinationSubview?.alpha = 0
            upperSnapshotView.alpha         = 0
            lowerSnapshotView.alpha         = 0
            containerView.backgroundColor   = fromVC.view.backgroundColor
            toVC.view.alpha                 = 0
            
            // Setup
            containerView.addSubview(snapshotViews!.upperSnapshotView)
            containerView.addSubview(snapshotViews!.lowerSnapshotView)

//            if let frame = delegate.gateAnimator(self, animatedSubviewStartFrameForOperation: .Push) {
//                animatedSourceSubview?.frame  = frame
//            }
//            if animatedSourceSubview != nil {
//                containerView.superview!.addSubview(animatedSourceSubview!)
//            }
            
            // Animation
            pushAnimation(fromVC: fromVC, toVC: toVC, snapshotViews: snapshotViews!, duration: duration - initialDelay, delay: initialDelay) {
                //animatedDestinationSubview?.alpha = 1
                //self.animatedSourceSubview?.removeFromSuperview()
                fromVC.view.transform             = CGAffineTransformIdentity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
            
        }
    }
}
