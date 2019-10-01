//
//  UIApplication+Extension.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/10/1.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static var appVersion: String? {
        
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
