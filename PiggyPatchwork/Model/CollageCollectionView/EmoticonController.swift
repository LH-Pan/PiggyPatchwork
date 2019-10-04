//
//  EmoticonController.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/10/3.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class EmoticonController: NSObject, CollageMatchable {
    
    let title: FunctionOption = .emoticon
    
    var etCellSelectedIndexPath: IndexPath?
    
    let cellEmoticon: [CellEmoticon] = [.funny, .doNotThinkSo, .weirdSmile,
                                        .crazy, .twinkleEyes, .dying,
                                        .lierFace, .cute, .exciting, .cry]
       
    let faceEmoticon: [FaceEmoticon] = [.funny, .doNotThinkSo, .weirdSmile,
                                        .crazy, .twinkleEyes, .dying,
                                        .lierFace, .cute, .exciting, .cry]
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        
        return cellEmoticon.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard
            let emoticonCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EmoticonCollectionViewCell.identifier,
                for: indexPath
            ) as? EmoticonCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        emoticonCell.selectedCollection(inIndexPath: indexPath,
                                        eqaulTo: etCellSelectedIndexPath)
        
        emoticonCell.emoticonImageView.image = UIImage(named: cellEmoticon[indexPath.row].rawValue)
        
        return emoticonCell
    }
}

//extension EmoticonController {
//    
//    func collectionView(
//        _ collectionView: UICollectionView,
//        didSelectItemAt indexPath: IndexPath
//    ) {
//        collectionView.radioCollection(inIndexPath: indexPath,
//                                       eqaulTo: etCellSelectedIndexPath)
//                   
//        etCellSelectedIndexPath = indexPath
//    }
//    
//    func collectionView(
//        _ collectionView: UICollectionView,
//        didDeselectItemAt indexPath: IndexPath
//    ) {
//        
//        etCellSelectedIndexPath = indexPath
//    }
//}
