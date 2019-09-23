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
        
        showMyAlbum()
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
                                                 message: "無法讀取相簿 Σ(ﾟдﾟ)，請在「設定」中授與權限")
                }
            }
        }
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}
