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

struct LeftVerticalWithDoubleSquare: Layoutable {
    
    func getFrames(_ size: CGSize) -> [CGRect] {
        
        let widthInset: CGFloat = CGFloat.insetRatio * size.width
        
        let heightInset: CGFloat = CGFloat.insetRatio * size.height
        
        let width = (size.width - widthInset * 3) / 2
        
        let verticalRetangleHeight = size.height - heightInset * 2
        
        let squareHeight = (size.height - heightInset * 3) / 2
        
        let retangleCGRect = CGRect(x: widthInset,
                                    y: heightInset,
                                    width: width,
                                    height: verticalRetangleHeight)
        
        let firstSquareCGRect = CGRect(x: width + widthInset * 2,
                                       y: heightInset,
                                       width: width,
                                       height: squareHeight)
        
        let secondSquareCGRect = CGRect(x: width + widthInset * 2,
                                        y: squareHeight + heightInset * 2,
                                        width: width,
                                        height: squareHeight)
        
        return [retangleCGRect, firstSquareCGRect, secondSquareCGRect]
    }
}

struct RightVerticalWithDoubleSquare: Layoutable {
    
    func getFrames(_ size: CGSize) -> [CGRect] {
        
        let widthInset: CGFloat = CGFloat.insetRatio * size.width
        
        let heightInset: CGFloat = CGFloat.insetRatio * size.height
        
        let width = (size.width - widthInset * 3) / 2
        
        let verticalRetangleHeight = size.height - heightInset * 2
        
        let squareHeight = (size.height - heightInset * 3) / 2
        
        let firstSquareCGRect = CGRect(x: widthInset,
                                       y: heightInset,
                                       width: width,
                                       height: squareHeight)
        
        let secondSquareCGRect = CGRect(x: widthInset,
                                        y: squareHeight + heightInset * 2,
                                        width: width,
                                        height: squareHeight)
        
        let retangleCGRect = CGRect(x: width + widthInset * 2,
                                    y: heightInset,
                                    width: width,
                                    height: verticalRetangleHeight)
        
        return [firstSquareCGRect, secondSquareCGRect, retangleCGRect]
    }
}

struct HorizontalAboveWithDoubleSquare: Layoutable {
    
    func getFrames(_ size: CGSize) -> [CGRect] {
        
        let widthInset: CGFloat = CGFloat.insetRatio * size.width
        
        let heightInset: CGFloat = CGFloat.insetRatio * size.height
        
        let horizontalRetangleWidth = size.width - widthInset * 2
        
        let squareWidth = (size.width - widthInset * 3) / 2
        
        let height = (size.height - heightInset * 3) / 2
        
        let retangleCGRect = CGRect(x: widthInset,
                                    y: heightInset,
                                    width: horizontalRetangleWidth,
                                    height: height)
        
        let firstSquareCGRect = CGRect(x: widthInset,
                                       y: height + heightInset * 2,
                                       width: squareWidth,
                                       height: height)
        
        let secondSquareCGRect = CGRect(x: squareWidth + widthInset * 2,
                                        y: height + heightInset * 2,
                                        width: squareWidth,
                                        height: height)
        
        return [retangleCGRect, firstSquareCGRect, secondSquareCGRect]
    }
}

struct HorizontalBelowWithDoubleSquare: Layoutable {
    
