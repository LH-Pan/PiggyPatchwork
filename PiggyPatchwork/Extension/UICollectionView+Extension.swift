//
//  UICollectionView+Extension.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/8/28.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func custom_registerCellWithNib(identifier: String, bundle: Bundle?) {
        
        let nib = UINib(nibName: identifier, bundle: bundle)
        
        register(nib, forCellWithReuseIdentifier: identifier)
    }
}

extension UICollectionViewCell {
    
    static var identifier: String {
        
        return String(describing: self)
    }
    
    func shadowInfo() {
        
        layer.shadowColor = UIColor.black.cgColor
        
        layer.shadowOffset = CGSize(width: 0, height: 5)
        
        layer.shadowRadius = 5
        
        layer.shadowOpacity = 0.6
        
        layer.masksToBounds = false
    }
    
    func makeCircleShadow() {
    
        shadowInfo()
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: contentView.layer.bounds.width / 2 ).cgPath
    }
    
    func makeSquareShadow() {
        
        shadowInfo()
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: 0 ).cgPath
    }
    
    func makeOvalShadow() {
        
        shadowInfo()
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: 20).cgPath
    }
}
