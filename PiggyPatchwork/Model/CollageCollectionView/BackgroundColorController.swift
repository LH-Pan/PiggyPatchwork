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
    
    var selectedIndexPath: IndexPath?
    
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
            let backgroundCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BackgroundColorCollectionViewCell.identifier,
                for: indexPath
            ) as? BackgroundColorCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        backgroundCell.selectedCollection(inIndexPath: indexPath,
                                          equalTo: selectedIndexPath)
        
        let backgroundColorCode = colorCode[indexPath.row].rawValue
        
        backgroundCell.backgroundColor = UIColor.hexStringToUIColor(hex: backgroundColorCode)
        
        return backgroundCell
    }
}

extension BackgroundColorController {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        
        collectionView.radioCollection(inIndexPath: indexPath,
                                       notEqualTo: selectedIndexPath)
        
        selectedIndexPath = indexPath
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        
        selectedIndexPath = indexPath
    }
}
