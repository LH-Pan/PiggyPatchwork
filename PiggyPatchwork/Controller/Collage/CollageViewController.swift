//
//  CollageViewController.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/8/28.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit
import Vision
import AVFoundation
import OpalImagePicker
import Photos

class CollageViewController: UIViewController {
    
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var selectionView: SelectionView! {
        
        didSet {
            selectionView.dataSource = self
            
            selectionView.delegate = self
        }
    }
    
    @IBOutlet weak var collageView: UIView! {
        
        didSet {
            collageView.addViewShadow()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var nextStepBtn: UIButton! {
        
        didSet {
            nextStepBtn.setTitleColor(.hexStringToUIColor(hex: CustomColorCode.OrchidPink),
                                      for: .normal)
            nextStepBtn.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var backToHomeBtn: UIButton! {
        
        didSet {
            backToHomeBtn.setTitleColor(.hexStringToUIColor(hex: CustomColorCode.OrchidPink),
                                        for: .normal)
            backToHomeBtn.layer.cornerRadius = 10
        }
    }
    
    lazy var collageCollectionVoewLayout: CollageCollectionViewLayout = {
        
        let layoutObject = CollageCollectionViewLayout()
        
        layoutObject.itemCount = CGFloat(self.prototypeLayout.count)
        
        return layoutObject
    }()
    
    let functionOption: [FunctionOption] = [.prototypeFrame, .background, .emoticon]
    
    let colorCode: [ColorCode] = [.white, .petalPink, .waterMelonRed, .roseRed,
                                  .carrotOrange, .sunOrange,
                                  .pineappleYellow, .tigerYellow,
                                  .chartreuseGreen, .olivineGreen, .zucchiniGreen,
                                  .babyBlue, .clearSkyBlue, .prussianBlue,
                                  .lilacSkuPurple, .vividPurple, .amethystPurple,
                                  .ashGray, .stoneGray, .black]
    
    let cellEmoticon: [CellEmoticon] = [.funny, .doNotThinkSo, .weirdSmile,
                                        .crazy, .twinkleEyes, .dying,
                                        .lierFace, .cute, .exciting, .cry]
    
    let faceEmoticon: [FaceEmoticon] = [.funny, .doNotThinkSo, .weirdSmile,
                                        .crazy, .twinkleEyes, .dying,
                                        .lierFace, .cute, .exciting, .cry]
    
    let prototypeLayout: [Layoutable] = [DoubleVerticle(), DoubleHorizontal(), LeftVerticalWithDoubleSquare(),
                                         RightVerticalWithDoubleSquare(), HorizontalAboveWithDoubleSquare(),
                                         HorizontalBelowWithDoubleSquare(), TripleVertical(), TripleHorizontal(),
                                         QuadraSquare(), TripleLeftWithDoubleRight(), DoubleLeftWithTripleRight(),
                                         DoubleAboveWithTripleBelow(), TripleAboveWithDoubleBelow()]
    
    let faceImageLayout: Layoutable = SingleSquare()
    
    let personFaceScrollView = UIScrollView()
    
    let personFaceImageView = UIImageView()
    
    var chosenImageView: UIImageView?
    
    var savedImage: UIImage?
    
    var ptCellSelectedIndexPath: IndexPath?
    
    var bgCellSelectedIndexPath: IndexPath?
    
    var etCellSelectedIndexPath: IndexPath?

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        
        setupScrollView(at: collageView, add: personFaceScrollView, with: personFaceImageView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Gradient.doubleColor(at: view,
                             firstColorCode: CustomColorCode.PigletPink,
                             secondColorCode: CustomColorCode.OrchidPink)
    }
    
    // MARK: Private method
    // 建立 collection view
    
    private func setupCollectionView() {
        
        self.collectionView.delegate = self
        
        self.collectionView.dataSource = self
        
        collectionView.custom_registerCellWithNib(identifier: CollageCollectionViewCell.identifier,
                                                  bundle: nil)
        
        collectionView.custom_registerCellWithNib(identifier: BackgroundColorCollectionViewCell.identifier,
                                                  bundle: nil)
        
        collectionView.custom_registerCellWithNib(identifier: EmoticonCollectionViewCell.identifier,
                                                  bundle: nil)
        
        setupCollectionViewLayout()
        
    }
    
    private func setupCollectionViewLayout() {
        
        collectionView.collectionViewLayout = collageCollectionVoewLayout
    }
    
    private func setupImageView(at superView: UIView,
                                add imageView: UIImageView) {
        
        imageView.contentMode = .scaleAspectFill
        
        imageView.isUserInteractionEnabled = true
        
        imageView.addGestureRecognizer(self.setupTapGestureRecognizer())
        
        superView.addSubview(imageView)
    }
    
    private func setupScrollView(at superView: UIView,
                                 add scrollView: UIScrollView,
                                 with subView: UIImageView) {
        
        scrollView.delegate = self
        
        scrollView.zoomScale = 1
                            
        scrollView.minimumZoomScale = 0.1
    
        scrollView.maximumZoomScale = 2.0
     
        let minScale = scrollView.minimumZoomScale
        
        scrollView.layer.borderColor = UIColor.hexStringToUIColor(hex: CustomColorCode.SilverGray).cgColor
        
        scrollView.layer.borderWidth = 1
        
        scrollView.contentSize = CGSize(width: superView.frame.width,
                                        height: superView.frame.height)
        
        subView.frame.size = scrollView.contentSize
        
        let widthInset = (scrollView.frame.size.width - minScale * subView.frame.size.width) / 2
        
        let heightInset = (scrollView.frame.size.height - minScale * subView.frame.size.height) / 2
        
        scrollView.contentInset = UIEdgeInsets(top: heightInset,
                                               left: widthInset,
                                               bottom: heightInset,
                                               right: widthInset)
        
        scrollView.showsVerticalScrollIndicator = false

        scrollView.showsHorizontalScrollIndicator = false
        
        superView.addSubview(scrollView)

        self.setupImageView(at: scrollView, add: subView)
        
    }
    
    func setupTapGestureRecognizer() -> UITapGestureRecognizer {
        
        let singleTap = UITapGestureRecognizer(target: self,
                                               action: #selector(singleTapping(recognizer:)))
        
        return singleTap
    } 
    
    @objc func singleTapping(recognizer: UIGestureRecognizer) {
        
        chosenImageView = recognizer.view as? UIImageView
        
        showMyAlbum(subviews: recognizer.view?.subviews,
                    sublayers: recognizer.view?.layer.sublayers)
        
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
    
    func radioCollection(at collectionView: UICollectionView,
                         in currentIndexPath: IndexPath,
                         eqaulTo lastIndexPath: IndexPath?) {
        
        if currentIndexPath != lastIndexPath {
            if let lastSelectedIndexPath = lastIndexPath {
                if let cell = collectionView.cellForItem(at: lastSelectedIndexPath) {
                    cell.layer.borderWidth = 0
                }
            }
        }
    }
    
    // MARK: - 人臉辨識
    func faceDetection() {
        
        let detectRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handleFaces)
        
        guard let image = savedImage?.cgImage else { return }
        
        let detectRequestHandler = VNImageRequestHandler(cgImage: image,
                                                         options: [ : ])
 
        do {
            try detectRequestHandler.perform([detectRequest])
        } catch {
            
            PiggyJonAlert.showCustomIcon(icon: UIImage.asset(.exclamation_mark),
                                         message: "人臉偵測錯誤 (つд⊂)")
        }
    }
    
    func handleFaces(request: VNRequest,
                     error: Error?) {
        
        guard
            let faceDetectResults = request.results as? [VNFaceObservation]
        else {
            fatalError("Unexpected result type from VNDetectFaceRetanglesRequest.")
        }
        
        if faceDetectResults.count == 0 {
            
            PiggyJonAlert.showCustomIcon(icon: UIImage.asset(.exclamation_mark),
                                         message: "這張照片偵測不到人臉 இдஇ")
            return
        }
        
        self.addShapeToFace(forObservations: faceDetectResults)
    }
    
    func addShapeToFace(forObservations observations: [VNFaceObservation]) {
        
        if let sublayers = personFaceImageView.layer.sublayers {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
        
        let imageRect = AVMakeRect(aspectRatio: savedImage?.size ?? CGSize.zero,
                                   insideRect: collageView.bounds)
        
        let surplusWidth = CGFloat.insetRatio * collageView.frame.width
        
        let surplusHeight = CGFloat.insetRatio * collageView.frame.height
    
        let layers: [CAShapeLayer] = observations.map { observation in
            
            let width = observation.boundingBox.size.width * imageRect.width
            let height = observation.boundingBox.size.height * imageRect.height
            let originX = observation.boundingBox.origin.x * imageRect.width
            let originY = imageRect.maxY - (observation.boundingBox.origin.y * imageRect.height) - height
            
            let layer = CAShapeLayer()
            
            layer.frame = CGRect(x: originX,
                                 y: originY ,
                                 width: width * 5 / 7,
                                 height: height * 4 / 5)
            
            layer.backgroundColor = UIColor.hexStringToUIColor(hex: CustomColorCode.SkinOrange).cgColor
            
            layer.cornerRadius = layer.frame.size.height / 2
            
            layer.position = CGPoint(x: (originX + width / 2) - surplusWidth,
                                     y: (originY + height / 2) - surplusHeight)

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
            personFaceImageView.layer.addSublayer(layer)
            
        }

        for emoticonFace in emoticonFaces {
            
            emoticonFace.removeFromSuperview()
            personFaceImageView.addSubview(emoticonFace)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        savedImage = collageView.takeSnapshot()
        
        guard
            let previewVC = segue.destination as? CollagePreviewViewController
        else {
            return
        }
        
        previewVC.storageImage = savedImage
    }
    
    @IBAction func backToHomePage(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
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
                    withReuseIdentifier: CollageCollectionViewCell.identifier,
                    for: indexPath
                    ) as? CollageCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            
            memorizeCollection(at: prototypeCell,
                               in: indexPath,
                               eqaulTo: ptCellSelectedIndexPath)

            personFaceScrollView.frame = .zero
            
            if prototypeCell.collageCellView.subviews != [] {
                
                for subview in prototypeCell.collageCellView.subviews {
                    
                    subview.removeFromSuperview()
                }
            }
            
            let frames = self.prototypeLayout[indexPath.row].getFrames(prototypeCell.frame.size)
            
            for layout in frames {
                
                let subView = UIView()
                
                subView.frame = layout
                
                subView.backgroundColor = UIColor.hexStringToUIColor(hex: CustomColorCode.SilverGray)
                
                prototypeCell.collageCellView.addSubview(subView)
            
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
                
                if subView != personFaceScrollView {
                    
                    subView.frame = .zero
                    
                } else {
                
                    personFaceScrollView.frame = faceImageLayout.getFrames(self.collageView.frame.size).first ?? .zero
                        
                    personFaceImageView.frame = personFaceScrollView.frame
                        
                    personFaceScrollView.isScrollEnabled = false
                    
                    personFaceScrollView.minimumZoomScale = 1
                
                    personFaceScrollView.maximumZoomScale = 1
                    
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
        
        switch selectionView.selectedIndex {
            
        case 0:
            
            radioCollection(at: collectionView,
                            in: indexPath,
                            eqaulTo: ptCellSelectedIndexPath)
            
            ptCellSelectedIndexPath = indexPath
            
            let frames = self.prototypeLayout[indexPath.row].getFrames(self.collageView.frame.size)
            
            for subView in collageView.subviews {
                
                if subView == personFaceScrollView {
                    
                    subView.frame = .zero
                } else {
                    
                    subView.removeFromSuperview()
                }
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                
                for layout in frames {
                    
                    let scrollView = UIScrollView()
                    
                    let imageView = UIImageView()
                    
                    scrollView.frame = layout
                    
                    self.setupScrollView(at: self.collageView,
                                         add: scrollView,
                                         with: imageView)
                }
            })
        case 1:
            
            radioCollection(at: collectionView,
                            in: indexPath,
                            eqaulTo: bgCellSelectedIndexPath)
            
            bgCellSelectedIndexPath = indexPath
            
            collageView.backgroundColor = UIColor.hexStringToUIColor(hex: colorCode[indexPath.row].rawValue)
        case 2:
            
            if savedImage == nil {
                
                PiggyJonAlert.showCustomIcon(icon: UIImage.asset(.error_mark),
                                             message: "必須先選取照片哦！")
                return
            }
            
            radioCollection(at: collectionView,
                            in: indexPath,
                            eqaulTo: etCellSelectedIndexPath)
            
            etCellSelectedIndexPath = indexPath
            
            faceDetection()
            
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
        
        switch selectionView.selectedIndex {
            
        case 0: ptCellSelectedIndexPath = indexPath
        case 1: bgCellSelectedIndexPath = indexPath
        case 2: if savedImage == nil { return }
                etCellSelectedIndexPath = indexPath
        default: break
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return chosenImageView
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
        return UIColor.hexStringToUIColor(hex: CustomColorCode.EucalyptusGreen)
    }
    
    func enable(_ selectionView: SelectionView, index: Int) -> Bool {
        
        collageCollectionVoewLayout.selectedIndex = index

        switch index {
        case 0: collageCollectionVoewLayout.itemCount = CGFloat(self.prototypeLayout.count)
        case 1: collageCollectionVoewLayout.itemCount = CGFloat(self.colorCode.count)
        case 2: collageCollectionVoewLayout.itemCount = CGFloat(self.cellEmoticon.count)
                savedImage = nil
        default: break
        }
    
        collectionView.reloadData()
                
        return true
    }
}

extension CollageViewController: OpalImagePickerControllerDelegate {
    
    func showMyAlbum(subviews: [UIView]?,
                     sublayers: [CALayer]?) {
        
        PHPhotoLibrary.requestAuthorization { [weak self] (status) in
            
            DispatchQueue.main.async {
                
                if status == .authorized {
                    
                    let imagePicker = OpalImagePickerController()
                    
                    imagePicker.imagePickerDelegate = self
                    
                    imagePicker.maximumSelectionsAllowed = 1
                    
                    let configuration = OpalImagePickerConfiguration()
                               
                    let message = "無法選取超過 \(imagePicker.maximumSelectionsAllowed) 張照片哦！"
                               
                    configuration.maximumSelectionsAllowedMessage = message
                               
                    imagePicker.configuration = configuration
                    
                    self?.present(imagePicker, animated: true, completion: {
                        
                        if subviews != nil {
                            
                            for subview in subviews ?? [] {
                                
                                subview.removeFromSuperview()
                            }
                        }
                        
                        if sublayers != nil {
                            
                            for sublayer in sublayers ?? [] {
                                
                                sublayer.removeFromSuperlayer()
                            }
                        }
                    })
                } else {
                    
                    PiggyJonAlert.showCustomIcon(icon: UIImage.asset(.error_mark),
                                                 message: "無法讀取相簿，請在「設定」中授與權限")
                }
            }
        }
    }
    
    func imagePicker(
        _ picker: OpalImagePickerController,
        didFinishPickingImages images: [UIImage]) {
        
        chosenImageView?.image = images.first
        
        chosenImageView?.superview?.layer.borderWidth = 0
        
        savedImage = collageView.takeSnapshot()
        
        picker.dismiss(animated: true, completion: nil)
    }
}
