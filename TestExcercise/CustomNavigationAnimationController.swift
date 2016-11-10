//
//  CustomNavigationAnimationController.swift
//  TestExcercise
//
//  Created by Fatima mhowwala on 08/11/16.
//  Copyright © 2016 ThoughtBeans. All rights reserved.
//

import UIKit

class CustomNavigationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  var reverse: Bool = false
  let duration = 1.0
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 1.5
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    let toViewController = transitionContext.viewController(forKey: .to)!
    let fromViewController = transitionContext.viewController(forKey: .from)!
    let toView = toViewController.view
    let fromView = fromViewController.view
    let direction: CGFloat = reverse ? -1.0 : 1.0
    let const: CGFloat = -0.005
    
    toView?.layer.anchorPoint = CGPoint(x: direction == 1.0 ? 0.0 : 1.0, y: 0.5)
    fromView?.layer.anchorPoint = CGPoint(x: direction == 1.0 ? 1 : 0, y: 0.5)

    var viewFromTransform: CATransform3D = CATransform3DMakeRotation(direction * CGFloat(M_PI_2), 0.0, 1.0, 0.0)
    var viewToTransform: CATransform3D = CATransform3DMakeRotation(-direction * CGFloat(M_PI_2), 0.0, 1.0, 0.0)
    viewFromTransform.m34 = const
    viewToTransform.m34 = const
    
    containerView.transform = CGAffineTransform(translationX: direction * containerView.frame.size.width / 2.0, y: 0)
    toView?.layer.transform = viewToTransform
    containerView.addSubview(toView!)
    
    UIView.animate(withDuration: duration, animations: {
      containerView.transform = CGAffineTransform(translationX: -direction * containerView.frame.size.width / 2.0, y: 0)
      fromView?.layer.transform = viewFromTransform
      toView?.layer.transform = CATransform3DIdentity
      }, completion: {
        finished in
        containerView.transform = CGAffineTransform.identity
        fromView?.layer.transform = CATransform3DIdentity
        toView?.layer.transform = CATransform3DIdentity
        fromView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        toView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        if transitionContext.transitionWasCancelled {
          toView?.removeFromSuperview()
        } else {
          fromView?.removeFromSuperview()
        }
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
  
}
