//
//  File.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/11.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

protocol ImageProviderDelegate: AnyObject {
    
    func manager(_ viewController: CanvasViewController, didGet image: UIImage?)
}

class CanvasViewController: UIViewController {
    
    @IBOutlet weak var canvasImageView: UIImageView!
    
    @IBOutlet weak var canvasView: UIView!
    
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
    
    weak var delegate: ImageProviderDelegate?
    
    let canvas = Canvas()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canvasImageView.image = storageImage
        
        canvas.backgroundColor = .clear
        
        canvas.frame = canvasImageView.frame
        
        canvasImageView.addSubview(canvas)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.delegate = self
        
        Gradient.shared.doubleColor(at: view,
                                    firstColor: CustomColorCode.PigletPink,
                                    secondColor: CustomColorCode.OrchidPink)
    }

    @IBAction func cancelEdit(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editComplete(_ sender: Any) {
        
        storageImage = canvasView.takeSnapshot()
        
        delegate?.manager(self, didGet: storageImage)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func undo(_ sender: Any) {
        
        canvas.undo()
    }
    
    @IBAction func clearAll(_ sender: Any) {
        
        canvas.clear()
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
