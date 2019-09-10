//
//  PreviewViewController.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/9.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var previewView: UIView! {
        
        didSet {
            previewView.addViewShadow()
        }
    }
    
    @IBOutlet weak var previewImageView: UIView!
    
    @IBOutlet weak var goLastPage: UIButton! {
        
        didSet {
            goLastPage.setTitleColor(.hexStringToUIColor(hex: CustomColorCode.OrchidPink),
                                     for: .normal)
            goLastPage.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var editBtn: UIButton! 
    
    @IBOutlet weak var savePhotoBtn: UIButton!
    
    @IBOutlet weak var showAlbumBtn: UIButton!
    
    @IBOutlet weak var editView: UIView!
    
    @IBOutlet weak var savePhotoView: UIView!
    
    @IBOutlet weak var showAlbumView: UIView!
    
    @IBOutlet weak var previewImage: UIImageView!
    
    var storageImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
        
        setupView()
        
        Gradient.shared.doubleColor(at: view,
                                    firstColor: CustomColorCode.PigletPink,
                                    secondColor: CustomColorCode.OrchidPink)
        
        previewImage.image = storageImage
    }
    
    func setupButton() {
        
        btnAttributes(editBtn)
        
        btnAttributes(savePhotoBtn)
        
        btnAttributes(showAlbumBtn)
    }
    
    func setupView() {
        
        viewAttributes(editView)
        
        viewAttributes(savePhotoView)
        
        viewAttributes(showAlbumView)
    }
    
    func btnAttributes(_ button: UIButton) {
        
        button.setTitleColor(.hexStringToUIColor(hex: CustomColorCode.EucalyptusGreen),
                             for: .normal)
    }
    
    func viewAttributes(_ view: UIView) {
        
        view.layer.cornerRadius = 25
        
        view.addViewShadow()
        
    }
    
    @IBAction func backToCollage(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func savePhoto(_ sender: Any) {
        
        storageImage = previewImageView.takeSnapshot()
        
        guard
            let image = storageImage
        else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        PiggyJonAlert.showCustomIcon(icon: UIImage.asset(.tick_mark),
                                     message: "照片已儲存至相簿囉 ♥")
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showAlbum(_ sender: Any) {
    }
}
