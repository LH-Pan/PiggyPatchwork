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
    case exclamation_mark
    case error_mark
    case tick_mark
    case next_icon
    case palette
    case thickness
    case Icons_24px_Close
}

// swiftlint:enable identifier_name

extension UIImage {
    
    static func asset(_ asset: ImageAsset) -> UIImage? {
        
        return UIImage(named: asset.rawValue)
    }
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension UIImage {
    
    subscript (originX: Int, originY: Int) -> UIColor? {
        
        if originX < 0 || originX > Int(size.width) || originY < 0 || originY > Int(size.height) {
            
            return nil
        }
        
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
