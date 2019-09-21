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
    
    @IBOutlet weak var backToPhotoMovieBtn: UIButton! {
        
        didSet {
            
            backToPhotoMovieBtn.setTitleColor(.hexStringToUIColor(hex: CustomColorCode.OrchidPink),
                                              for: .normal)
            backToPhotoMovieBtn.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var saveMovieView: UIView!
    
    @IBOutlet weak var shareToPlatformView: UIView!
    
    let playerController = AVPlayerViewController()
    
    let player = AVPlayer()
    
    var looper: AVPlayerLooper?
    
    var movieUrl: String = .empty
    
    var moviePhotos: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Gradient.shared.doubleColor(at: view,
                                    firstColor: CustomColorCode.PigletPink,
                                    secondColor: CustomColorCode.OrchidPink)
        
        DispatchQueue.main.async {
            
            let settings = RenderSettings()
            
            let imageAnimator = ImageAnimator(renderSettings: settings, imagearr: self.moviePhotos)
            
            imageAnimator.delegate = self
            
            imageAnimator.render {
                
                self.displayVideo()
            }
        }
    }
    
    func btnAttributes(_ button: UIButton) {
        
        button.setTitleColor(.hexStringToUIColor(hex: CustomColorCode.EucalyptusGreen),
                             for: .normal)
    }
    
    func viewAttributes(_ view: UIView) {
           
        view.layer.cornerRadius = 25
           
        view.addViewShadow()
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
    
    @IBAction func backToPhotoMovie(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
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
