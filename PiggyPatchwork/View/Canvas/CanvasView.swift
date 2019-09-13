//
//  CanvasView.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/12.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class Canvas: UIView {
    
    var lines = [Line]()
    
    var strokeColor = UIColor.black
    
    var strokeWidth: Float = 1
    
    override func draw(_ rect: CGRect) {
        
        // custom drawing
        super.draw(rect)
        
        guard
            let context = UIGraphicsGetCurrentContext()
        else {
            return
        }
        
        lines.forEach { (line) in
            for (endPoint, startPoint) in line.points.enumerated() {
                
                context.setStrokeColor(line.color.cgColor)
                context.setLineWidth(CGFloat(line.strokeWidth))
                context.setLineCap(.round)
                
                if endPoint == 0 {
                    context.move(to: startPoint)
                } else {
                    context.addLine(to: startPoint)
                }
            }
        }
        context.strokePath()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        lines.append(Line.init(color: strokeColor,
                               strokeWidth: strokeWidth,
                               points: []))
    }
    
    // track the finger as we move across screen
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard
            let point = touches.first?.location(in: self),
            var lastLine = lines.popLast()
        else {
            return
        }

        lastLine.points.append(point)

        lines.append(lastLine)
        
        setNeedsDisplay()
    }
    
    func undo() {
        
        _ = lines.popLast()
        
        setNeedsDisplay()
    }
    
    func clear() {
        
        lines.removeAll()
        
        setNeedsDisplay()
    }
    
    func setStrokeColor(color: UIColor) {
        
        strokeColor = color
    }
    
    func setStrokeWidth(width: Float) {
        
        strokeWidth = width
    }
}
