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

class PhotoMoviePreviewViewController: UIViewController {
    
    @IBOutlet weak var movieView: UIView!
    
    @IBOutlet weak var backToPhotoMovieBtn: UIButton! {
        
        didSet {
            
            backToPhotoMovieBtn.setupNavigationBtn()
        }
    }
    
    @IBOutlet weak var saveMovieView: UIView!
    
    @IBOutlet weak var shareToPlatformView: UIView!
    
    @IBOutlet weak var saveMovieBtn: UIButton!
    
    @IBOutlet weak var shareToPlatformBtn: UIButton!
    
    @IBOutlet weak var loadingAnimationView: AnimationView!
    
    let playerController = AVPlayerViewController()
    
    var player = AVPlayer()
    
    var movieUrl: String = .empty
    
    var makeMoviePhotos: [UIImage] = []
    
    let translucentView = UIView()
    
    let filmAnimationView = AnimationView()
    
    let progressingBar = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        Gradient.doubleColor(at: view,
                             firstColor: CustomColor.PigletPink,
                             secondColor: CustomColor.OrchidPink)
        
        PiggyLottie.setupAnimationView(view: loadingAnimationView,
                                       name: Lotties.loading,
                                       speed: 1,
                                       loopMode: .loop)
        
        setupTranslucentView()
        
        setupFilmAnimationView()
        
        setupProgressingBar()
        
        DispatchQueue.main.async {
            
            let settings = RenderSettings()
            
            let imageAnimator = ImageAnimator(renderSettings: settings,
                                              imageArray: self.makeMoviePhotos)
            
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
        
        translucentView.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        
        translucentView.isHidden = true
        
        view.addSubview(translucentView)
        
        translucentView.addSubview(filmAnimationView)
        
        translucentView.addSubview(progressingBar)
    }
    
    func setupFilmAnimationView() {

        filmAnimationView.backgroundColor = .clear

        filmAnimationView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            filmAnimationView.widthAnchor.constraint(equalToConstant: 300 * UIScreen.screenWidthRatio),
            filmAnimationView.heightAnchor.constraint(equalToConstant: 300 * UIScreen.screenWidthRatio),
            filmAnimationView.centerXAnchor.constraint(equalTo: translucentView.centerXAnchor),
            filmAnimationView.bottomAnchor.constraint(equalTo: translucentView.centerYAnchor,
                                                      constant: 85 * UIScreen.screenHeightRatio)
        ])
    }
    
    func setupProgressingBar() {
        
        progressingBar.backgroundColor = .clear
        
        progressingBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressingBar.centerXAnchor.constraint(equalTo: translucentView.centerXAnchor),
            progressingBar.topAnchor.constraint(equalTo: filmAnimationView.bottomAnchor),
            progressingBar.widthAnchor.constraint(equalTo: filmAnimationView.widthAnchor),
            progressingBar.heightAnchor.constraint(equalToConstant: 25 * UIScreen.screenHeightRatio)
        ])
    }
    
    func viewAttributes(_ view: UIView) {
           
        view.layer.cornerRadius = 25
           
        view.addViewShadow()
    }
    
    func displayVideo() {
        
        player = AVPlayer(url: URL(fileURLWithPath: movieUrl))
        
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
        
        player.pause()
        
        PHPhotoLibrary.requestAuthorization { status in

            guard status == .authorized else { return }

            PHPhotoLibrary.shared().performChanges({

                PHAssetChangeRequest.creationRequestForAssetFromVideo(
                    atFileURL: URL(fileURLWithPath: self.movieUrl) as URL
                )

            }, completionHandler: { (success, _) in

                if !success {

                    PiggyJonAlert.showCustomIcon(icon: UIImage.asset(.error_mark),
                                                 message: "無法存取影片至相簿中！")
                }
            })
        }
        
        translucentView.isHidden = false
        
        PiggyLottie.setupAnimationView(view: filmAnimationView,
                                       name: Lotties.videoMaking,
                                       speed: 2,
                                       loopMode: .playOnce)
        
        PiggyLottie.setupAnimationView(view: progressingBar,
                                       name: Lotties.progressBar,
                                       speed: 0.65,
                                       loopMode: .playOnce)
        
        progressingBar.play { [weak self] (finished) in
            
            if finished {
                
                PiggyJonAlert.showCustomIcon(icon: UIImage.asset(.tick_mark),
                                             message: "影片已儲存 d(＇∀＇)")
                
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func shareToPlatform(_ sender: Any) {
        
        let videoURL = URL(fileURLWithPath: movieUrl)
        
        let activityItem = [videoURL as Any] as [Any]
        
        let activityController = UIActivityViewController(activityItems: activityItem,
                                                          applicationActivities: nil)

        present(activityController, animated: true, completion: nil)
    }
}

extension PhotoMoviePreviewViewController: MovieUrlProviderDelegate {
    
    func provider(
        _ provider: ImageAnimator,
        didGet url: String
    ) {
        
        movieUrl = url
    }
}
