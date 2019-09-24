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
    
    let gradientLayer = CAGradientLayer()
    
    func doubleColor(at view: UIView,
                     firstColorCode: String,
                     secondColorCode: String ) {
        
        gradientLayer.frame = view.bounds
        
        gradientLayer.colors = [UIColor.hexStringToUIColor(hex: firstColorCode).cgColor,
                                UIColor.hexStringToUIColor(hex: secondColorCode).cgColor
        ]
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
