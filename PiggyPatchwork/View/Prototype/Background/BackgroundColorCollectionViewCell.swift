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
        
        layer.cornerRadius = frame.size.height / 2
        
        makeCircleShadow()
        
    }
}
