//
//  MoviePreviewViewController.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/18.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Photos

var tempurl = ""

class MoviePreviewViewController: UIViewController {
    
    @IBOutlet weak var movieView: UIView!
    
    var moviePhotos: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            let settings = RenderSettings()
            
            let imageAnimator = ImageAnimator(renderSettings: settings, imagearr: self.moviePhotos)
            
            imageAnimator.render {
                self.displayVideo()
            }
        }
    }
    
    func displayVideo() {
        
        let myTempUrl: String = tempurl
        
        let player = AVPlayer(url: URL(fileURLWithPath: myTempUrl))
        
        let playerController = AVPlayerViewController()
        
        playerController.player = player
        
        self.addChild(playerController)

        movieView.addSubview(playerController.view)
        
        playerController.view.frame.size = movieView.frame.size

        playerController.view.contentMode = .scaleAspectFit

        playerController.view.backgroundColor = .clear
        
        movieView.backgroundColor = .clear
        
        player.play()
    }
    
    @IBAction func saveMovie(_ sender: Any) {
        
        PHPhotoLibrary.requestAuthorization { status in
            
            guard status == .authorized else { return }
            
            let path: String = tempurl
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: path) as URL)
            }, completionHandler: { (success, error) in
                
                if !success {
                    
                    print("Could not save video to photo library:", error!)
                }
            })
        }
    }
}
