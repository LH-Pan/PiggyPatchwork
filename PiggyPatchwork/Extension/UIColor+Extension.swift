//
//  UIColor+Extension.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/8/28.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

struct CustomColor {
    
    //Red Color
    static let PigletPink = UIColor.hexStringToUIColor(hex: "#FBEAF0")
    static let PastelPink = UIColor.hexStringToUIColor(hex: "#FFD0D6")
    static let OrchidPink = UIColor.hexStringToUIColor(hex: "#EF95AC")
    
    //Orange Color
    static let MelonOrange = UIColor.hexStringToUIColor(hex: "#EF95AC")
    static let SalamanderOrange = UIColor.hexStringToUIColor(hex: "#F15A22")
    static let SkinOrange = UIColor.hexStringToUIColor(hex: "#FCE6C9")
    
    //Yellow Color
    static let LemonadeYellow = UIColor.hexStringToUIColor(hex: "#FEE19F")
    
    //Green Color
    static let EucalyptusGreen = UIColor.hexStringToUIColor(hex: "#85CFB4")
    static let ZigguartGreen = UIColor.hexStringToUIColor(hex: "#B7DDE0")
    
    //Blue Color
    static let TurquoiseBlue = UIColor.hexStringToUIColor(hex: "#85B8CB")
    static let AquaBlue = UIColor.hexStringToUIColor(hex: "#BEE2E4")
    
    //Gray Color
    static let StoneGray = UIColor.hexStringToUIColor(hex: "#877D7C#")
    static let SilverGray = UIColor.hexStringToUIColor(hex: "#CED7D4")
    
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
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
