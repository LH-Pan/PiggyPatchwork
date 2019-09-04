//
//  PrototypeLayout.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/2.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import Foundation
import UIKit

protocol Layoutable {
    
    func operation(_ size: CGSize) -> [CGRect]
}

class PrototypeLayout {
    
    static let spaceRatio: CGFloat = 20 / 373
    
    static let insetRatio: CGFloat = spaceRatio / 414 * UIScreen.width
    
    static func singleSquareLayout(size: CGSize) -> CGRect {

        let sideLength = size.width - insetRatio * size.width * 2

        let firstCGRect = CGRect(x: insetRatio * size.width,
                                 y: insetRatio * size.height,
                                 width: sideLength,
                                 height: sideLength)

        return firstCGRect
    }
    
    static func doubleVerticalLayout(size: CGSize) -> (CGRect, CGRect) {

        let width = (size.width - insetRatio * size.width * 3) / 2

        let height = size.height - insetRatio * size.height * 2

        let firstCGRect = CGRect(x: insetRatio * size.width,
                                 y: insetRatio * size.height,
                                 width: width,
                                 height: height)
        
        let secondCGRect = CGRect(x: width + insetRatio * size.width * 2,
                                  y: insetRatio * size.height,
                                  width: width,
                                  height: height)
        
        return (firstCGRect, secondCGRect)
    }
    
    static func doubleHorizontalLayout(size: CGSize) -> (CGRect, CGRect) {
        
        let width = size.height - insetRatio * size.width * 2
        
        let height = (size.width - insetRatio * size.height * 3) / 2
        
        let firstCGRect = CGRect(x: insetRatio * size.width,
                                 y: insetRatio * size.height,
                                 width: width,
                                 height: height)
        
        let secondCGRect = CGRect(x: insetRatio * size.width,
                                  y: height + insetRatio * size.height * 2,
                                  width: width,
                                  height: height)
        
        return (firstCGRect, secondCGRect)
    }
}

struct SingleSquare: Layoutable {
    
    func operation(_ size: CGSize) -> [CGRect] {
        
        let widthInset: CGFloat = CGFloat.insetRatio * size.width
        
        let sideLength = size.width - widthInset * 2
        
        let firstCGRect = CGRect(x: widthInset,
                                 y: widthInset,
                                 width: sideLength,
                                 height: sideLength)
        
        return [firstCGRect]
    }
}

struct DoubleVerticle: Layoutable {

    func operation(_ size: CGSize) -> [CGRect] {
        
        let widthInset: CGFloat = CGFloat.insetRatio * size.width
        
        let heightInset: CGFloat = CGFloat.insetRatio * size.height
        
        let width = (size.width - widthInset * 3) / 2
        
        let height = size.height - heightInset * 2
        
        let firstCGRect = CGRect(x: widthInset,
                                 y: heightInset,
                                 width: width,
                                 height: height)
        
        let secondCGRect = CGRect(x: width + widthInset * 2,
                                  y: heightInset,
                                  width: width,
                                  height: height)
        
        return [firstCGRect, secondCGRect]
    }
}

struct DoubleHorizontal: Layoutable {
    
    func operation(_ size: CGSize) -> [CGRect] {
        
        let widthInset: CGFloat = CGFloat.insetRatio * size.width
        
        let heightInset: CGFloat = CGFloat.insetRatio * size.height
        
        let width = size.height - widthInset * 2
        
        let height = (size.width - heightInset * 3) / 2
        
        let firstCGRect = CGRect(x: widthInset,
                                 y: heightInset,
                                 width: width,
                                 height: height)
        
        let secondCGRect = CGRect(x: widthInset,
                                  y: height + heightInset * 2,
                                  width: width,
                                  height: height)
        
        return [firstCGRect, secondCGRect]
    }
}
