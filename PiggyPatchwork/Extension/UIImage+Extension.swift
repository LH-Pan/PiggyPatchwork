//
//  UIImage+Extension.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/8/28.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

enum ImageAsset: String {
    
    // swiftlint:disable identifier_name
    case Double_horizontal_retangel_60x60
    case Double_vertical_retangel_60x60
    
    // swiftlint:enable identifier_name
}

extension UIImage {
    
    static func asset(_ asset: ImageAsset) -> UIImage? {
        
        return UIImage(named: asset.rawValue)
    }
}
