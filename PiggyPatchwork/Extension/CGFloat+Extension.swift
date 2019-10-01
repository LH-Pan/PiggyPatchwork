//
//  CGFloat+Extension.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/4.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

extension CGFloat {
    
    // 373 為 collage view 在 iPhone 11 pro 上的邊長
    
    // 建立一個比例
    static let spaceRatio: CGFloat = 20 / 373
    
    // 讓比例可以隨著不同大小的裝置更動
    static let insetRatio: CGFloat = CGFloat.spaceRatio * UIScreen.screenWidthRatio
    
}
