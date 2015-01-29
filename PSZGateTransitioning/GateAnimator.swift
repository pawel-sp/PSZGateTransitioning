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
        return delegate.gateAnimator(self, transitionDurationForOperation: reversedDirection ? .Pop : .Push)
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView                             = transitionContext.containerView()
        let duration                                  = transitionDuration(transitionContext)
        let toVC                                      = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromVC                                    = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let operation:UINavigationControllerOperation = reversedDirection ? .Pop : .Push

        animatedSourceSubview                         = delegate.gateAnimator(self, animatedSubviewForOperation: operation)
        animatedSubviewDestinationFrame               = delegate.gateAnimator(self, animatedSubviewDestinationFrameForOperation: operation)
        animatedSourceSubviewSnapshot                 = animatedSourceSubview?.snapshotViewAfterScreenUpdates(false)
        
        toVC.view.alpha                               = 0
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        prepareViewControllers(fromVC: fromVC, toVC: toVC, enabled: false)
        
        if operation == .Push {
            snapshotViews  = delegate.snapShotViewsFrameForGateAnimator(self)
        }
        
        delegate.gateAnimator(self, animationWillStartForOperation: operation)
        
        prepareContainerView(containerView, fromVC: fromVC, forOperation: operation)

        animationForOperation(operation, fromVC: fromVC, toVC: toVC, duration: duration) {
            self.delegate.gateAnimator(self, animationDidFinishForOperation: operation)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            self.prepareViewControllers(fromVC: fromVC, toVC: toVC, enabled: true)
        }
    }
    
    // MARK: - Setup
    
    func prepareViewControllers(#fromVC:UIViewController, toVC:UIViewController, enabled:Bool) {
        fromVC.navigationController?.view.userInteractionEnabled = enabled
        toVC.navigationController?.view.userInteractionEnabled   = enabled
    }
    
    func prepareContainerView(containerView:UIView, fromVC:UIViewController, forOperation operation:UINavigationControllerOperation) {
        switch operation {
        case .Push:
            
            containerView.backgroundColor     = fromVC.view.backgroundColor
            
            let upperSnapshotView             = snapshotViews!.upperSnapshotView
            let lowerSnapshotView             = snapshotViews!.lowerSnapshotView
            upperSnapshotView.alpha           = 0
            lowerSnapshotView.alpha           = 0
            containerView.addSubview(snapshotViews!.upperSnapshotView)
            containerView.addSubview(snapshotViews!.lowerSnapshotView)

            
        case .Pop:  break
        default:    break
        }
        
        if let frame = delegate.gateAnimator(self, animatedSubviewStartFrameForOperation: operation) {
            animatedSourceSubviewSnapshot?.frame  = frame
        }
        if animatedSourceSubviewSnapshot != nil {
            containerView.superview!.addSubview(animatedSourceSubviewSnapshot!)
        }
    }
}
