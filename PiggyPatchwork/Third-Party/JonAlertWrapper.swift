//
//  JonAlertWrapper.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/8.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import JonAlert

class PiggyJonAlert {
    
    static let shared = PiggyJonAlert()
    
    private init() {}
    
    static func showSuccess(message: String) {
        
        JonAlert.showSuccess(message: message)
    }
    
    static func showError(message: String) {
        
        JonAlert.showError(message: message)
    }
    
    static func showMessage(message: String) {
        
        JonAlert.show(message: message)
    }
    
    static func showCustomIcon(icon image: UIImage?, message: String) {
        
        JonAlert.show(message: message, andIcon: image)
    }
}
