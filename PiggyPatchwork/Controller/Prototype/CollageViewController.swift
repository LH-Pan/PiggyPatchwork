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

class CollageViewController: UIViewController {
    
    @IBOutlet weak var gradientView: UIView!
    
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
    
    let colorCode: [ColorCode] = [.white, .petalPink, .waterMelonRed,.roseRed,
                                  .carrotOrange, .sunOrange,
                                  .pineappleYellow, .tigerYellow,
                                  .chartreuseGreen,.olivineGreen, .zucchiniGreen,
                                  .babyBlue,.clearSkyBlue, .prussianBlue,
                                  .lilacSkuPurple,.vividPurple, .amethystPurple,
                                  .ashGray,.stoneGray, .black]
    
    let cellEmoticon: [CellEmoticon] = [.funny, .doNotThinkSo]
    
    let faceEmoticon: [FaceEmoticon] = [.funny, .doNotThinkSo]
    
    let prototypeLayout: [Layoutable] = [DoubleVerticle(), DoubleHorizontal()]
    
    let faceImageLayout: Layoutable = SingleSquare()
    
    let personFaceImage = UIImageView()
    
    var chooseImage: UIImageView?
    
    var savedImage: UIImage?
    
    var ptCellSelectedIndexPath: IndexPath?
    
    var bgCellSelectedIndexPath: IndexPath?
    
    var etCellSelectedIndexPath: IndexPath?

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        
        setupImageView(at: collageView, add: personFaceImage)
        
        addGradientLayer(at: view)
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
    
