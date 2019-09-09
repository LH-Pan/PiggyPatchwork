//
//  PreviewViewController.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/9.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var previewView: UIView! {
        
        didSet {
            previewView.makeViewSquareShadow()
        }
    }
    
    @IBOutlet weak var previewImageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Gradient.shared.addGradientLayer(at: view,
                                         firstColor: CustomColorCode.PigletPink,
                                         secondColor: CustomColorCode.OrchidPink)
    }
    
    @IBAction func backToCollage(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
