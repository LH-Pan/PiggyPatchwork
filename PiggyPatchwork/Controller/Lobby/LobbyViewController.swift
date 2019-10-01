//
//  LobbyViewController.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/15.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit
import OpalImagePicker
import Photos
import Lottie

class LobbyViewController: UIViewController {
    
    @IBOutlet weak var semicircleView: UIView!
    
    @IBOutlet weak var goToCollageView: UIView!
    
    @IBOutlet weak var makeMovieView: UIView!
    
    @IBOutlet weak var showAlbumView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = CustomColor.OrchidPink
        
        setupButtonView()
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

    func setupButtonView() {
        
        viewAttributes(goToCollageView)
        
        viewAttributes(makeMovieView)
        
        viewAttributes(showAlbumView)
    }
    
    func viewAttributes(_ view: UIView) {
        
        view.layer.cornerRadius = 25 * UIScreen.screenWidthRatio
        
        view.addViewShadow()
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
        
        showMyAlbum()
    }
    
    @IBAction func showPravicyPolicy(_ sender: Any) {
        
        if let privacyViewController = UIStoryboard.privacy.instantiateInitialViewController() {
            show(privacyViewController, sender: sender)
        }
    }
}

extension LobbyViewController: OpalImagePickerControllerDelegate {
    
    func showMyAlbum() {
        
        PHPhotoLibrary.requestAuthorization { [weak self] (status) in
            
            DispatchQueue.main.async {
                
                if status == .authorized {
                    
                    let imagePicker = OpalImagePickerController()
                               
                    imagePicker.imagePickerDelegate = self
                                   
                    self?.present(imagePicker, animated: true, completion: nil)
                    
                } else {
                    
                    PiggyJonAlert.showCustomIcon(icon: UIImage.asset(.error_mark),
                                                 message: "無法讀取相簿，請在「設定」中授與權限")
                }
            }
        }
    }
    
    func imagePicker(
        _ picker: OpalImagePickerController,
        didFinishPickingImages images: [UIImage]
    ) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}
