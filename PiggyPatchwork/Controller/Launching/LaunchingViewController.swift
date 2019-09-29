//
//  LaunchingViewController.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/27.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class LaunchingViewController: UIViewController {
    
    @IBOutlet weak var transitionView: UIView!
    
    var diffusionTransition: PiggyDiffusionTransition!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diffusionTransition = PiggyDiffusionTransition(animatedView: transitionView)
        
//        if let lobbyVC = UIStoryboard.lobby.instantiateInitialViewController() {
//
//            lobbyVC.modalPresentationStyle = .custom
//
//            lobbyVC.transitioningDelegate = self.diffusionTransition
//
//            present(lobbyVC, animated: true, completion: nil)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let lobbyVC = UIStoryboard.lobby.instantiateInitialViewController() {

            lobbyVC.modalPresentationStyle = .custom

            lobbyVC.transitioningDelegate = self.diffusionTransition

            self.present(lobbyVC, animated: true, completion: nil)
        }
    }
}
