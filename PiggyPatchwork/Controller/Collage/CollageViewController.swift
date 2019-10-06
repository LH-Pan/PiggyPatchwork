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
    
    lazy var collageCollectionViewLayout: CollageCollectionViewLayout = {
        
        let layoutObject = CollageCollectionViewLayout()
        
        guard
            let collageController = collageMatches[selectionView.selectedIndex] as? CollageController
        else {
            return layoutObject
        }
        
        layoutObject.itemCount = CGFloat(collageController.collageLayout.count)
        
        return layoutObject
    }()
    
    let imagePicker = PiggyOpalImagePicker()
    
    let collageMatches: [CollageMatchable] = [CollageController(), BackgroundColorController(), EmoticonController()]
    
    let faceImageLayout: Layoutable = SingleSquare()
    
    let personFaceScrollView = UIScrollView()
    
    let personFaceImageView = UIImageView()
    
    var chosenImageView: UIImageView?
    
    var savedImage: UIImage?

    // MARK: - View Life Cycle
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
    
    // MARK: - Private method
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
        
        collectionView.collectionViewLayout = collageCollectionViewLayout
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
        
        scrollView.showsVerticalScrollIndicator = false

        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.contentSize = CGSize(width: superView.frame.width,
                                        height: superView.frame.height)
        
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
    
    private func setupButton() {
        
        nextStepBtn.setupNavigationBtn()
        
        backToHomeBtn.setupNavigationBtn()
    }
    
    private func removeSubViews(
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
                              completion: { [weak self] in
                                self?.removeSubViews(subviews: recognizer.view?.subviews,
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
            
            guard
                let emoticonController = collageMatches[selectionView.selectedIndex] as? EmoticonController
            else {
                return emoticonFace
            }
            
            let imageString = emoticonController.faceEmoticon[emoticonController.selectedIndexPath?.row ?? 0].rawValue

            emoticonFace.image = UIImage(named: imageString)
            
            return emoticonFace
        }
        
        for emoticonFace in emoticonFaces {
            
            emoticonFace.removeFromSuperview()
            
            view.addSubview(emoticonFace)
        }
    }
    
    // MARK: - IBAction
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        savedImage = collageView.takeSnapshot()
        
        guard let previewVC = segue.destination as? CollagePreviewViewController else { return }
        
        previewVC.storageImage = savedImage
    }
    
    @IBAction func backToHomePage(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
}
    // MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension CollageViewController: UICollectionViewDataSource,
                                 UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        
        return collageMatches[selectionView.selectedIndex].collectionView(collectionView,
                                                                          numberOfItemsInSection: section)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        return collageMatches[selectionView.selectedIndex].collectionView(collectionView,
                                                                          cellForItemAt: indexPath)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        switch selectionView.selectedIndex {

        case 0:
             
            guard
                let collageController = collageMatches[selectionView.selectedIndex] as? CollageController
            else { return }
            
            let frames = collageController.collageLayout[indexPath.row].getFrames(self.collageView.frame.size)
            
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
                    
                    let placeholderImageView = UIImageView()
                    
                    let imageView = UIImageView()
                    
                    scrollView.frame = layout
                    
                    placeholderImageView.frame.size = CGSize(width: 24 * UIScreen.screenWidthRatio,
                                                             height: 24 * UIScreen.screenWidthRatio)
                    
                    placeholderImageView.center = scrollView.center
                    
                    placeholderImageView.image = UIImage.asset(.Icons_24px_GreenAdd)
                    
                    self.collageView.addSubview(placeholderImageView)
                    
                    self.setupScrollView(at: self.collageView,
                                         add: scrollView,
                                         with: imageView)
                }
            })
            
        case 1:
            
            guard
                let backgroundController = collageMatches[selectionView.selectedIndex] as? BackgroundColorController
            else { return }
            
            let colorCode = backgroundController.colorCode[indexPath.row].rawValue
            
            collageView.backgroundColor = UIColor.hexStringToUIColor(hex: colorCode)
            
        case 2:
            
            if savedImage == nil {
                
                PiggyJonAlert.showCustomIcon(icon: UIImage.asset(.error_mark),
                                             message: "必須先選取照片哦！")
                return
            }
            
            collageMatches[selectionView.selectedIndex].selectedIndexPath = indexPath
            
            let faceDetecter = FaceDetection()
            
            faceDetecter.delegate = self
            
            faceDetecter.faceDetection(detect: savedImage)
            
        default: break
        }
        
        cell.layer.borderColor = UIColor.brown.cgColor
        
        cell.layer.borderWidth = 2
        
        collageMatches[selectionView.selectedIndex].collectionView?(collectionView,
                                                                    didSelectItemAt: indexPath)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {

        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        cell.layer.borderWidth = 0
        
        if selectionView.selectedIndex == 2 {
            
            if savedImage == nil { return }
        }

        collageMatches[selectionView.selectedIndex].collectionView?(collectionView,
                                                                    didDeselectItemAt: indexPath)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return scrollView.subviews.first
    }
}

    // MARK: - SelectionViewDelegate & SelectionViewDataSource
extension CollageViewController: SelectionViewDelegate,
                                 SelectionViewDataSource {
    
    func numberOfSelections(_ selectionView: SelectionView) -> Int {
        return collageMatches.count
    }
    
    func textOfSelections(_ selectionView: SelectionView, index: Int) -> String {
        return collageMatches[index].title.rawValue
    }
    
    func enable(_ selectionView: SelectionView, index: Int) -> Bool {
        
        collageCollectionViewLayout.selectedIndex = index

        switch index {
            
        case 0:
            
            guard
                let collageController = collageMatches[index] as? CollageController
            else {
                return false
            }
            
            collageCollectionViewLayout.itemCount = CGFloat(collageController.collageLayout.count)
            
            personFaceScrollView.frame = .zero
            
            savedImage = nil
            
            personFaceImageView.image = nil
            
            removeSubViews(subviews: personFaceImageView.subviews,
                           sublayers: personFaceImageView.layer.sublayers)
        
        case 1:
            
            guard
                let backgroundController = collageMatches[index] as? BackgroundColorController
            else {
                return false
            }
            
            collageCollectionViewLayout.itemCount = CGFloat(backgroundController.colorCode.count)
            
        case 2:
            
            guard
                let emoticonController = collageMatches[index] as? EmoticonController
            else {
                return false
            }
            
            collageCollectionViewLayout.itemCount = CGFloat(emoticonController.cellEmoticon.count)
            
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
        default: break
        }
    
        collectionView.reloadData()
                
        return true
    }
}
    // MARK: - Get FaceDetection frames
extension CollageViewController: FaceDetectionDelegate {
    
    func faceDetecter(
        _ detecter: FaceDetection,
        didGet frames: [VNFaceObservation]
    ) {
        addShapeToFace(forObservations: frames)
    }
}
    // MARK: - Get images from third-party image picker
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
