//
//  UIView+Extension.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/8/30.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

extension UIView {
    
    func takeSnapshot() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
}
