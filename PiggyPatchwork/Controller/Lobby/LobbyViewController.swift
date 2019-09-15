//
//  LobbyViewController.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/15.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func goToCollage(_ sender: Any) {
        
        if let collageViewController = UIStoryboard.collage.instantiateInitialViewController() {
            show(collageViewController, sender: sender)
        }
    }

    @IBAction func goToPhotoMovie(_ sender: Any) {
        
        if let photoMovieViewController = UIStoryboard.photoMovie.instantiateInitialViewController() {
            show(photoMovieViewController, sender: sender)
        }
    }
    
    @IBAction func showAlbum(_ sender: Any) {
    }
}
