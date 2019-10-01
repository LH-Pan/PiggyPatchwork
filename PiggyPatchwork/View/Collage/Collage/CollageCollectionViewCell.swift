//
//  CollageCollectionViewCell.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/8/28.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class CollageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collageCellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        makeCellSquareShadow()
    }
}
