//
//  PopTransition.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/11.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class PopTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        
        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? CanvasViewController,
            let toVC = transitionContext.viewController(forKey: .to) as? CollagePreviewViewController
        else { return }
        
        let container = transitionContext.containerView
        
        let snapView = fromVC.canvasImageView.snapshotView(afterScreenUpdates: false)
        
        snapView?.bounds = fromVC.canvasImageView.frame
        
        toVC.previewImageView.isHidden = true
        
        container.addSubview(toVC.view)
        container.addSubview(snapView ?? UIView())
        
        UIView.animate(withDuration: 0.5, animations: {
            
            snapView?.frame = container.convert(toVC.previewImageView.frame,
                                                 from: toVC.previewImageView)
        }, completion: { _ in
            
            snapView?.removeFromSuperview()
            
            toVC.previewImageView.isHidden = false
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
