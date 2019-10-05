//
//  PushTransition.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/11.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class PushTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        
        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? CollagePreviewViewController,
            let toVC = transitionContext.viewController(forKey: .to) as? CanvasViewController
        else { return }
        
        let container = transitionContext.containerView
        
        let snapView = fromVC.previewImageView.snapshotView(afterScreenUpdates: true)
        
        snapView?.frame = container.convert(fromVC.previewImageView.frame, from: fromVC.previewImageView)
        
        toVC.canvasImageView.isHidden = true
        
        container.addSubview(toVC.view)
        container.addSubview(snapView ?? UIView())
        
        UIView.animate(withDuration: 0.5, animations: {
            
            snapView?.bounds = toVC.canvasImageView.frame
        }, completion: { _ in
            
            snapView?.removeFromSuperview()
            
            toVC.canvasImageView.isHidden = false
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
