//
//  UIColor+Extension.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/8/28.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

struct CustomColorCode {
    
    //Red Color
    static let PigletPink = "#FBEAF0"
    static let PastelPink = "#FFD0D6"
    static let OrchidPink = "#EF95AC"
    
    //Orange Color
    static let MelonOrange = "#E5A46E"
    static let SalamanderOrange = "#F15A22"
    static let SkinOrange = "#FCE6C9"
    
    //Yellow Color
    static let LemonadeYellow = "#FEE19F"
    
    //Green Color
    static let EucalyptusGreen = "#85CFB4"
    static let ZigguartGreen = "#B7DDE0"
    
    //Blue Color
    static let TurquoiseBlue = "#85B8CB"
    static let AquaBlue = "BEE2E4"
    
    //Gray Color
    static let StoneGray = "#877D7C#"
    static let SilverGray = "#CED7D4"
    
}

extension UIColor {
    
    // Hex String -> UIColor
    static func hexStringToUIColor(hex: String) -> UIColor {
        
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.count) != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
