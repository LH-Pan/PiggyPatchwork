//
//  PrototypeLayout.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/2.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

protocol Layoutable {
    
    func getFrames(_ size: CGSize) -> [CGRect]
}

struct SingleSquare: Layoutable {
    
    func getFrames(_ size: CGSize) -> [CGRect] {
        
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

    func getFrames(_ size: CGSize) -> [CGRect] {
        
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
    
    func getFrames(_ size: CGSize) -> [CGRect] {
        
        let widthInset: CGFloat = CGFloat.insetRatio * size.width
        
        let heightInset: CGFloat = CGFloat.insetRatio * size.height
        
        let width = size.width - widthInset * 2
        
        let height = (size.height - heightInset * 3) / 2
        
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

struct TripleVertical: Layoutable {
    
    func getFrames(_ size: CGSize) -> [CGRect] {
        
        let widthInset: CGFloat = CGFloat.insetRatio * size.width
        
        let heightInset: CGFloat = CGFloat.insetRatio * size.height
        
        let width = (size.width - widthInset * 4) / 3
        
        let height = size.height - heightInset * 2
        
        let firstCGRect = CGRect(x: widthInset,
                                 y: heightInset,
                                 width: width,
                                 height: height)
        
        let secondCGRect = CGRect(x: width + widthInset * 2,
                                  y: heightInset,
                                  width: width,
                                  height: height)
        
        let thirdCGRect = CGRect(x: width * 2 + widthInset * 3,
                                 y: heightInset,
                                 width: width,
                                 height: height)
        
        return [firstCGRect, secondCGRect, thirdCGRect]
    }
}

struct TripleHorizontal: Layoutable {
    
    func getFrames(_ size: CGSize) -> [CGRect] {
        
        let widthInset: CGFloat = CGFloat.insetRatio * size.width
        
        let heightInset: CGFloat = CGFloat.insetRatio * size.height
        
        let width = size.width - widthInset * 2
        
        let height = (size.height - widthInset * 4) / 3
        
        let firstCGRect = CGRect(x: widthInset,
                                 y: heightInset,
                                 width: width,
                                 height: height)
        
        let secondCGRect = CGRect(x: widthInset,
                                  y: height + heightInset * 2,
                                  width: width,
                                  height: height)
        
        let thirdCGRect = CGRect(x: widthInset,
                                 y: height * 2 + heightInset * 3,
                                 width: width,
                                 height: height)
        
        return [firstCGRect, secondCGRect, thirdCGRect]
    }
}

struct QuadraSquare: Layoutable {
    
    func getFrames(_ size: CGSize) -> [CGRect] {
        
        let widthInset: CGFloat = CGFloat.insetRatio * size.width
        
        let heightInset: CGFloat = CGFloat.insetRatio * size.height
        
        let width = (size.width - widthInset * 3) / 2
        
        let height = (size.height - heightInset * 3) / 2
        
        let firstCGRect = CGRect(x: widthInset,
                                 y: heightInset,
                                 width: width,
                                 height: height)
        
        let secondCGRect = CGRect(x: width + widthInset * 2,
                                  y: heightInset,
                                  width: width,
                                  height: height)
        
        let thirdCGRect = CGRect(x: widthInset,
                                 y: height + heightInset * 2,
                                 width: width,
                                 height: height)
        
        let fourthCGRect = CGRect(x: width + widthInset * 2,
                                  y: height + heightInset * 2,
                                  width: width,
                                  height: height)
        
        return [firstCGRect, secondCGRect, thirdCGRect, fourthCGRect]
    }
}
