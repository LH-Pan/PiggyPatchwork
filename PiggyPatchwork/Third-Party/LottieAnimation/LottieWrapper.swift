//
//  LottieWrapper.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/20.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit
import Lottie

class PiggyLottie {
    
    static func setupAnimationView(
        view: AnimationView,
        name: String,
        speed: CGFloat,
        loopMode: LottieLoopMode
    ) {
        
        view.animation = Animation.named(name)
        
        view.animationSpeed = speed
        
        view.loopMode = loopMode
        
        view.play()
    }
}
