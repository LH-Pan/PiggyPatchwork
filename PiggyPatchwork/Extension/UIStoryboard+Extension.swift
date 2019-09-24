//
//  UIStoryboard+Extension.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/15.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

struct StoryboardCategory {
    
    static let collage = "Collage"
    
    static let lobby = "Lobby"
    
    static let photoMovie = "PhotoMovie"
    
    static let privacy = "Pravicy"
}

extension UIStoryboard {
    
    static var collage: UIStoryboard { return setStoryboard(name: StoryboardCategory.collage) }
    
    static var lobby: UIStoryboard { return setStoryboard(name: StoryboardCategory.lobby) }
    
    static var photoMovie: UIStoryboard { return setStoryboard(name: StoryboardCategory.photoMovie) }
    
    static var privacy: UIStoryboard { return setStoryboard(name: StoryboardCategory.privacy) }
    
    private static func setStoryboard(name: String) -> UIStoryboard {
        
        return UIStoryboard(name: name, bundle: nil)
    }
}
