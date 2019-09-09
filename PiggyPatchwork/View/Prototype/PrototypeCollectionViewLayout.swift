//
//  PrototypeCollectionViewLayout.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/8/28.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class CollageCollectionViewLayout: UICollectionViewFlowLayout {
    
    var itemCount: CGFloat = 0
    
    var selectedIndex: Int = 0
    
    override func prepare() {
        super.prepare()
        
        scrollDirection = .horizontal
        
        if selectedIndex == 2 {
            
            itemSize = CGSize(width: 100/414 * UIScreen.width, height: 40/414 * UIScreen.width)
        } else {
            
            itemSize = CGSize(width: 80/414 * UIScreen.width, height: 80/414 * UIScreen.width)
        }
        
        let inset = (collectionView!.frame.height - itemSize.height) / 2
        
        sectionInset = UIEdgeInsets(top: inset, left: 20, bottom: inset, right: 20)
        
        minimumLineSpacing = UIScreen.width * CGFloat.insetRatio
    }

    override var collectionViewContentSize: CGSize {
        
        if collectionView == nil { return CGSize.zero }
        
        return CGSize(width: (itemSize.width + minimumLineSpacing) * itemCount + minimumLineSpacing,
                      height: collectionView!.bounds.height)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
