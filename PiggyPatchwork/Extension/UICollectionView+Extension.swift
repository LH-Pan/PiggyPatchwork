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
    
    func makeCircleShadow() {
    
        self.layer.shadowColor = UIColor.black.cgColor
        
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        self.layer.shadowRadius = 5
        
        self.layer.shadowOpacity = 0.6
        
        self.layer.masksToBounds = false
        
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                             cornerRadius: self.contentView.layer.bounds.width / 2 ).cgPath
    }
    
    func makeSquareShadow() {
        
        self.layer.shadowColor = UIColor.black.cgColor
        
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        self.layer.shadowRadius = 5
        
        self.layer.shadowOpacity = 0.6
        
        self.layer.masksToBounds = false
        
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                             cornerRadius: 0 ).cgPath
    }
}
