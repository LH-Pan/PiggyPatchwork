//
//  File.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/11.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    
    @IBOutlet weak var canvasImageView: UIImageView!
    
    var storageImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canvasImageView.image = storageImage
    }
}
