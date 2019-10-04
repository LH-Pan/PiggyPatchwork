//
//  testStruct.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/17.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class CollageController: NSObject, CollageMatchable {
    
    let title: FunctionOption = .prototypeFrame
    
    var ptCellSelectedIndexPath: IndexPath?
    
    let prototypeLayout: [Layoutable] = [DoubleVertical(), DoubleHorizontal(), LeftVerticalWithDoubleSquare(),
                                         RightVerticalWithDoubleSquare(), HorizontalAboveWithDoubleSquare(),
                                         HorizontalBelowWithDoubleSquare(), TripleVertical(),
                                         TripleHorizontal(), QuadraSquare(), TripleLeftWithDoubleRight(),
                                         DoubleLeftWithTripleRight(), DoubleAboveWithTripleBelow(),
                                         TripleAboveWithDoubleBelow()]
    
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
        
        prototypeCell.selectedCollection(inIndexPath: indexPath,
                                         equalTo: ptCellSelectedIndexPath)
        
        if prototypeCell.collageCellView.subviews != [] {

            for subview in prototypeCell.collageCellView.subviews {

                subview.removeFromSuperview()
            }
        }
        
        let frames = prototypeLayout[indexPath.row].getFrames(prototypeCell.frame.size)
        
        for layout in frames {
            
            let subView = UIView()
            
            subView.frame = layout
            
            subView.backgroundColor = CustomColor.SilverGray
            
            prototypeCell.collageCellView.addSubview(subView)
            
        }
        
        return prototypeCell
    }
}

//extension CollageController {
//
//    func collectionView(
//        _ collectionView: UICollectionView,
//        didSelectItemAt indexPath: IndexPath
//    ) {
//
//        collectionView.radioCollection(inIndexPath: indexPath,
//                                       eqaulTo: ptCellSelectedIndexPath)
//
//        ptCellSelectedIndexPath = indexPath
//    }
//
//    func collectionView(
//        _ collectionView: UICollectionView,
//        didDeselectItemAt indexPath: IndexPath
//    ) {
//
//        ptCellSelectedIndexPath = indexPath
//    }
//}
