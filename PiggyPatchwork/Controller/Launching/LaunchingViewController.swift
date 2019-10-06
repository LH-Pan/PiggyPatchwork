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

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diffusionTransition = PiggyDiffusionTransition(animatedView: transitionView)
        
        UIView.animate(withDuration: 0.3,
                       animations: {
            
                        self.pointImageView.alpha = 1
                        
        }, completion: { [weak self] (_) in
                        
            self?.animate(view: self?.pointImageView ?? UIImageView(),
                          fromPoint: self?.pointImageView?.center ?? CGPoint.zero,
                          toPoint: self?.transitionView?.center ?? CGPoint.zero)
        })
    }
    
    // MARK: - Launching Animation
    func animate(view: UIView, fromPoint start: CGPoint, toPoint end: CGPoint) {
        
        let animation = CAKeyframeAnimation(keyPath: "position")
    
        animation.delegate = self

        let path = UIBezierPath()

        path.move(to: start)

        let firstControlPoint = CGPoint(x: start.x + end.x, y: start.y)
        
        let secondControlPoint = CGPoint(x: end.x, y: end.y - start.y)

        path.addCurve(to: end,
                      controlPoint1: firstControlPoint,
                      controlPoint2: secondControlPoint)

        animation.path = path.cgPath

        animation.fillMode = CAMediaTimingFillMode.forwards
        
        animation.isRemovedOnCompletion = false
        
        animation.duration = 0.6
        
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)

        view.layer.add(animation, forKey: nil)
    }
    
    // MARK: - Transition Animation
    func goToLobbyTransition() {
        
        if let lobbyVC = UIStoryboard.lobby.instantiateInitialViewController() {

            lobbyVC.modalPresentationStyle = .custom

            lobbyVC.transitioningDelegate = self.diffusionTransition

            self.present(lobbyVC, animated: true, completion: nil)
        }
    }
}
    // 判斷 Launching Animation 結束後才進行 Transition Animation
extension LaunchingViewController: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        if flag {
            
            self.goToLobbyTransition()
        }
    }
}
