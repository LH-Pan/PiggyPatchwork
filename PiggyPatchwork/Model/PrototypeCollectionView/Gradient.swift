//
//  Gradient.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/9.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class Gradient {
    
    static let gradientLayer = CAGradientLayer()
    
    static func doubleColor(at view: UIView,
                            firstColorCode: UIColor,
                            secondColorCode: UIColor
    ) {
        
        gradientLayer.frame = view.bounds
        
        gradientLayer.colors = [firstColorCode.cgColor,
                                secondColorCode.cgColor
        ]
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
