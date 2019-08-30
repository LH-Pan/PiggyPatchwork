//
//  PrototypeViewController.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/8/28.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class PrototypeViewController: UIViewController {
    
    @IBOutlet weak var selectionView: SelectionView! {
        
        didSet {
            selectionView.dataSource = self
            
            selectionView.delegate = self
        }
    }
    
    @IBOutlet weak var collageView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var testImageVIew: UIImageView!
    
    lazy var prototypeLayout: PrototypeCollectionViewLayout = {
        
        let layout = PrototypeCollectionViewLayout()
        
        return layout
    }()
    
    let collectionInfo = CollectionInfo(title: ["編排", "背景"],
                                        images: [#imageLiteral(resourceName: "Double_vertical_retangel_60x60"), #imageLiteral(resourceName: "Double_horizontal_retangel_60x60")])
    
    let firstImageView = UIImageView()
    
    let secondImageView = UIImageView()
    
    var chooseImage: UIImageView?
    
    var savedImage: UIImage?
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        setupImageView(with: collageView, add: firstImageView)
        
        setupImageView(with: collageView, add: secondImageView)
        
    }
    
    // MARK: Private method
    private func setupCollectionView() {
        
        self.collectionView.delegate = self
        
        self.collectionView.dataSource = self
        
        collectionView.custom_registerCellWithNib(identifier: PrototypeCollectionViewCell.identifier,
                                                  bundle: nil)
        setupCollectionViewLayout()
    }
    
    private func setupCollectionViewLayout() {
        
        collectionView.collectionViewLayout = prototypeLayout
    }
    
    private func setupImageView(with view: UIView, add imageView: UIImageView) {
        
        view.addSubview(imageView)
        
        imageView.layer.borderColor = UIColor.hexStringToUIColor(hex: CustomColorCode.SilverGray).cgColor
        
        imageView.layer.borderWidth = 1
        
        imageView.contentMode = .scaleAspectFill
        
        imageView.clipsToBounds = true
        
        imageView.isUserInteractionEnabled = true
        
        imageView.addGestureRecognizer(setupTapGestureRecognizer())
    }
    
    func setupTapGestureRecognizer() -> UITapGestureRecognizer {
        
        let singleTap = UITapGestureRecognizer(target: self,
                                               action: #selector(singleTapping(recognizer:)))
        
        return singleTap
    }
    
    @objc func singleTapping(recognizer: UIGestureRecognizer) {
        
        chooseImage = recognizer.view as? UIImageView
        
        showAlbum()
    }
    
    func setupVerticalImageView() {
        
        let inset = 20 / 414 * UIScreen.width
        
        let imageViewWidth = (collageView.frame.width - inset * 3) / 2
        
        let imageViewHeight = collageView.frame.height - (inset * 2)

        firstImageView.frame = CGRect(x: collageView.bounds.origin.x + inset,
                                      y: collageView.bounds.origin.y + inset,
                                      width: imageViewWidth,
                                      height: imageViewHeight)
        
        secondImageView.frame = CGRect(x: imageViewWidth + inset * 2,
                                       y: collageView.bounds.origin.y + inset,
                                       width: imageViewWidth,
                                       height: imageViewHeight)
    }
    
    func setupHorizontalImageView() {
        
        let inset = 20 / 414 * UIScreen.width
        
        let imageViewWidth = collageView.frame.height - inset * 2
        
        let imageViewHeight = (collageView.frame.width - inset * 3) / 2
        
        firstImageView.frame = CGRect(x: collageView.bounds.origin.x + inset,
                                      y: collageView.bounds.origin.y + inset,
                                      width: imageViewWidth,
                                      height: imageViewHeight)
        
        secondImageView.frame = CGRect(x: collageView.bounds.origin.x + inset,
                                       y: imageViewHeight + inset * 2,
                                       width: imageViewWidth,
                                       height: imageViewHeight)
    }
    
    @IBAction func savePhoto(_ sender: Any) {
        
        savedImage = collageView.takeSnapshot()
        
        guard
            let savedImage = savedImage
        else {

            print ("目前沒有拼貼好的照片哦")
            return
        }

        UIImageWriteToSavedPhotosAlbum(savedImage, nil, nil, nil)
    }
}
    // MARK: UICollectionViewDataSource
extension PrototypeViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
        ) -> Int {
        
        return collectionInfo.images.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PrototypeCollectionViewCell.identifier,
            for: indexPath
        )
            
        guard
            let prototypeCell = cell as? PrototypeCollectionViewCell
        else {
            
            return cell
        }
        
        prototypeCell.imageView.image = collectionInfo.images[indexPath.row]
            
        return prototypeCell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
        case 0: UIView.animate(withDuration: 0.2,
                               animations: {
                self.setupVerticalImageView()
        })
            
        case 1: UIView.animate(withDuration: 0.2,
                               animations: {
                self.setupHorizontalImageView()
        })
            
        default: break
        }
        
        guard
            let cell = collectionView.cellForItem(at: indexPath)
        else {
            return
        }
        
        cell.layer.borderColor = UIColor.hexStringToUIColor(hex: CustomColorCode.SilverGray).cgColor
        
        cell.layer.borderWidth = 2
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath) {
        
        guard
            let cell = collectionView.cellForItem(at: indexPath)
            else {
                return
        }
        
        cell.layer.borderWidth = 0
    }
}

extension PrototypeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
        ) -> CGSize {

        return CGSize(width: 80/414 * UIScreen.width, height: 80/414 * UIScreen.width)
    }
}

    // MARK: SelectionViewDelegate & SelectionViewDataSource
extension PrototypeViewController: SelectionViewDelegate,
                                   SelectionViewDataSource {
    
    func textOfSelections(_ selectionView: SelectionView, index: Int) -> String {
        return collectionInfo.title[index]
    }
    
    func enable(_ selectionView: SelectionView, index: Int) -> Bool {
        return true
    }
}

extension PrototypeViewController: UIImagePickerControllerDelegate,
                                   UINavigationControllerDelegate {
    
    // 開啟相簿
    func showAlbum() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            
            let picker: UIImagePickerController = UIImagePickerController()
            
            picker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
            
            picker.delegate = self
            
            self.present(picker, animated: true, completion: nil)
            
        } else {
            
            print("無法讀取相簿")
        }
    }
    
    // 選用照片後置入點選的 imageView
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        chooseImage?.image = info[.originalImage] as? UIImage
        
        chooseImage?.layer.borderWidth = 0
        
        picker.dismiss(animated: true, completion: nil)
    }
}
