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
import Lottie

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
    
    @IBOutlet weak var saveMovieBtn: UIButton!
    
    @IBOutlet weak var shareToPlatformBtn: UIButton!
    
    @IBOutlet weak var loadingView: AnimationView!
    
    let playerController = AVPlayerViewController()
    
    let player = AVPlayer()
    
    var looper: AVPlayerLooper?
    
    var movieUrl: String = .empty
    
    var moviePhotos: [UIImage] = []
    
    let translucentView = UIView()
    
    let filmAnimationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        Gradient.doubleColor(at: view,
                             firstColorCode: CustomColorCode.PigletPink,
                             secondColorCode: CustomColorCode.OrchidPink)
        
        PiggyLottie.setupAnimationView(view: loadingView,
                                       name: Lotties.loading,
                                       speed: 1,
                                       loopMode: .loop)
        
        setupTranslucentView()
        
        setupFilmAnimationView()
        
        DispatchQueue.main.async {
            
            let settings = RenderSettings()
            
            let imageAnimator = ImageAnimator(renderSettings: settings, imagearr: self.moviePhotos)
            
            imageAnimator.delegate = self
            
            imageAnimator.render {
                
                self.displayVideo()
            }
        }
    }
    
    func setupView() {
        
        viewAttributes(saveMovieView)
        
        viewAttributes(shareToPlatformView)
    }
    
    func setupTranslucentView() {
        
        translucentView.frame = view.frame
        
        translucentView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        translucentView.isHidden = true
        
        view.addSubview(translucentView)
        
        translucentView.addSubview(filmAnimationView)
    }
    
    func setupFilmAnimationView() {
        
        filmAnimationView.frame.size = CGSize(width: 300 / 414 * UIScreen.width,
                                              height: 300 / 414 * UIScreen.width)
        
        filmAnimationView.center.x = translucentView.center.x
        
        filmAnimationView.center.y = translucentView.center.y + 50 / 896 * UIScreen.height
        
        filmAnimationView.backgroundColor = .clear
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
                    
                    PiggyJonAlert.showCustomIcon(icon: UIImage.asset(.error_mark),
                                                 message: "無法存取影片至相簿中！")
                }
            })
        }
        translucentView.isHidden = false
        
        PiggyLottie.setupAnimationView(view: filmAnimationView,
                                       name: Lotties.videoMaking,
                                       speed: 1.5,
                                       loopMode: .loop)
        
        let transform = CGAffineTransform(scaleX: 0.99, y: 0.99)

        filmAnimationView.transform = transform

        UIView.animate(withDuration: 3,
                       animations: {

                        self.filmAnimationView.transform = CGAffineTransform.identity
        }, completion: { [weak self] (_) in
            
            PiggyJonAlert.showCustomIcon(icon: UIImage.asset(.tick_mark),
            message: "影片已儲存 d(＇∀＇)")

            self?.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    @IBAction func shareToPlatform(_ sender: Any) {
        
        let videoURL = URL(fileURLWithPath: movieUrl)
        
        let activityItems = [videoURL as Any] as [Any]
        
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

        self.present(activityController, animated: true, completion: nil)
    }
    
}

extension MoviePreviewViewController: MovieUrlProviderDelegate {
    
    func provider(_ provider: ImageAnimator, didGet url: String) {
        movieUrl = url
    }
}
