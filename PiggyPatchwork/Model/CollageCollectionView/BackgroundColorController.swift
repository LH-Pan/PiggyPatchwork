//
//  BackgroundColorController.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/10/3.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class BackgroundColorController: NSObject, CollageMatchable {
    
    let title: FunctionOption = .background
    
    var bgCellSelectedIndexPath: IndexPath?
    
    let colorCode: [ColorCode] = [.white, .petalPink, .waterMelonRed, .roseRed,
                                         .carrotOrange, .sunOrange, .pineappleYellow,
                                         .tigerYellow, .chartreuseGreen, .olivineGreen,
                                         .zucchiniGreen, .babyBlue, .clearSkyBlue,
                                         .prussianBlue, .lilacSkyPurple, .vividPurple,
                                         .amethystPurple, .ashGray, .stoneGray, .black]
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        
        return colorCode.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard
            let bakcgroundCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BackgroundColorCollectionViewCell.identifier,
                for: indexPath
            ) as? BackgroundColorCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        bakcgroundCell.selectedCollection(inIndexPath: indexPath,
                                          equalTo: bgCellSelectedIndexPath)
        
        let backgroundColorCode = colorCode[indexPath.row].rawValue
        
        bakcgroundCell.backgroundColor = UIColor.hexStringToUIColor(hex: backgroundColorCode)
        
        return bakcgroundCell
    }
}

//extension BackgroundColorController {
//    
//    func collectionView(
//        _ collectionView: UICollectionView,
//        didSelectItemAt indexPath: IndexPath
//    ) {
//        
//        collectionView.radioCollection(inIndexPath: indexPath,
//                                       eqaulTo: bgCellSelectedIndexPath)
//        
//        bgCellSelectedIndexPath = indexPath
//    }
//    
//    func collectionView(
//        _ collectionView: UICollectionView,
//        didDeselectItemAt indexPath: IndexPath
//    ) {
//        
//        bgCellSelectedIndexPath = indexPath
//    }
//}
