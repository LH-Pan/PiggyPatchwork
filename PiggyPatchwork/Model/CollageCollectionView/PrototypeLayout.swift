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

struct DoubleVertical: Layoutable {

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
        
        let verticalRectangleHeight = size.height - heightInset * 2
        
        let squareHeight = (size.height - heightInset * 3) / 2
        
        let rectangleCGRect = CGRect(x: widthInset,
                                     y: heightInset,
                                     width: width,
                                     height: verticalRectangleHeight)
        
        let firstSquareCGRect = CGRect(x: width + widthInset * 2,
                                       y: heightInset,
                                       width: width,
                                       height: squareHeight)
        
        let secondSquareCGRect = CGRect(x: width + widthInset * 2,
                                        y: squareHeight + heightInset * 2,
                                        width: width,
                                        height: squareHeight)
        
        return [rectangleCGRect, firstSquareCGRect, secondSquareCGRect]
    }
}

struct RightVerticalWithDoubleSquare: Layoutable {
    
    func getFrames(_ size: CGSize) -> [CGRect] {
        
        let widthInset: CGFloat = CGFloat.insetRatio * size.width
        
        let heightInset: CGFloat = CGFloat.insetRatio * size.height
        
        let width = (size.width - widthInset * 3) / 2
        
        let verticalRectangleHeight = size.height - heightInset * 2
        
        let squareHeight = (size.height - heightInset * 3) / 2
        
        let firstSquareCGRect = CGRect(x: widthInset,
                                       y: heightInset,
                                       width: width,
                                       height: squareHeight)
        
        let secondSquareCGRect = CGRect(x: widthInset,
                                        y: squareHeight + heightInset * 2,
                                        width: width,
                                        height: squareHeight)
        
        let rectangleCGRect = CGRect(x: width + widthInset * 2,
                                     y: heightInset,
                                     width: width,
                                     height: verticalRectangleHeight)
        
        return [firstSquareCGRect, secondSquareCGRect, rectangleCGRect]
    }
}

struct HorizontalAboveWithDoubleSquare: Layoutable {
    
    func getFrames(_ size: CGSize) -> [CGRect] {
        
        let widthInset: CGFloat = CGFloat.insetRatio * size.width
        
        let heightInset: CGFloat = CGFloat.insetRatio * size.height
        
        let horizontalRectangleWidth = size.width - widthInset * 2
        
        let squareWidth = (size.width - widthInset * 3) / 2
        
        let height = (size.height - heightInset * 3) / 2
        
        let rectangleCGRect = CGRect(x: widthInset,
                                     y: heightInset,
                                     width: horizontalRectangleWidth,
                                     height: height)
        
        let firstSquareCGRect = CGRect(x: widthInset,
                                       y: height + heightInset * 2,
                                       width: squareWidth,
                                       height: height)
        
        let secondSquareCGRect = CGRect(x: squareWidth + widthInset * 2,
                                        y: height + heightInset * 2,
                                        width: squareWidth,
                                        height: height)
        
        return [rectangleCGRect, firstSquareCGRect, secondSquareCGRect]
    }
}

struct HorizontalBelowWithDoubleSquare: Layoutable {
    
    func getFrames(_ size: CGSize) -> [CGRect] {
        
        let widthInset: CGFloat = CGFloat.insetRatio * size.width
        
        let heightInset: CGFloat = CGFloat.insetRatio * size.height
        
        let horizontalRectangleWidth = size.width - widthInset * 2
        
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
        
        let rectangleCGRect = CGRect(x: widthInset,
                                     y: height + heightInset * 2,
                                     width: horizontalRectangleWidth,
                                     height: height)
        
        return [firstSquareCGRect, secondSquareCGRect, rectangleCGRect]
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
        
        let rectangleHeight = (size.height - heightInset * 4) / 3
        
        let firstSquareCGRect = CGRect(x: widthInset,
                                       y: heightInset,
                                       width: width,
                                       height: squareHeight)
        
        let secondSquareCGRect = CGRect(x: widthInset,
                                        y: squareHeight + heightInset * 2,
                                        width: width,
                                        height: squareHeight)
        
        let firstRectangleCGRect = CGRect(x: width + widthInset * 2,
                                         y: heightInset,
                                         width: width,
                                         height: rectangleHeight)
        
        let secondRectangleCGRect = CGRect(x: width + widthInset * 2,
                                           y: rectangleHeight + heightInset * 2,
                                           width: width,
                                           height: rectangleHeight)
        
        let thirdRectangleCGRect = CGRect(x: width + widthInset * 2,
                                          y: rectangleHeight * 2 + heightInset * 3,
                                          width: width,
                                          height: rectangleHeight)
        
        return [firstSquareCGRect, secondSquareCGRect, firstRectangleCGRect,
                secondRectangleCGRect, thirdRectangleCGRect]
    }
}

