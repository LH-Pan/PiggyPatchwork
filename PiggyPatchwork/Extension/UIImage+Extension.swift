//
//  UIImage+Extension.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/8/28.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

//enum ImageAsset: String {
//    

//}
//
//extension UIImage {
//    
//    static func asset(_ asset: ImageAsset) -> UIImage? {
//        
//        return UIImage(named: asset.rawValue)
//    }
//}

extension UIImage {
    
    subscript (originX: Int, originY: Int) -> UIColor? {
        
        if originX < 0 || originX > Int(size.width) || originY < 0 || originY > Int(size.height) {
            
            return nil
        }
        print (5, self.size)
        print (6, "color:", originX, originY)
        let provider = self.cgImage!.dataProvider
        let providerData = provider!.data
        let data = CFDataGetBytePtr(providerData)
        
        let numberOfComponents = 4
        let pixelData = ((Int(size.width) * originY) + originX) * numberOfComponents
        
        let red = CGFloat(data![pixelData]) / 255.0
        let green = CGFloat(data![pixelData + 1]) / 255.0
        let blue = CGFloat(data![pixelData + 2]) / 255.0
        let alpha = CGFloat(data![pixelData + 3]) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
