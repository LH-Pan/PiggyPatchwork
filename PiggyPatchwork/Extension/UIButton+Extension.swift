//
//  UIButton+Extension.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/10/2.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setupNavigationBtn() {
        
        setTitleColorPink()
        
        makeRadius()
    }
    
    func setTitleColorPink () {
        
        setTitleColor(CustomColor.OrchidPink,
                      for: .normal)
    }
    
    func makeRadius() {
        
        layer.cornerRadius = 10
    }
}
