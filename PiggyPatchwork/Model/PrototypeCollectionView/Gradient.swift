//
//  Gradient.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/9.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class Gradient {
    
    static let shared = Gradient()
    
    func addGradientLayer(at view: UIView,
                          firstColor: String,
                          secondColor: String ) {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = view.bounds
        
        gradientLayer.colors = [UIColor.hexStringToUIColor(hex: firstColor).cgColor,
                                UIColor.hexStringToUIColor(hex: secondColor).cgColor
        ]
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
