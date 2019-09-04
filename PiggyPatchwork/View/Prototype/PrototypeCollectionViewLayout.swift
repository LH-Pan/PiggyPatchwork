//
//  PrototypeCollectionViewLayout.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/8/28.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class PrototypeCollectionViewLayout: UICollectionViewFlowLayout {
    
    var itemCount: CGFloat = 0
    
    override func prepare() {
        super.prepare()
        
        scrollDirection = .horizontal
        
        itemSize = CGSize(width: 80/414 * UIScreen.width, height: 80/414 * UIScreen.width)
        
        let inset = (collectionView!.frame.height - itemSize.height) / 2
        
        sectionInset = UIEdgeInsets(top: inset, left: 20, bottom: inset, right: 0)
    }

    override var collectionViewContentSize: CGSize {
        if collectionView == nil { return CGSize.zero }
        
        return CGSize(width: (itemSize.width + itemSize.width * CGFloat.insetRatio) * itemCount,
                      height: collectionView!.bounds.height)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
