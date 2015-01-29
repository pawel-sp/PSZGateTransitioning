//
//  GateAnimator.swift
//  PSZGateTransitioning
//
//  Created by Paweł Sporysz on 27.01.2015.
//  Copyright (c) 2015 Paweł Sporysz. All rights reserved.
//

import UIKit

// MARK: - IMPORTANT!!!
// source view controller MUST have type UITableViewController

public class GateAnimator: NSObject, UIViewControllerAnimatedTransitioning {
   
    // MARK: - Internal properties
    
    var snapshotViews:SnapshotViews?
    let initialDelay = 0.1
    lazy var cellSubviewDestinationFrame:CGRect = {
        return self.delegate?.animatedCellSubViewDestinationFrame(self) ?? CGRectZero
        }()
    var animatedCellSubview:UIView?

    // MARK: - Pubic properties
    
    public var reversedDirection:Bool = false
    public var delegate:GateAnimatorDelegate?
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 1.5
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
            
            // Animation
            popAnimation(fromVC: fromVC, toVC: toVC, snapshotViews: snapshotViews!, duration: duration, delay: 0) {
                toVC.view.alpha = 1
                upperSnapshotView.removeFromSuperview()
                lowerSnapshotView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
            
        } else {
            
            // Properties
            let tableView                 = (fromVC as UITableViewController).tableView
            snapshotViews                 = snapShotViewsForTableView((fromVC as UITableViewController).tableView)
            let upperSnapshotView         = snapshotViews!.upperSnapshotView
            let lowerSnapshotView         = snapshotViews!.lowerSnapshotView
            upperSnapshotView.alpha       = 0
            lowerSnapshotView.alpha       = 0
            containerView.backgroundColor = fromVC.view.backgroundColor
            toVC.view.alpha               = 0
            
            // Setup
            containerView.addSubview(snapshotViews!.upperSnapshotView)
            containerView.addSubview(snapshotViews!.lowerSnapshotView)
            
            animatedCellSubview = delegate?.animatedCellSubViewForGateAnimator(self)
            if animatedCellSubview != nil {
                animatedCellSubview!.frame.offset(
                    dx: 0,
                    dy: tableView.absoluteFrameForSelectedCell.origin.y
                )
                containerView.superview!.addSubview(animatedCellSubview!)
            }
            
            // Animation
            pushAnimation(fromVC: fromVC, toVC: toVC, snapshotViews: snapshotViews!, duration: duration - initialDelay, delay: initialDelay) {
                fromVC.view.transform = CGAffineTransformIdentity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
            
        }
    }
}
