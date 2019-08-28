//
//  ViewController.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/8/27.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController,
                      UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate {

    let myImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myImageView.frame = CGRect(x: UIScreen.main.bounds.width / 4 / 2,
                                        y: 64,
                                        width: UIScreen.main.bounds.width / 4 * 3,
                                        height: 400)
        self.myImageView.image = #imageLiteral(resourceName: "test.jpg")
        self.myImageView.contentMode = .scaleAspectFill
        self.view.addSubview(self.myImageView)
    }
    func callGetPhoneWithKind(_ kind: Int) {
        let picker: UIImagePickerController = UIImagePickerController()
        switch kind {
        case 1:
            // 開啟相機
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                picker.sourceType = UIImagePickerController.SourceType.camera
                picker.allowsEditing = true // 可對照片作編輯
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                print("沒有相機鏡頭") // 可用 alert show
            }
        default:
            // 開啟相簿
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                picker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
                picker.allowsEditing = true
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }
        }
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        self.myImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    }
    @IBAction func openCamera(_ sender: Any) {
        self.callGetPhoneWithKind(1)
    }
    @IBAction func openAlbum(_ sender: Any) {
        self.callGetPhoneWithKind(2)
    }
}
