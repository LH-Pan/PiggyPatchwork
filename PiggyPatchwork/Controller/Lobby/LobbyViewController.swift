//
//  LobbyViewController.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/15.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit
import Lottie

class LobbyViewController: UIViewController {
    
    @IBOutlet weak var semicircleView: UIView!
    
    @IBOutlet weak var goToCollageView: UIView!
    
    @IBOutlet weak var makeMovieView: UIView!
    
    @IBOutlet weak var showAlbumView: UIView!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    let imagePicker = PiggyOpalImagePicker()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = CustomColor.OrchidPink
        
        setupButtonView()
        
        setupLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Gradient.doubleColor(at: view,
                             firstColor: CustomColor.PigletPink,
                             secondColor: CustomColor.OrchidPink)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        semicircleView.layer.cornerRadius = semicircleView.frame.width / 2
  
    }
    
    // MARK: - Private Method
    private func setupLabel() {
        
        versionLabel.text = "v" + String.space + (UIApplication.appVersion ?? String.empty)
    }

    private func setupButtonView() {
        
        viewAttributes(goToCollageView)
        
        viewAttributes(makeMovieView)
        
        viewAttributes(showAlbumView)
    }
    
    private func viewAttributes(_ view: UIView) {
        
        view.layer.cornerRadius = 25 * UIScreen.screenWidthRatio
        
        view.addViewShadow()
    }
    
    // MARK: - IBAction
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
        
        imagePicker.showAlbum(presenter: self,
                              maximumAllowed: 1,
                              completion: nil)
    }
    
    @IBAction func showPrivacyPolicy(_ sender: Any) {
        
        if let privacyViewController = UIStoryboard.privacy.instantiateInitialViewController() {
            
            show(privacyViewController, sender: sender)
        }
    }
}
