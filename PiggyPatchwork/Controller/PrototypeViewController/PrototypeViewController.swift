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
    
    lazy var prototypeLayout: PrototypeCollectionViewLayout = {
        
        let layout = PrototypeCollectionViewLayout()
        
        return layout
    }()
    
    let collectionInfo = CollectionInfo(title: ["編排", "背景"],
                                        images: [#imageLiteral(resourceName: "Double_vertical_retangel_60x60"), #imageLiteral(resourceName: "Double_horizontal_retangel_60x60")])
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
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
}
    // MARK: UICollectionViewDataSource
extension PrototypeViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
        ) -> Int {
        
        return 2
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
        
        guard
            let cell = collectionView.cellForItem(at: indexPath)
        else {
            return
        }
        
        cell.layer.borderColor = UIColor.hexStringToUIColor(hex: CustomColor.SilverGray).cgColor
        
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
extension PrototypeViewController: SelectionViewDelegate, SelectionViewDataSource {
    
    func textOfSelections(_ selectionView: SelectionView, index: Int) -> String {
        return collectionInfo.title[index]
    }
    
    func enable(_ selectionView: SelectionView, index: Int) -> Bool {
        return true
    }
}