    private func setupImageView(at superView: UIView, add imageView: UIImageView) {
        
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
    
    func memorizeCollection(at cell: UICollectionViewCell,
                            in currentIndexPath: IndexPath,
                            eqaulTo lastIndexPath: IndexPath?) {
        
        if currentIndexPath == lastIndexPath {
            
            cell.layer.borderWidth = 2
            
            cell.layer.borderColor = UIColor.brown.cgColor
        } else {
            
            cell.layer.borderWidth = 0
        }
    }
    
    func radioCollection(in currentIndexPath: IndexPath,
                         eqaulTo lastIndexPath: IndexPath?) {
        
        if currentIndexPath != lastIndexPath {
            if let lastSelectedIndexPath = lastIndexPath {
                if let cell = collectionView.cellForItem(at: lastSelectedIndexPath) {
                    cell.layer.borderWidth = 0
                }
            }
        }
    }
    
    func addGradientLayer(at view: UIView) {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = view.bounds
        
        gradientLayer.colors = [UIColor.hexStringToUIColor(hex: CustomColorCode.PastelPink).cgColor,
                                UIColor.hexStringToUIColor(hex: CustomColorCode.OrchidPink).cgColor
                                ]

        view.layer.insertSublayer(gradientLayer, at: 0)

    }
    
    // MARK: - 人臉辨識
    func faceDetection() {
        
        let detectRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handleFaces)
        
        let detectRequestHandler = VNImageRequestHandler(cgImage: (savedImage?.cgImage)!, options: [ : ])
 
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
        
        let imageRect = AVMakeRect(aspectRatio: savedImage!.size,
                                   insideRect: collageView.bounds)
        
        let surplusWidth = CGFloat.insetRatio * collageView.frame.width
        
        let surplusHeight = CGFloat.insetRatio * collageView.frame.height
        
//        let widthZoomRatio = collageView.bounds.width / savedImage!.size.width
//
//        let heightZoomRatio = collageView.bounds.height / savedImage!.size.height
    
        let layers: [CAShapeLayer] = observations.map { observation in
            print(4, observation.boundingBox.origin.x)
            let width = observation.boundingBox.size.width * imageRect.width
            let height = observation.boundingBox.size.height * imageRect.height
            let originX = observation.boundingBox.origin.x * imageRect.width
            let originY = imageRect.maxY - (observation.boundingBox.origin.y * imageRect.height) - height
            
            let layer = CAShapeLayer()
            layer.frame = CGRect(x: originX,
                                 y: originY ,
                                 width: width * 5 / 7,
                                 height: height * 4 / 5)

            layer.cornerRadius = layer.frame.size.height / 2
            layer.position = CGPoint(x: (originX + width / 2) - surplusWidth,
                                     y: (originY + height / 2) - surplusHeight - 3)

            layer.backgroundColor = UIColor.hexStringToUIColor(hex: "#FCE6C9").cgColor
//            layer.backgroundColor = savedImage?[
//                Int(((originX + width / 2) / widthZoomRatio) - surplusWidth),
//                Int(((originY + height / 2) / heightZoomRatio) - surplusHeight)
//                ]?.cgColor

            return layer
        }
        
        let emoticonFaces: [UIImageView] = observations.map { observation in

            let width = observation.boundingBox.size.width * imageRect.width
            let height = observation.boundingBox.size.height * imageRect.height
            let originX = observation.boundingBox.origin.x * imageRect.width
            let originY = imageRect.maxY - (observation.boundingBox.origin.y * imageRect.height) - height

            let emoticonFace = UIImageView()
            emoticonFace.frame = CGRect(x: originX,
                                        y: originY,
                                        width: width * 100 / 414 * 3,
                                        height: height * 70 / 414 * 3)

            emoticonFace.center = CGPoint(x: (originX + width / 2) - surplusWidth ,
                                          y: (originY + height / 2) - surplusHeight)

            emoticonFace.image = UIImage(named: faceEmoticon[etCellSelectedIndexPath?.row ?? 0].rawValue)

            return emoticonFace
        }
        
        for layer in layers {
            personFaceImage.layer.addSublayer(layer)
            
        }
        
        for emoticonFace in emoticonFaces {
            
            emoticonFace.removeFromSuperview()
            personFaceImage.addSubview(emoticonFace)
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
extension CollageViewController: UICollectionViewDataSource,
                                   UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
        ) -> Int {
        
        switch selectionView.selectedIndex {
        
        case 0: return prototypeLayout.count
        case 1: return colorCode.count
        case 2: return cellEmoticon.count
        default: return 0
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
            
            memorizeCollection(at: prototypeCell,
                               in: indexPath,
                               eqaulTo: ptCellSelectedIndexPath)

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
            
            memorizeCollection(at: bakcgroundCell,
                               in: indexPath,
                               eqaulTo: bgCellSelectedIndexPath)
        
            bakcgroundCell.backgroundColor = UIColor.hexStringToUIColor(hex: self.colorCode[indexPath.row].rawValue)
        
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
            
            memorizeCollection(at: emoticonCell,
                               in: indexPath,
                               eqaulTo: etCellSelectedIndexPath)
            
            for subView in self.collageView.subviews {
                
                if subView != personFaceImage {
                    
                    subView.frame = .zero
                    
                } else {
                
                personFaceImage.frame = faceImageLayout.getFrames(self.collageView.frame.size).first ?? .zero
                    
                }
            }
        
            emoticonCell.emoticonImageView.image = UIImage(named: cellEmoticon[indexPath.row].rawValue)
            
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
        
        cell.layer.borderColor = UIColor.brown.cgColor
        
        cell.layer.borderWidth = 2
        
        switch selectionView.selectedIndex {
            
        case 0:
            
            radioCollection(in: indexPath,
                            eqaulTo: ptCellSelectedIndexPath)
            
            ptCellSelectedIndexPath = indexPath
            
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
            
            radioCollection(in: indexPath,
                            eqaulTo: bgCellSelectedIndexPath)
            
            bgCellSelectedIndexPath = indexPath
            
            collageView.backgroundColor = UIColor.hexStringToUIColor(hex: colorCode[indexPath.row].rawValue)
        case 2:
            
            radioCollection(in: indexPath,
                            eqaulTo: etCellSelectedIndexPath)
        
            etCellSelectedIndexPath = indexPath
            
            faceDetection()
        default: break
        }
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
        
        switch selectionView.selectedIndex {
            
        case 0: ptCellSelectedIndexPath = indexPath
        case 1: bgCellSelectedIndexPath = indexPath
        case 2: etCellSelectedIndexPath = indexPath
        default: break
        }
    }
}

    // MARK: SelectionViewDelegate & SelectionViewDataSource
extension CollageViewController: SelectionViewDelegate,
                                   SelectionViewDataSource {
    
    func numberOfSelections(_ selectionView: SelectionView) -> Int {
        return functionOption.count
    }
    
    func textOfSelections(_ selectionView: SelectionView, index: Int) -> String {
        return functionOption[index].rawValue
    }
    
    func colorOfIndicatorView(_ selectionView: SelectionView) -> UIColor {
        return UIColor.hexStringToUIColor(hex: CustomColorCode.LemonadeYellow)
    }
    
    func colorOfSelectionText(_ selectionView: SelectionView) -> UIColor {
        return UIColor.hexStringToUIColor(hex: CustomColorCode.StoneGray)
    }
    
    func enable(_ selectionView: SelectionView, index: Int) -> Bool {
        
        collectionView.reloadData()
        
        prototypeCollectionVoewLayout.selectedIndex = index

        switch index {
        case 0: prototypeCollectionVoewLayout.itemCount = CGFloat(self.prototypeLayout.count)
        case 1: prototypeCollectionVoewLayout.itemCount = CGFloat(self.colorCode.count)
        case 2: prototypeCollectionVoewLayout.itemCount = CGFloat(self.cellEmoticon.count)
        default: break
        }

        return true
    }
}

extension CollageViewController: UIImagePickerControllerDelegate,
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
        
        savedImage = collageView.takeSnapshot()
        
        picker.dismiss(animated: true, completion: nil)
    }
}
