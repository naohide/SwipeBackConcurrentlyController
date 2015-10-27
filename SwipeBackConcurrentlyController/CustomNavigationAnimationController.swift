//
//  CustomNavigationAnimationController.swift
//  SwipeBackConcurrentlyController
//
//  Created by naohide_a on 2015/10/27.
//  Copyright © 2015年 keepitreal. All rights reserved.
//

import UIKit

class CustomNavigationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    internal var presenting = true
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toView = toViewController.view
        let fromView = fromViewController.view
        let offScreenRight = CGAffineTransformMakeTranslation(containerView!.frame.width, 0)
        let offScreenLeft = CGAffineTransformMakeTranslation(-containerView!.frame.width, 0)
        let duration = self.transitionDuration(transitionContext)
        
        toView.transform = self.presenting ? offScreenRight : offScreenLeft
        toView.frame = transitionContext.finalFrameForViewController(toViewController)
        fromView.frame = transitionContext.initialFrameForViewController(fromViewController)
        containerView!.addSubview(toView)
        if self.presenting {
            toView.center.x += containerView!.bounds.width
            UIView.animateWithDuration(duration, animations: {
                fromView.transform = offScreenLeft
                toView.transform = CGAffineTransformIdentity
                }, completion: {
                    finished in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        } else {
            toView.center.x -= containerView!.bounds.width
            
            UIView.animateWithDuration(duration, animations: {
                fromView.transform = offScreenRight
                fromViewController.navigationItem.titleView!.transform = offScreenRight
                fromViewController.navigationItem.leftBarButtonItem?.customView!.transform = offScreenRight
                fromViewController.navigationItem.rightBarButtonItem?.customView!.transform = offScreenRight
                toView.transform = CGAffineTransformIdentity
                }, completion: {
                    finished in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        }
    }
    
    // return how many seconds the transiton animation will take
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.35
    }
}