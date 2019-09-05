//
//  BackgroundColorCollectionViewCell.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/2.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class BackgroundColorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutIfNeeded()

        self.layer.shadowColor = UIColor.black.cgColor
        
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        self.layer.shadowRadius = 5
        
        self.layer.shadowOpacity = 0.6
        
        self.layer.masksToBounds = false
        
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                             cornerRadius: self.contentView.layer.bounds.width / 2 ).cgPath
        
//        self.layer.backgroundColor = UIColor.clear.cgColor
    }
}
