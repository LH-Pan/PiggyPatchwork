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
        
        let layoutObject = PrototypeCollectionViewLayout()
        
        layoutObject.itemCount = CGFloat(self.prototypeLayout.count)
        
        return layoutObject
    }()
    
    let functionOption: [FunctionOption] = [.prototypeFrame, .background, .emoticon]
    
    let colorCode: [ColorCode] = [.white, .petalPink, .waterMelonRed,
                                  .roseRed, .carrotOrange, .sunOrange,
                                  .pineappleYellow, .tigerYellow]
    
    let prototypeLayout: [Layoutable] = [DoubleVerticle(), DoubleHorizontal()]
    
    let faceImageLayout: Layoutable = SingleSquare()
    
    let personFaceImage = UIImageView()
    
    var chooseImage: UIImageView?
    
    var savedImage: UIImage?
    
    var prototypeCellIndexPath: IndexPath?
    
    var backgroundCellIndexPath: IndexPath?
    
    var emoticonCellIndexPath: IndexPath?

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        
        setupImageView(at: collageView, add: personFaceImage)
    }
    
    // MARK: Private method
    // 建立 collection view
    private func setupCollectionView() {
        
        self.collectionView.delegate = self
        
        self.collectionView.dataSource = self
        
        collectionView.custom_registerCellWithNib(identifier: PrototypeCollectionViewCell.identifier,
                                                  bundle: nil)
        
        collectionView.custom_registerCellWithNib(identifier: BackgroundColorCollectionViewCell.identifier,
                                                  bundle: nil)
        
        collectionView.custom_registerCellWithNib(identifier: EmoticonCollectionViewCell.identifier,
                                                  bundle: nil)
        
        setupCollectionViewLayout()
    }
    
    private func setupCollectionViewLayout() {
        
        collectionView.collectionViewLayout = prototypeCollectionVoewLayout
    }
    
    func setupImageView(at superView: UIView, add imageView: UIImageView) {
        
        imageView.layer.borderColor = UIColor.hexStringToUIColor(hex: CustomColorCode.SilverGray).cgColor
        
        imageView.layer.borderWidth = 1
        
        imageView.contentMode = .scaleAspectFill
        
        imageView.clipsToBounds = true
        
        imageView.isUserInteractionEnabled = true
        
        imageView.addGestureRecognizer(self.setupTapGestureRecognizer())
        
        superView.addSubview(imageView)
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
                                 width: width * 3 / 5,
                                 height: height * 4 / 5)
//            layer.borderColor = UIColor.red.cgColor
//            layer.borderWidth = 0
            layer.cornerRadius = layer.frame.size.height / 2
            layer.position = CGPoint(x: (originX + width / 2), y: (originY + height / 2))

            layer.backgroundColor = personFaceImage.image?[
                Int((originX + width / 2) * 1800 / personFaceImage.frame.width),
                Int((originY + height / 2) * 1800 / personFaceImage.frame.height)
                ]?.cgColor
            
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
        
        if selectionView.selectedIndex == 0 {
            
            return prototypeLayout.count
            
        } else if selectionView.selectedIndex == 1 {
            
            return colorCode.count
            
        } else {
            
            return 2
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
        
        if selectionView.selectedIndex == 0 {

            guard
                let prototypeCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PrototypeCollectionViewCell.identifier,
                    for: indexPath
                    ) as? PrototypeCollectionViewCell
            else {
                return UICollectionViewCell()
            }
                personFaceImage.frame = .zero
            
                let frames = self.prototypeLayout[indexPath.row].getFrames(prototypeCell.frame.size)
            
                for layout in frames {
                    
                    let subView = UIView()
                    
                    subView.frame = layout
                    
                    subView.backgroundColor = UIColor.hexStringToUIColor(hex: CustomColorCode.SilverGray)
                    
                    prototypeCell.addSubview(subView)
                
                }
            
                return prototypeCell
            
        } else if selectionView.selectedIndex == 1 {
            
            guard
                let bakcgroundCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: BackgroundColorCollectionViewCell.identifier,
                    for: indexPath
                    ) as? BackgroundColorCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            
                bakcgroundCell.backgroundColor = UIColor.hexStringToUIColor(hex: self.colorCode[indexPath.row].rawValue)
            
                bakcgroundCell.layer.cornerRadius = bakcgroundCell.frame.size.height / 2
            
                return bakcgroundCell
            
        } else {
            
            guard
                let emoticonCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: EmoticonCollectionViewCell.identifier,
                    for: indexPath
                    ) as? EmoticonCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            
            for subView in self.collageView.subviews {
                
                if subView != personFaceImage {
                    
                    subView.frame = .zero
                    
                } else {
                
                personFaceImage.frame = faceImageLayout.getFrames(self.collageView.frame.size).first ?? .zero
                }
            }
        return emoticonCell
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
        
        guard
            let
                cell = collectionView.cellForItem(at: indexPath)
            else {
                return
        }

//        if backgroundCellIndexPath != nil {
//            guard let acellIndexPath = backgroundCellIndexPath else { return }
//            guard let apressedCell = collectionView.cellForItem(at: acellIndexPath) else { return }
//
//            apressedCell.layer.borderWidth = 0
//        }
    
        switch selectionView.selectedIndex {
            
        case 0:
            
            if prototypeCellIndexPath != nil {
                guard let cellIndexPath = prototypeCellIndexPath else { return }
                guard let pressedCell = collectionView.cellForItem(at: cellIndexPath) else { return }
                
                pressedCell.layer.borderWidth = 0
            }
            
            prototypeCellIndexPath = indexPath
            
            let frames = self.prototypeLayout[indexPath.row].getFrames(self.collageView.frame.size)
            
            for subView in collageView.subviews {
                
                if subView == personFaceImage {
                    
                    subView.frame = .zero
                } else {
                    
                    subView.removeFromSuperview()
                }
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                
                for layout in frames {
                    
                    let imageView = UIImageView()
                    
                    imageView.frame = layout
                    
                    self.setupImageView(at: self.collageView, add: imageView)
                }
            })
        case 1:
            
            backgroundCellIndexPath = indexPath
            
            collageView.backgroundColor = UIColor.hexStringToUIColor(hex: colorCode[indexPath.row].rawValue)
//        case 2:
        default: break
        }
        
        cell.layer.borderColor = UIColor.brown.cgColor
        
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

    // MARK: SelectionViewDelegate & SelectionViewDataSource
extension PrototypeViewController: SelectionViewDelegate,
                                   SelectionViewDataSource {
    
    func numberOfSelections(_ selectionView: SelectionView) -> Int {
        return functionOption.count
    }
    
    func textOfSelections(_ selectionView: SelectionView, index: Int) -> String {
        return functionOption[index].rawValue
    }
    
    func enable(_ selectionView: SelectionView, index: Int) -> Bool {
        
        collectionView.reloadData()
        
        // 待更換
        
        switch index {
        case 0: prototypeCollectionVoewLayout.itemCount = CGFloat(self.prototypeLayout.count)
        case 1: prototypeCollectionVoewLayout.itemCount = CGFloat(self.colorCode.count)
        case 2: prototypeCollectionVoewLayout.itemCount = CGFloat(self.prototypeLayout.count)
        default: break
        }
 
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
