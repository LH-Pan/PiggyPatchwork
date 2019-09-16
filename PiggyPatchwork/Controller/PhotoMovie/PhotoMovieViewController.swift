//
//  PhotoMovieViewController.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/15.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit
import OpalImagePicker

class PhotoMovieViewController: UIViewController {
    
    @IBOutlet weak var photoMovieTableView: UITableView! {
        
        didSet {
            photoMovieTableView.delegate = self
            
            photoMovieTableView.dataSource = self
        }
    }
    
    var choosePhotos: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showAlbum(_ sender: Any) {
        
        showMyAlbum()
    }
}

extension PhotoMovieViewController: UITableViewDelegate,
                                    UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension PhotoMovieViewController: OpalImagePickerControllerDelegate {
    
    func showMyAlbum() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            
            let imagePicker = OpalImagePickerController()
            
            imagePicker.imagePickerDelegate = self
            
            imagePicker.maximumSelectionsAllowed = 10
            
            present(imagePicker, animated: true, completion: nil)
            
        } else {
            
            PiggyJonAlert.showCustomIcon(icon: UIImage.asset(.error_mark),
                                         message: "無法讀取相簿 Σ(ﾟдﾟ)")
        }
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        
        choosePhotos = images
    }
}