struct TripleLeftWithDoubleRight: Layoutable {
    
    func getFrames(_ size: CGSize) -> [CGRect] {
        
        let widthInset: CGFloat = CGFloat.insetRatio * size.width / 2
        
        let heightInset: CGFloat = CGFloat.insetRatio * size.height / 2
        
        let width = (size.width - widthInset * 3) / 2
        
        let squareHeight = (size.height - heightInset * 3) / 2
        
        let rectangleHeight = (size.height - heightInset * 4) / 3
        
        let firstSquareCGRect = CGRect(x: width + widthInset * 2,
                                       y: heightInset,
                                       width: width,
                                       height: squareHeight)
        
        let secondSquareCGRect = CGRect(x: width + widthInset * 2,
                                        y: squareHeight + heightInset * 2,
                                        width: width,
                                        height: squareHeight)
        
        let firstRectangleCGRect = CGRect(x: widthInset,
                                          y: heightInset,
                                          width: width,
                                          height: rectangleHeight)
        
        let secondRectangleCGRect = CGRect(x: widthInset,
                                           y: rectangleHeight + heightInset * 2,
                                           width: width,
                                           height: rectangleHeight)
        
        let thirdRectangleCGRect = CGRect(x: widthInset,
                                          y: rectangleHeight * 2 + heightInset * 3,
                                          width: width,
                                          height: rectangleHeight)
        
        return [firstSquareCGRect, secondSquareCGRect, firstRectangleCGRect,
                secondRectangleCGRect, thirdRectangleCGRect]
    }
}

struct DoubleAboveWithTripleBelow: Layoutable {
    
    func getFrames(_ size: CGSize) -> [CGRect] {
        
        let widthInset: CGFloat = CGFloat.insetRatio * size.width / 2
        
        let heightInset: CGFloat = CGFloat.insetRatio * size.height / 2
    
        let squareWidth = (size.width - widthInset * 3) / 2
        
        let rectangleWidth = (size.width - widthInset * 4) / 3
        
        let height = (size.width - widthInset * 3) / 2
        
        let leftSquareCGRect = CGRect(x: widthInset,
                                      y: heightInset,
                                      width: squareWidth,
                                      height: height)
        
        let rightSquareCGRect = CGRect(x: squareWidth + widthInset * 2,
                                       y: heightInset,
                                       width: squareWidth,
                                       height: height)
            
        let leftRectangleCGRect = CGRect(x: widthInset,
                                         y: height + heightInset * 2,
                                         width: rectangleWidth,
                                         height: height)
        
        let middleRectangleCGRect = CGRect(x: rectangleWidth + widthInset * 2,
                                           y: height + heightInset * 2,
                                           width: rectangleWidth,
                                           height: height)
        
        let rightRectangleCGRect = CGRect(x: rectangleWidth * 2 + widthInset * 3,
                                          y: height + heightInset * 2,
                                          width: rectangleWidth,
                                          height: height)
        
        return [leftSquareCGRect, rightSquareCGRect, leftRectangleCGRect,
                middleRectangleCGRect, rightRectangleCGRect]
    }
}

struct TripleAboveWithDoubleBelow: Layoutable {
    
    func getFrames(_ size: CGSize) -> [CGRect] {
        
        let widthInset: CGFloat = CGFloat.insetRatio * size.width / 2
            
        let heightInset: CGFloat = CGFloat.insetRatio * size.height / 2
    
        let squareWidth = (size.width - widthInset * 3) / 2
        
        let rectangleWidth = (size.width - widthInset * 4) / 3
        
        let height = (size.width - widthInset * 3) / 2
        
        let leftSquareCGRect = CGRect(x: widthInset,
                                      y: height + heightInset * 2,
                                      width: squareWidth,
                                      height: height)
        
        let rightSquareCGRect = CGRect(x: squareWidth + widthInset * 2,
                                       y: height + heightInset * 2,
                                       width: squareWidth,
                                       height: height)
            
        let leftRectangleCGRect = CGRect(x: widthInset,
                                         y: heightInset,
                                         width: rectangleWidth,
                                         height: height)
        
        let middleRectangleCGRect = CGRect(x: rectangleWidth + widthInset * 2,
                                           y: heightInset,
                                           width: rectangleWidth,
                                           height: height)
        
        let rightRectangleCGRect = CGRect(x: rectangleWidth * 2 + widthInset * 3,
                                          y: heightInset,
                                          width: rectangleWidth,
                                          height: height)
        
        return [leftSquareCGRect, rightSquareCGRect, leftRectangleCGRect,
                middleRectangleCGRect, rightRectangleCGRect]
    }
}
