//
//  GateAnimator+Animations.swift
//  PSZGateTransitioning
//
//  Created by Paweł Sporysz on 28.01.2015.
//  Copyright (c) 2015 Paweł Sporysz. All rights reserved.
//

import Foundation

typealias GateAnimationCompletionBlock = () -> ()

extension GateAnimator {

    func animationForOperation(operation:UINavigationControllerOperation, fromVC:UIViewController, toVC:UIViewController, duration: NSTimeInterval, completionBlock:GateAnimationCompletionBlock? = nil) {
        switch operation {
        case .Push:
            pushAnimation(fromVC: fromVC, toVC: toVC, snapshotViews: snapshotViews!, duration: duration - initialDelay, delay: initialDelay) {
                self.animatedSourceSubviewSnapshot?.removeFromSuperview()
                fromVC.view.transform = CGAffineTransformIdentity
                completionBlock?()
            }
        case .Pop:
            popAnimation(fromVC: fromVC, toVC: toVC, snapshotViews: snapshotViews!, duration: duration, delay: 0) {
                toVC.view.alpha                   = 1
                self.snapshotViews?.upperSnapshotView.removeFromSuperview()
                self.snapshotViews?.lowerSnapshotView.removeFromSuperview()
                self.animatedSourceSubviewSnapshot?.removeFromSuperview()
                completionBlock?()
            }
        default: break
        }
    }
    
    func popAnimation(#fromVC:UIViewController, toVC:UIViewController, snapshotViews:SnapshotViews, duration:NSTimeInterval, delay:NSTimeInterval, completionBlock:GateAnimationCompletionBlock? = nil) {
        UIView.animateKeyframesWithDuration(
            duration,
            delay: 0,
            options: UIViewKeyframeAnimationOptions.CalculationModePaced,
            animations: { () -> Void in
            
                // source view
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1, animations: { () -> Void in
                    fromVC.view.alpha = 0
                })
            
                // snapshots
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1, animations: { () -> Void in
                    snapshotViews.upperSnapshotView.transform = CGAffineTransformIdentity
                    snapshotViews.upperSnapshotView.alpha     = 1
                    snapshotViews.lowerSnapshotView.transform = CGAffineTransformIdentity
                    snapshotViews.lowerSnapshotView.alpha     = 1
                })
                
                // animated subview
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1, animations: { () -> Void in
                    if self.animatedSourceSubviewSnapshot != nil && self.animatedSubviewDestinationFrame != nil {
                        self.animatedSourceSubviewSnapshot!.transform = CGAffineTransformMakeTranslation(
                            self.animatedSubviewDestinationFrame!.origin.x - self.animatedSourceSubviewSnapshot!.frame.origin.x,
                            self.animatedSubviewDestinationFrame!.origin.y - self.animatedSourceSubviewSnapshot!.frame.origin.y
                        )
                    }
                })
            }, completion: { (finished) -> Void in
                completionBlock?()
                return
            }
        )
    }
    
    func pushAnimation(#fromVC:UIViewController, toVC:UIViewController, snapshotViews:SnapshotViews, duration:NSTimeInterval, delay:NSTimeInterval, completionBlock:GateAnimationCompletionBlock? = nil) {
        // it removes blinking bug
        UIView.animateWithDuration(initialDelay, animations: { () -> Void in
            snapshotViews.upperSnapshotView.alpha = 1
            snapshotViews.lowerSnapshotView.alpha = 1
            }, completion: { (_) -> Void in
                fromVC.view.transform = CGAffineTransformMakeTranslation(UIScreen.mainScreen().bounds.width, 0)
        })
        
        UIView.animateKeyframesWithDuration(
            duration,
            delay: 0,
            options: UIViewKeyframeAnimationOptions.CalculationModeCubic,
            animations: { () -> Void in
                
                // snapshots
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.35, animations: { () -> Void in
                    snapshotViews.upperSnapshotView.transform = CGAffineTransformMakeTranslation(0, -snapshotViews.upperSnapshotView.frame.height)
                    snapshotViews.upperSnapshotView.alpha     = 0
                    snapshotViews.lowerSnapshotView.transform = CGAffineTransformMakeTranslation(0, snapshotViews.lowerSnapshotView.frame.height)
                    snapshotViews.upperSnapshotView.alpha     = 0
                })
                
                // destination view
                UIView.addKeyframeWithRelativeStartTime(0.55, relativeDuration: 0.35, animations: { () -> Void in
                    toVC.view.alpha = 1
                })
                
                // animated subview
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1, animations: { () -> Void in
                    if self.animatedSourceSubviewSnapshot != nil && self.animatedSubviewDestinationFrame != nil {
                        self.animatedSourceSubviewSnapshot!.transform = CGAffineTransformMakeTranslation(
                            self.animatedSubviewDestinationFrame!.origin.x - self.animatedSourceSubviewSnapshot!.frame.origin.x,
                            self.animatedSubviewDestinationFrame!.origin.y - self.animatedSourceSubviewSnapshot!.frame.origin.y
                        )
                    }
                })
                
            }, completion: { (finished) -> Void in
                completionBlock?()
                return
            }
        )

    }
}