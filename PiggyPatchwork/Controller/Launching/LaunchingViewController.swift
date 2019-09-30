//
//  LaunchingViewController.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/27.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class LaunchingViewController: UIViewController {
    
    @IBOutlet weak var pointImageView: UIImageView! {
        
        didSet {
            
            pointImageView.alpha = 0
        }
    }
    
    @IBOutlet weak var transitionView: UIView!
    
    var diffusionTransition: PiggyDiffusionTransition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diffusionTransition = PiggyDiffusionTransition(animatedView: transitionView)
        
        let transform = CGAffineTransform(scaleX: 0.99, y: 0.99)

        transitionView.transform = transform
        
        UIView.animate(withDuration: 0.3,
                       animations: {
            
            self.pointImageView.alpha = 1
        }, completion: {(_) in
            
            UIView.animate(withDuration: 1,
                           animations: {
                            
                            self.transitionView.transform = CGAffineTransform.identity
                            
                            self.animate(view: self.pointImageView,
                                         fromPoint: self.pointImageView.center,
                                         toPoint: self.transitionView.center)
            }, completion: {(_) in
                
                 if let lobbyVC = UIStoryboard.lobby.instantiateInitialViewController() {

                     lobbyVC.modalPresentationStyle = .custom

                     lobbyVC.transitioningDelegate = self.diffusionTransition

                     self.present(lobbyVC, animated: true, completion: nil)
                 }
            })
        })
    }
    
    func animate(view: UIView, fromPoint start: CGPoint, toPoint end: CGPoint) {
        
        // The animation
        let animation = CAKeyframeAnimation(keyPath: "position")

        // Animation's path
        let path = UIBezierPath()

        // Move the "cursor" to the start
        path.move(to: start)

        // Calculate the control points
        let firstControlPoint = CGPoint(x: start.x + end.x, y: start.y)
        let secondControlPoint = CGPoint(x: end.x, y: end.y - start.y)

        // Draw a curve towards the end, using control points
        path.addCurve(to: end,
                      controlPoint1: firstControlPoint,
                      controlPoint2: secondControlPoint)

        // Use this path as the animation's path (casted to CGPath)
        animation.path = path.cgPath

        // The other animations properties
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.duration = 0.6
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)

        // Apply it
        view.layer.add(animation, forKey: "trash")
    }
}
