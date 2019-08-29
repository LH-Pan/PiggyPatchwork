//
//  PrototypeCollectionViewLayout.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/8/28.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class PrototypeCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        scrollDirection = .horizontal
        
        let inset = (collectionView!.frame.height - itemSize.height) / 2
        
        sectionInset = UIEdgeInsets(top: inset, left: 20, bottom: inset, right: 0)
    }
}
