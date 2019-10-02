//
//  OpalImagePickerWrapper.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/10/2.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit
import OpalImagePicker
import Photos

protocol PiggyImagePickerDelegate: AnyObject {
    
    func imagesProvider(_ provider: PiggyOpalImagePicker, didGet images: [UIImage])
}

class PiggyOpalImagePicker: OpalImagePickerControllerDelegate {
    
    weak var delegate: PiggyImagePickerDelegate?
    
    func showAlbum(presenter: UIViewController, maximumAllowed: Int, completion: (() -> Void)?) {
        
        PHPhotoLibrary.requestAuthorization { (status) in
            
            DispatchQueue.main.async {
                
                if status == .authorized {
                    
                    let imagePicker = OpalImagePickerController()
                               
                    imagePicker.imagePickerDelegate = self
                    
                    imagePicker.maximumSelectionsAllowed = maximumAllowed
                    
                    let configuration = OpalImagePickerConfiguration()
                               
                    let message = "無法選取超過 \(imagePicker.maximumSelectionsAllowed) 張照片哦！"
                               
                    configuration.maximumSelectionsAllowedMessage = message
                               
                    imagePicker.configuration = configuration
                                   
                    presenter.present(imagePicker, animated: true, completion: completion)
                    
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
        
        delegate?.imagesProvider(self, didGet: images)
        
        picker.dismiss(animated: true, completion: nil)
    }
}
