//
//  PreviewViewController.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/9.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class CollagePreviewViewController: UIViewController {
    
    @IBOutlet weak var previewView: UIView! {
        
        didSet {
            previewView.addViewShadow()
        }
    }
    
    @IBOutlet weak var previewImageView: UIImageView!
    
    @IBOutlet weak var goLastPage: UIButton! {
        
        didSet {
            goLastPage.setTitleColor(.hexStringToUIColor(hex: CustomColorCode.OrchidPink),
                                     for: .normal)
            goLastPage.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var editBtn: UIButton! 
    
    @IBOutlet weak var savePhotoBtn: UIButton!
    
    @IBOutlet weak var shareToPlatformBtn: UIButton!
    
    @IBOutlet weak var editView: UIView!
    
    @IBOutlet weak var savePhotoView: UIView!
    
    @IBOutlet weak var shareToPlatformView: UIView!
    
    var storageImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonView()
        
        previewImageView.image = storageImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.delegate = self
        
        Gradient.doubleColor(at: view,
                             firstColorCode: CustomColorCode.PigletPink,
                             secondColorCode: CustomColorCode.OrchidPink)
    }
    
    func setupButtonView() {
        
        viewAttributes(editView)
        
        viewAttributes(savePhotoView)
        
        viewAttributes(shareToPlatformView)
    }
    
    func viewAttributes(_ view: UIView) {
        
        view.layer.cornerRadius = 25 / 414 * UIScreen.width
        
        view.addViewShadow()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard
            let canvasVC = segue.destination as? CanvasViewController
        else {
            return
        }
        
        canvasVC.delegate = self
        
        storageImage = previewImageView.takeSnapshot()
        
        canvasVC.storageImage = storageImage
    }
    
    @IBAction func backToCollage(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func savePhoto(_ sender: Any) {
        
        storageImage = previewView.takeSnapshot()
        
        guard
            let image = storageImage
        else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        PiggyJonAlert.showCustomIcon(icon: UIImage.asset(.tick_mark),
                                     message: "照片已儲存 (*´∀`)~♥")
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func shareToPlatform(_ sender: Any) {
        
        storageImage = previewView.takeSnapshot()
        
        let activityViewController = UIActivityViewController(activityItems: [storageImage ?? UIImage()],
                                                              applicationActivities: nil)
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension CollagePreviewViewController: UINavigationControllerDelegate {
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            
            return PushTransition()
            
        } else {
            
            return nil
        }
    }
}

extension CollagePreviewViewController: ImageProviderDelegate {
    
    func manager(_ viewController: CanvasViewController, didGet image: UIImage?) {
        
        previewImageView.image = image
    }
}
