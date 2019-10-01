//
//  testStruct.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/17.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class CollageController: NSObject, UICollectionViewDataSource {
    
    var ptCellSelectedIndexPath: IndexPath?
    
    let prototypeLayout: [Layoutable] = [DoubleVerticle(), DoubleHorizontal()]
    
    func memorizeCollection(at cell: UICollectionViewCell,
                            in currentIndexPath: IndexPath,
                            eqaulTo lastIndexPath: IndexPath?) {
        
        if currentIndexPath == lastIndexPath {
            
            cell.layer.borderWidth = 2
            
            cell.layer.borderColor = UIColor.brown.cgColor
        } else {
            
            cell.layer.borderWidth = 0
        }
    }
    
    func radioCollection(at collectionView: UICollectionView,
                         in currentIndexPath: IndexPath,
                         eqaulTo lastIndexPath: IndexPath?) {
        
        if currentIndexPath != lastIndexPath {
            if let lastSelectedIndexPath = lastIndexPath {
                if let cell = collectionView.cellForItem(at: lastSelectedIndexPath) {
                    cell.layer.borderWidth = 0
                }
            }
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        
        return prototypeLayout.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard
            let prototypeCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CollageCollectionViewCell.identifier,
                for: indexPath
                ) as? CollageCollectionViewCell
            else {
                return UICollectionViewCell()
        }
        
        memorizeCollection(at: prototypeCell,
                           in: indexPath,
                           eqaulTo: ptCellSelectedIndexPath)
        
        let frames = self.prototypeLayout[indexPath.row].getFrames(prototypeCell.frame.size)
        
        for layout in frames {
            
            let subView = UIView()
            
            subView.frame = layout
            
            subView.backgroundColor = CustomColor.SilverGray
            
            prototypeCell.addSubview(subView)
            
        }
        
        return prototypeCell
    }
}

extension CollageController: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        
        radioCollection(at: collectionView,
                        in: indexPath,
                        eqaulTo: ptCellSelectedIndexPath)
        
        ptCellSelectedIndexPath = indexPath
        
//        let frames = self.prototypeLayout[indexPath.row].getFrames(self.collageView.frame.size)
//
//        for subView in collageView.subviews {
//
//            if subView == personFaceImage {
//
//                subView.frame = .zero
//            } else {
//
//                subView.removeFromSuperview()
//            }
//        }
//
//        UIView.animate(withDuration: 0.2, animations: {
//
//            for layout in frames {
//
//                let imageView = UIImageView()
//
//                imageView.frame = layout
//
//                self.setupImageView(at: self.collageView, add: imageView)
//            }
//        })
    }
}
