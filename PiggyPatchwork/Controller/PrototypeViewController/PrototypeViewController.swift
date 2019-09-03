//
//  PrototypeViewController.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/8/28.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit
import Vision
import AVFoundation

class PrototypeViewController: UIViewController {
    
    @IBOutlet weak var selectionView: SelectionView! {
        
        didSet {
            selectionView.dataSource = self
            
            selectionView.delegate = self
        }
    }
    
    @IBOutlet weak var collageView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var prototypeCollectionVoewLayout: PrototypeCollectionViewLayout = {
        
        let layout = PrototypeCollectionViewLayout()
        
        return layout
    }()
    
    let collectionInfo = [
        CollectionInfo(title: "拼貼邊框",
                       images: [#imageLiteral(resourceName: "Double_vertical_retangel_60x60"), #imageLiteral(resourceName: "Double_horizontal_retangel_60x60")]),
        CollectionInfo(title: "背景",
                       images: [#imageLiteral(resourceName: "Double_horizontal_retangel_60x60"), #imageLiteral(resourceName: "Double_vertical_retangel_60x60")]),
        CollectionInfo(title: "顏文字換臉",
                       images: [#imageLiteral(resourceName: "Double_horizontal_retangel_60x60"), #imageLiteral(resourceName: "Double_vertical_retangel_60x60")])]
    
    let firstImageView = UIImageView()
    
    let secondImageView = UIImageView()
    
    let personFaceImage = UIImageView()
    
    var chooseImage: UIImageView?
    
    var savedImage: UIImage?
    
    var doubleView: (CGRect, CGRect) = (.zero, .zero) {
        
        didSet {
            (firstImageView.frame, secondImageView.frame) = doubleView
        }
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        setupImageView(with: collageView, add: firstImageView)
        
        setupImageView(with: collageView, add: secondImageView)
        
        setupImageView(with: collageView, add: personFaceImage)
    }
    
    // MARK: Private method
    
    // 建立 collection view
    private func setupCollectionView() {
        
        self.collectionView.delegate = self
        
        self.collectionView.dataSource = self
        
        collectionView.custom_registerCellWithNib(identifier: PrototypeCollectionViewCell.identifier,
                                                  bundle: nil)
        setupCollectionViewLayout()
    }
    
    private func setupCollectionViewLayout() {
        
        collectionView.collectionViewLayout = prototypeCollectionVoewLayout
    }
    
    private func setupImageView(with view: UIView,
                                add imageView: UIImageView) {
        
        view.addSubview(imageView)
        
        imageView.layer.borderColor = UIColor.hexStringToUIColor(hex: CustomColorCode.SilverGray).cgColor
        
        imageView.layer.borderWidth = 1
        
        imageView.contentMode = .scaleAspectFill
        
        imageView.clipsToBounds = true
        
        imageView.isUserInteractionEnabled = true
        
        imageView.addGestureRecognizer(setupTapGestureRecognizer())
    }
    
    private func setupCollectionViewCell(with cell: UICollectionViewCell,
                                         add imageView: UIImageView) {
        
        view.addSubview(imageView)
        
        imageView.backgroundColor = UIColor.hexStringToUIColor(hex: CustomColorCode.SilverGray)
        
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
    
    func faceDetection() {
        
        let detectRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handleFaces)
        
        let detectRequestHandler = VNImageRequestHandler(cgImage: (chooseImage?.image?.cgImage)!, options: [ : ])
        
        do {
            try detectRequestHandler.perform([detectRequest])
        } catch {
            
            print(error)
        }
    }
    
    func handleFaces(request: VNRequest, error: Error?) {
        
        guard
            let faceDetectResults = request.results as? [VNFaceObservation]
            else {
                fatalError("Unexpected result type from VNDetectFaceRetanglesRequest.")
        }
        
        if faceDetectResults.count == 0 {
            
            print("No face detect.")
            return
        }
        
        self.addShapeToFace(forObservations: faceDetectResults)
    }
    
    func addShapeToFace(forObservations observations: [VNFaceObservation]) {
        
        if let sublayers = personFaceImage.layer.sublayers {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
        
        let imageRect = AVMakeRect(aspectRatio: (chooseImage?.image?.size)!,
                                   insideRect: (chooseImage?.bounds)!)
        
        let layers: [CAShapeLayer] = observations.map { observation in
            
            let width = observation.boundingBox.size.width * imageRect.width
            let height = observation.boundingBox.size.height * imageRect.height
            let originX = observation.boundingBox.origin.x * imageRect.width
            let originY = imageRect.maxY - (observation.boundingBox.origin.y * imageRect.height) - height

            let layer = CAShapeLayer()
            layer.frame = CGRect(x: originX,
                                 y: originY,
                                 width: width,
                                 height: height)
            layer.borderColor = UIColor.red.cgColor
            layer.borderWidth = 2
            layer.cornerRadius = 3
            return layer
        }
        
        for layer in layers {
            personFaceImage.layer.addSublayer(layer)
        }
    }
    
    @IBAction func savePhoto(_ sender: Any) {
        
        savedImage = collageView.takeSnapshot()
        
        guard
            let savedImage = savedImage
        else {
            return
        }

        UIImageWriteToSavedPhotosAlbum(savedImage, nil, nil, nil)
    }
}
    // MARK: UICollectionViewDataSource
extension PrototypeViewController: UICollectionViewDataSource,
                                   UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
        ) -> Int {
        
        return collectionInfo[section].images.count
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
            if selectionView.selectedIndex == 2 {
                
                doubleView = (.zero, .zero)
                
                personFaceImage.frame = PrototypeLayout.singleSquareLayout(size: self.collageView.frame.size)
                
            } else {
                
            personFaceImage.frame = .zero

            prototypeCell.imageView.image = collectionInfo[selectionView.selectedIndex].images[indexPath.row]
    
            prototypeCell.layer.borderWidth = 0
            
            }
    
        return prototypeCell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
        case 0: UIView.animate(withDuration: 0.2,
                               animations: {
                                
                self.doubleView = PrototypeLayout.doubleVerticalLayout(size: self.collageView.frame.size)

        })
            
        case 1: UIView.animate(withDuration: 0.2,
                               animations: {
               
                self.doubleView = PrototypeLayout.doubleHorizontalLayout(size: self.collageView.frame.size)
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
    
    func numberOfSelections(_ selectionView: SelectionView) -> Int {
        return collectionInfo.count
    }
    
    func textOfSelections(_ selectionView: SelectionView, index: Int) -> String {
        return collectionInfo[index].title
    }
    
    func enable(_ selectionView: SelectionView, index: Int) -> Bool {
        
        collectionView.reloadData()
        
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
        
        faceDetection()
        
        picker.dismiss(animated: true, completion: nil)
    }
}
