//
//  PrototypeCollectionViewCell.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/8/28.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class PrototypeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var prototypeCellView: UIView!
    
    let firstView = UIView()
    
    let secondView = UIView()
    
    var doubleView: (CGRect, CGRect) = (.zero, .zero) {
        
        didSet {
            (firstView.frame, secondView.frame) = doubleView
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupSubView(with: prototypeCellView, add: firstView)
        
        setupSubView(with: prototypeCellView, add: secondView)
    }
    
    private func setupSubView(with superView: UIView,
                              add subView: UIView) {
        
        superView.addSubview(subView)
        
        subView.backgroundColor = UIColor.hexStringToUIColor(hex: CustomColorCode.SilverGray)
        
    }
}
