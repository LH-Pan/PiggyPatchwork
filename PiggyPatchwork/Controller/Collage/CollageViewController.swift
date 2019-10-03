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
    
    @IBOutlet weak var nextStepBtn: UIButton!
    
    @IBOutlet weak var backToHomeBtn: UIButton!
    
    lazy var collageCollectionVoewLayout: CollageCollectionViewLayout = {
        
        let layoutObject = CollageCollectionViewLayout()
        
        layoutObject.itemCount = CGFloat(self.prototypeLayout.count)
        
        return layoutObject
    }()
    
    let imagePicker = PiggyOpalImagePicker()
    
    let functionOption: [FunctionOption] = [.prototypeFrame, .background, .emoticon]
    
    let colorCode: [ColorCode] = [.white, .petalPink, .waterMelonRed, .roseRed,
                                  .carrotOrange, .sunOrange, .pineappleYellow,
                                  .tigerYellow, .chartreuseGreen, .olivineGreen,
                                  .zucchiniGreen, .babyBlue, .clearSkyBlue,
                                  .prussianBlue, .lilacSkuPurple, .vividPurple,
                                  .amethystPurple, .ashGray, .stoneGray, .black]
    
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
        
        setupButton()

        setupCollectionView()
        
        setupScrollView(at: collageView,
                        add: personFaceScrollView,
                        with: personFaceImageView)
        
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Gradient.doubleColor(at: view,
                             firstColor: CustomColor.PigletPink,
                             secondColor: CustomColor.OrchidPink)
    }
    
    // MARK: Private method
    // 建立 collection view
    private func setupCollectionView() {
        
        collectionView.delegate = self
        
        collectionView.dataSource = self
        
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
    
    private func setupImageView(
        at superView: UIView,
        add imageView: UIImageView
    ) {
        
        imageView.contentMode = .scaleAspectFill
        
        imageView.isUserInteractionEnabled = true
        
        imageView.addGestureRecognizer(self.setupTapGestureRecognizer())
        
        superView.addSubview(imageView)
    }
    
    private func setupScrollView(
        at superView: UIView,
        add scrollView: UIScrollView,
        with subView: UIImageView
    ) {
        
        scrollView.delegate = self
                            
        scrollView.minimumZoomScale = 0.1
    
        scrollView.maximumZoomScale = 2.0
        
        scrollView.layer.borderColor = CustomColor.SilverGray.cgColor
        
        scrollView.layer.borderWidth = 1
        
        scrollView.contentSize = CGSize(width: superView.frame.width,
                                        height: superView.frame.height)
        
        scrollView.showsVerticalScrollIndicator = false

        scrollView.showsHorizontalScrollIndicator = false
        
        subView.frame.size = scrollView.contentSize
        
        let minScale = scrollView.minimumZoomScale
        
        let widthInset = (scrollView.frame.size.width - minScale * subView.frame.size.width) / 2
        
        let heightInset = (scrollView.frame.size.height - minScale * subView.frame.size.height) / 2
        
        scrollView.contentInset = UIEdgeInsets(top: heightInset,
                                               left: widthInset,
                                               bottom: heightInset,
                                               right: widthInset)
        
        superView.addSubview(scrollView)

        setupImageView(at: scrollView, add: subView)
    }
    
    func setupButton() {
        
        nextStepBtn.setupNavigationBtn()
        
        backToHomeBtn.setupNavigationBtn()
    }
    
    func removeSubViews(
        subviews: [UIView]?,
        sublayers: [CALayer]?
    ) {
        
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
    }
    
    func setupTapGestureRecognizer() -> UITapGestureRecognizer {
        
        let singleTap = UITapGestureRecognizer(target: self,
                                               action: #selector(singleTapping(recognizer:)))
        
        return singleTap
    }
    
    @objc func singleTapping(recognizer: UIGestureRecognizer) {
        
        chosenImageView = recognizer.view as? UIImageView
        
        imagePicker.showAlbum(presenter: self,
                              maximumAllowed: 1,
                              completion: {
                                self.removeSubViews(subviews: recognizer.view?.subviews,
                                                    sublayers: recognizer.view?.layer.sublayers)
        })
    }
    
    // MARK: - 人臉辨識

    func addShapeToFace(forObservations observations: [VNFaceObservation]) {
        
        if let sublayers = personFaceImageView.layer.sublayers {
            
            for layer in sublayers {
                
                layer.removeFromSuperlayer()
            }
        }
        
        let imageRect = AVMakeRect(aspectRatio: savedImage?.size ?? CGSize.zero,
                                   insideRect: collageView.bounds)
        
        addSublayers(forObservations: observations,
                     withAVMakeRect: imageRect,
                     onView: personFaceImageView)
        
        addSubViews(forObservations: observations,
                    withAVMakeRect: imageRect,
                    onView: personFaceImageView)
    }
    
    func addSublayers(
        forObservations observations: [VNFaceObservation],
        withAVMakeRect imageRect: CGRect,
        onView view: UIView
    ) {
        let widthDeviation = CGFloat.insetRatio * collageView.frame.width
        
        let heightDeviation = CGFloat.insetRatio * collageView.frame.height
        
        let layers: [CAShapeLayer] = observations.map { observation in
            
            let width = observation.boundingBox.size.width * imageRect.width
            let height = observation.boundingBox.size.height * imageRect.height
            let originX = observation.boundingBox.origin.x * imageRect.width
            let originY = imageRect.maxY - (observation.boundingBox.origin.y * imageRect.height) - height
            
            let layer = CAShapeLayer()
            
            layer.frame = CGRect(x: originX,
                                 y: originY ,
                                 width: width * 5 / 7,
                                 height: height * 6 / 7)
            
            layer.backgroundColor = CustomColor.SkinOrange.cgColor
            
            layer.cornerRadius = layer.frame.size.height / 2
            
            layer.position =  CGPoint(x: (originX + width / 2) - widthDeviation,
                                      y: (originY + height / 2) - heightDeviation)

            return layer
        }
        
        for layer in layers {
                   
            view.layer.addSublayer(layer)
        }
    }
    
    func addSubViews(
        forObservations observations: [VNFaceObservation],
        withAVMakeRect imageRect: CGRect,
        onView view: UIView
    ) {
        let widthDeviation = CGFloat.insetRatio * collageView.frame.width
        
        let heightDeviation = CGFloat.insetRatio * collageView.frame.height
        
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

            emoticonFace.center = CGPoint(x: (originX + width / 2) - widthDeviation ,
                                          y: (originY + height / 2) - heightDeviation)

            emoticonFace.image = UIImage(named: faceEmoticon[etCellSelectedIndexPath?.row ?? 0].rawValue)
            
            return emoticonFace
        }
        
        for emoticonFace in emoticonFaces {
            
            emoticonFace.removeFromSuperview()
            
            view.addSubview(emoticonFace)
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
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        if selectionView.selectedIndex == 0 {

            guard
                let prototypeCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CollageCollectionViewCell.identifier,
                    for: indexPath
                ) as? CollageCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            
            prototypeCell.selectedCollection(inIndexPath: indexPath,
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
                
                subView.backgroundColor = CustomColor.SilverGray
                
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
            
            bakcgroundCell.selectedCollection(inIndexPath: indexPath,
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
            
            emoticonCell.selectedCollection(inIndexPath: indexPath,
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
                    
                    personFaceScrollView.layer.borderWidth = 1
                }
            }
        
            emoticonCell.emoticonImageView.image = UIImage(named: cellEmoticon[indexPath.row].rawValue)
            
            return emoticonCell
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        
        guard
            let
                cell = collectionView.cellForItem(at: indexPath)
        else {
            return
        }
        
        switch selectionView.selectedIndex {
            
        case 0:
            
            collectionView.radioCollection(inIndexPath: indexPath,
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
            
            collectionView.radioCollection(inIndexPath: indexPath,
                                           eqaulTo: bgCellSelectedIndexPath)
            
            bgCellSelectedIndexPath = indexPath
            
            collageView.backgroundColor = UIColor.hexStringToUIColor(hex: colorCode[indexPath.row].rawValue)
        case 2:
            
            if savedImage == nil {
                
                PiggyJonAlert.showCustomIcon(icon: UIImage.asset(.error_mark),
                                             message: "必須先選取照片哦！")
                return
            }
            
            collectionView.radioCollection(inIndexPath: indexPath,
                                           eqaulTo: etCellSelectedIndexPath)
            
            etCellSelectedIndexPath = indexPath
            
            let faceDetecter = FaceDetection()
            
            faceDetecter.delegate = self
            
            faceDetecter.faceDetection(detect: savedImage)
        default: break
        }
        
        cell.layer.borderColor = UIColor.brown.cgColor
        
        cell.layer.borderWidth = 2
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {

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
        return CustomColor.LemonadeYellow
    }
    
    func colorOfSelectionText(_ selectionView: SelectionView) -> UIColor {
        return CustomColor.EucalyptusGreen
    }
    
    func enable(_ selectionView: SelectionView, index: Int) -> Bool {
        
        collageCollectionVoewLayout.selectedIndex = index

        switch index {
        case 0: collageCollectionVoewLayout.itemCount = CGFloat(self.prototypeLayout.count)
        case 1: collageCollectionVoewLayout.itemCount = CGFloat(self.colorCode.count)
        case 2: collageCollectionVoewLayout.itemCount = CGFloat(self.cellEmoticon.count)
                savedImage = nil
                personFaceImageView.image = nil
                removeSubViews(subviews: personFaceImageView.subviews,
                               sublayers: personFaceImageView.layer.sublayers)
        default: break
        }
    
        collectionView.reloadData()
                
        return true
    }
}

extension CollageViewController: FaceDetectionDelegate {
    
    func faceDetecter(
        _ detecter: FaceDetection,
        didGet frames: [VNFaceObservation]
    ) {
        addShapeToFace(forObservations: frames)
    }
}

extension CollageViewController: PiggyImagePickerDelegate {
    
    func imagesProvider(
        _ provider: PiggyOpalImagePicker,
        didGet images: [UIImage]
    ) {
        
        chosenImageView?.image = images.first

        chosenImageView?.superview?.layer.borderWidth = 0

        savedImage = collageView.takeSnapshot()
    }
}
