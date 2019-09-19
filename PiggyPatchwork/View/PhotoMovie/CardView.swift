//
//  CardView.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/19.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

@IBDesignable

class CardView: UIView {
    
    override var backgroundColor: UIColor? {
        
        didSet {
            if backgroundColor?.cgColor.alpha == 0 {
                backgroundColor = oldValue
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 2
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    
    @IBInspectable var shadowOffsetHeight: Int = 3
    
    @IBInspectable var shadowColor: UIColor? = .black
    
    @IBInspectable var shadowOpacity: Float = 0.5
    
    override func layoutSubviews() {
        
        layer.cornerRadius = cornerRadius
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        
        layer.shadowColor = shadowColor?.cgColor
        
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        
        layer.shadowOpacity = shadowOpacity
        
        layer.shadowPath = shadowPath.cgPath
    }
}
