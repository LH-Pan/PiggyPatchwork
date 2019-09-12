//
//  File.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/11.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    
    @IBOutlet weak var canvasImageView: UIImageView!
    
    @IBOutlet weak var backToPreviewBtn: UIButton! {
        
        didSet {
            backToPreviewBtn.setTitleColor(.hexStringToUIColor(hex: CustomColorCode.OrchidPink),
                                     for: .normal)
            backToPreviewBtn.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var editCompleteBtn: UIButton! {
        
        didSet {
            editCompleteBtn.setTitleColor(.hexStringToUIColor(hex: CustomColorCode.OrchidPink),
                                     for: .normal)
            editCompleteBtn.layer.cornerRadius = 10
        }
    }
    
    var storageImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canvasImageView.image = storageImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.delegate = self
        
        Gradient.shared.doubleColor(at: view,
                                    firstColor: CustomColorCode.PigletPink,
                                    secondColor: CustomColorCode.OrchidPink)
    }
    
    
    @IBAction func backToPreView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editComplete(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CanvasViewController: UINavigationControllerDelegate {
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .pop {
            return PopTransition()
        } else {
            return nil
        }
    }
}
