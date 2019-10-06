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
    
    case Icons_24px_Add
    
    case Icons_24px_GreenAdd
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
            
            newSize = CGSize(width: size.width * heightRatio,
                             height: size.height * heightRatio)
            
        } else {
            
            newSize = CGSize(width: size.width * widthRatio,
                             height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0,
                          y: 0,
                          width: newSize.width,
                          height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        
        self.draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func fixOrientation() -> UIImage {
        
        if self.imageOrientation == UIImage.Orientation.up {
            
            return self
        }
        
        var transform = CGAffineTransform.identity
        
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
        case .up, .upMirrored:
            break
        default: break
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default: break
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx = CGContext(
            data: nil,
            width: Int(self.size.width),
            height: Int(self.size.height),
            bitsPerComponent: self.cgImage!.bitsPerComponent,
            bytesPerRow: 0,
            space: self.cgImage!.colorSpace!,
            bitmapInfo: UInt32(self.cgImage!.bitmapInfo.rawValue)
        )
        
        ctx?.concatenate(transform)
        
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        }
        
        // And now we just create a new UIImage from the drawing context
        let cgImg = ctx?.makeImage()
        
        let img = UIImage(cgImage: cgImg!)
        
        return img
    }
}