    func getFrames(_ size: CGSize) -> [CGRect] {
        
        let widthInset: CGFloat = CGFloat.insetRatio * size.width
        
        let heightInset: CGFloat = CGFloat.insetRatio * size.height
        
        let horizontalRetangleWidth = size.width - widthInset * 2
        
        let squareWidth = (size.width - widthInset * 3) / 2
        
        let height = (size.height - heightInset * 3) / 2
        
        let firstSquareCGRect = CGRect(x: widthInset,
                                       y: heightInset,
                                       width: squareWidth,
                                       height: height)
        
        let secondSquareCGRect = CGRect(x: squareWidth + widthInset * 2,
                                        y: heightInset,
                                        width: squareWidth,
                                        height: height)
        
        let retangleCGRect = CGRect(x: widthInset,
                                    y: height + heightInset * 2,
                                    width: horizontalRetangleWidth,
                                    height: height)
        
        return [firstSquareCGRect, secondSquareCGRect, retangleCGRect] 
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

struct DoubleLeftWithTripleRight: Layoutable {
    
    func getFrames(_ size: CGSize) -> [CGRect] {
        
        let widthInset: CGFloat = CGFloat.insetRatio * size.width / 2
        
        let heightInset: CGFloat = CGFloat.insetRatio * size.height / 2
        
        let width = (size.width - widthInset * 3) / 2
        
        let squareHeight = (size.height - heightInset * 3) / 2
        
        let retangleHeight = (size.height - heightInset * 4) / 3
        
        let firstSquareCGRect = CGRect(x: widthInset,
                                       y: heightInset,
                                       width: width,
                                       height: squareHeight)
        
        let secondSquareCGRect = CGRect(x: widthInset,
                                        y: squareHeight + heightInset * 2,
                                        width: width,
                                        height: squareHeight)
        
        let firstRetangleCGRect = CGRect(x: width + widthInset * 2,
                                         y: heightInset,
                                         width: width,
                                         height: retangleHeight)
        
        let secondRetangleCGRect = CGRect(x: width + widthInset * 2,
                                          y: retangleHeight + heightInset * 2,
                                          width: width,
                                          height: retangleHeight)
        
        let thirdRetangleCGRect = CGRect(x: width + widthInset * 2,
                                         y: retangleHeight * 2 + heightInset * 3,
                                         width: width,
                                         height: retangleHeight)
        
        return [firstSquareCGRect, secondSquareCGRect, firstRetangleCGRect,
                secondRetangleCGRect, thirdRetangleCGRect]
    }
}

struct TripleLeftWithDoubleRight: Layoutable {
    
    func getFrames(_ size: CGSize) -> [CGRect] {
        
        let widthInset: CGFloat = CGFloat.insetRatio * size.width / 2
        
        let heightInset: CGFloat = CGFloat.insetRatio * size.height / 2
        
        let width = (size.width - widthInset * 3) / 2
        
        let squareHeight = (size.height - heightInset * 3) / 2
        
        let retangleHeight = (size.height - heightInset * 4) / 3
        
        let firstSquareCGRect = CGRect(x: width + widthInset * 2,
                                       y: heightInset,
                                       width: width,
                                       height: squareHeight)
        
        let secondSquareCGRect = CGRect(x: width + widthInset * 2,
                                        y: squareHeight + heightInset * 2,
                                        width: width,
                                        height: squareHeight)
        
        let firstRetangleCGRect = CGRect(x: widthInset,
                                         y: heightInset,
                                         width: width,
                                         height: retangleHeight)
        
        let secondRetangleCGRect = CGRect(x: widthInset,
                                          y: retangleHeight + heightInset * 2,
                                          width: width,
                                          height: retangleHeight)
        
        let thirdRetangleCGRect = CGRect(x: widthInset,
                                         y: retangleHeight * 2 + heightInset * 3,
                                         width: width,
                                         height: retangleHeight)
        
        return [firstSquareCGRect, secondSquareCGRect, firstRetangleCGRect,
                secondRetangleCGRect, thirdRetangleCGRect]
    }
}

struct DoubleAboveWithTripleBelow: Layoutable {
    
    func getFrames(_ size: CGSize) -> [CGRect] {
        
        let widthInset: CGFloat = CGFloat.insetRatio * size.width / 2
        
        let heightInset: CGFloat = CGFloat.insetRatio * size.height / 2
    
        let squareWidth = (size.width - widthInset * 3) / 2
        
        let retangleWidth = (size.width - widthInset * 4) / 3
        
        let height = (size.width - widthInset * 3) / 2
        
        let leftSquareCGRect = CGRect(x: widthInset,
                                      y: heightInset,
                                      width: squareWidth,
                                      height: height)
        
        let rightSquareCGRect = CGRect(x: squareWidth + widthInset * 2,
                                       y: heightInset,
                                       width: squareWidth,
                                       height: height)
            
        let leftRetangleCGRect = CGRect(x: widthInset,
                                        y: height + heightInset * 2,
                                        width: retangleWidth,
                                        height: height)
        
        let middleRetangleCGRect = CGRect(x: retangleWidth + widthInset * 2,
                                          y: height + heightInset * 2,
                                          width: retangleWidth,
                                          height: height)
        
        let rightRetangleCGRect = CGRect(x: retangleWidth * 2 + widthInset * 3,
                                         y: height + heightInset * 2,
                                         width: retangleWidth,
                                         height: height)
        
        return [leftSquareCGRect, rightSquareCGRect, leftRetangleCGRect,
                middleRetangleCGRect, rightRetangleCGRect]
    }
}

struct TripleAboveWithDoubleBelow: Layoutable {
    
    func getFrames(_ size: CGSize) -> [CGRect] {
        
        let widthInset: CGFloat = CGFloat.insetRatio * size.width / 2
            
        let heightInset: CGFloat = CGFloat.insetRatio * size.height / 2
    
        let squareWidth = (size.width - widthInset * 3) / 2
        
        let retangleWidth = (size.width - widthInset * 4) / 3
        
        let height = (size.width - widthInset * 3) / 2
        
        let leftSquareCGRect = CGRect(x: widthInset,
                                      y: height + heightInset * 2,
                                      width: squareWidth,
                                      height: height)
        
        let rightSquareCGRect = CGRect(x: squareWidth + widthInset * 2,
                                       y: height + heightInset * 2,
                                       width: squareWidth,
                                       height: height)
            
        let leftRetangleCGRect = CGRect(x: widthInset,
                                        y: heightInset,
                                        width: retangleWidth,
                                        height: height)
        
        let middleRetangleCGRect = CGRect(x: retangleWidth + widthInset * 2,
                                          y: heightInset,
                                          width: retangleWidth,
                                          height: height)
        
        let rightRetangleCGRect = CGRect(x: retangleWidth * 2 + widthInset * 3,
                                         y: heightInset,
                                         width: retangleWidth,
                                         height: height)
        
        return [leftSquareCGRect, rightSquareCGRect, leftRetangleCGRect,
                middleRetangleCGRect, rightRetangleCGRect]
    }
}
