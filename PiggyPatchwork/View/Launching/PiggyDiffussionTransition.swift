//
//  DiffusionTransition.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/29.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class PiggyDiffusionTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    weak var animatedView: UIView?
    
    var startBackgroundColor: UIColor?
    
    var transitionDuration: TimeInterval = 0.5
    
    private override init() { super.init() }
    
    convenience init(animatedView: UIView) {
        self.init()
        self.animatedView = animatedView
    }
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        
        return transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // get frame and backgroundColor
        var startFrame = CGRect.zero
        
        if animatedView != nil {
            
            startFrame = animatedView?.frame ?? CGRect.zero
            
            startBackgroundColor = animatedView?.backgroundColor
        }
        
        // init animated view for transition
        let animatedViewForTransition = UIView(frame: startFrame)
        
        animatedViewForTransition.clipsToBounds = true
        
        animatedViewForTransition.layer.cornerRadius = animatedViewForTransition.frame.height / 2.0
        
        animatedViewForTransition.backgroundColor = self.startBackgroundColor
        
        // add animated view on transitionContext's containerView
        transitionContext.containerView.addSubview(animatedViewForTransition)
        
        // set presentedController
        let presentedController: UIViewController
        
        presentedController = transitionContext.viewController(forKey: .to) ?? UIViewController()
        
        presentedController.view.layer.opacity = 0
        
        presentedController.view.frame = transitionContext.containerView.bounds
        
        transitionContext.containerView.addSubview(presentedController.view)
        
        let size = max(transitionContext.containerView.frame.height,
                       transitionContext.containerView.frame.width) * 1.2
        
        let scaleFactor = size / animatedViewForTransition.frame.height
        
        let finalTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        
            UIView.transition(with: animatedViewForTransition,
                              duration: self.transitionDuration(using: transitionContext) * 0.7,
                              options: [],
                              animations: {
                                animatedViewForTransition.transform = finalTransform
                                animatedViewForTransition.center = transitionContext.containerView.center
                                animatedViewForTransition.backgroundColor = CustomColor.OrchidPink
            }, completion: nil)
            
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext) * 0.4,
                           delay: self.transitionDuration(using: transitionContext) * 0.6,
                           animations: {
                            presentedController.view.layer.opacity = 1
            }, completion: { (_) in
                animatedViewForTransition.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
    }
}

extension PiggyDiffusionTransition: UIViewControllerTransitioningDelegate {
    
    open func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        
        return self
    }
}
