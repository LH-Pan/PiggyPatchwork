//
//  PrototypeLayout.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/2.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import Foundation
import UIKit

class PrototypeLayout {
    
    static var inset: CGFloat = 20 / 414 * UIScreen.width
    
    static func singleSquareLayout(size: CGSize) -> CGRect {

        let sideLength = size.width - inset * 2

        let firstCGRect = CGRect(x: inset,
                             y: inset,
                             width: sideLength,
                             height: sideLength)

        return firstCGRect
    }
    
    static func doubleVerticalLayout(size: CGSize) -> (CGRect, CGRect) {

        let width = (size.width - inset * 3) / 2

        let height = size.height - inset * 2

        let firstCGRect = CGRect(x: inset,
                                 y: inset,
                                 width: width,
                                 height: height)
        
        let secondCGRect = CGRect(x: width + inset * 2,
                                  y: inset,
                                  width: width,
                                  height: height)
        
        return (firstCGRect, secondCGRect)
    }
    
    static func doubleHorizontalLayout(size: CGSize) -> (CGRect, CGRect) {
        
        let width = size.height - inset * 2
        
        let height = (size.width - inset * 3) / 2
        
        let firstCGRect = CGRect(x: inset,
                                 y: inset,
                                 width: width,
                                 height: height)
        
        let secondCGRect = CGRect(x: inset,
                                  y: height + inset * 2,
                                  width: width,
                                  height: height)
        
        return (firstCGRect, secondCGRect)
    }
}
