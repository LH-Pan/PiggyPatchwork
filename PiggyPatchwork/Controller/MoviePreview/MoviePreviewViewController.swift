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

class MoviePreviewViewController: UIViewController {
    
    @IBOutlet weak var movieView: UIView!
    
    let playerController = AVPlayerViewController()
    
    let player = AVPlayer()
    
    var looper: AVPlayerLooper?
    
    var movieUrl: String = ""
    
    var moviePhotos: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            let settings = RenderSettings()
            
            let imageAnimator = ImageAnimator(renderSettings: settings, imagearr: self.moviePhotos)
            
            imageAnimator.delegate = self
            
            imageAnimator.render {
                self.displayVideo()
            }
        }
    }
    
    func displayVideo() {
        
        let player = AVPlayer(url: URL(fileURLWithPath: movieUrl))
        
        playerController.view.frame.size = movieView.frame.size

        playerController.view.contentMode = .scaleAspectFit

        playerController.view.backgroundColor = .clear
        
        movieView.backgroundColor = .clear
        
        self.addChild(playerController)
        
        movieView.addSubview(playerController.view)
        
            playerController.player = player
        
            player.play()
    }
    
    @IBAction func saveMovie(_ sender: Any) {
        
        PHPhotoLibrary.requestAuthorization { status in
            
            guard status == .authorized else { return }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(
                    atFileURL: URL(fileURLWithPath: self.movieUrl) as URL)
            }, completionHandler: { (success, error) in
                
                if !success {
                    
                    print("Could not save video to photo library:", error!)
                }
            })
        }
    }
}

extension MoviePreviewViewController: MovieUrlProviderDelegate {
    
    func provider(_ provider: ImageAnimator, didGet url: String) {
        movieUrl = url
    }
    
}
