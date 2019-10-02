//
//  PhotoMovieViewController.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/15.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit
import Lottie

class PhotoMovieViewController: UIViewController {
    
    @IBOutlet weak var photoMovieTableView: UITableView!
    
    @IBOutlet weak var addPhotoBtn: UIButton! {
        
        didSet {
            addPhotoBtn.layer.cornerRadius = addPhotoBtn.frame.height / 2
            
            addPhotoBtn.imageView?.addViewShadow()
        }
    }
    
    @IBOutlet weak var backToHomeBtn: UIButton! {
        
        didSet {
            backToHomeBtn.setTitleColor(CustomColor.OrchidPink,
                                        for: .normal)
            backToHomeBtn.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var nextStepBtn: UIButton! {
        
        didSet {
            nextStepBtn.setTitleColor(CustomColor.OrchidPink,
                                      for: .normal)
            nextStepBtn.layer.cornerRadius = 10
        }
    }

    @IBOutlet weak var piggyStudioImageView: UIImageView!
    
    @IBOutlet weak var remindLabel: UILabel!
    
    @IBOutlet weak var animateArrow: AnimationView!
    
    let imagePicker = PiggyOpalImagePicker()
    
    var selectedPhotos: [UIImage] = []
    
    var cellIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Gradient.doubleColor(at: view,
                             firstColor: CustomColor.PigletPink,
                             secondColor: CustomColor.OrchidPink)
        
        PiggyLottie.setupAnimationView(view: animateArrow,
                                       name: Lotties.downArrow,
                                       speed: 2,
                                       loopMode: .loop)
    }
    
    func setupTableView() {
        
        photoMovieTableView.delegate = self
        
        photoMovieTableView.dataSource = self
        
        photoMovieTableView.custom_registerCellWithNib(identifier: PhotoMovieTableViewCell.identifier,
                                                       bundle: nil)
        photoMovieTableView.isEditing = true
    }
    
    func hideImages(_ hidden: Bool) {
        
        animateArrow.isHidden = hidden
        
        remindLabel.isHidden = hidden
        
        piggyStudioImageView.isHidden = hidden
    }
    
    func didClickDeleteInCell(_ cell: UITableViewCell) {
        
        guard
            let indexPath = photoMovieTableView.indexPath(for: cell)
        else {
            return
        }
        
        selectedPhotos.remove(at: indexPath.row)
        
        photoMovieTableView.deleteRows(at: [indexPath], with: .left)
        
        photoMovieTableView.reloadData()
        
        if selectedPhotos == [] {
                   
            hideImages(false)
        }
    }
    
    @IBAction func nextStep(_ sender: Any) {
        
        if selectedPhotos == [] {
                 
            PiggyJonAlert.showCustomIcon(icon: UIImage.asset(.error_mark),
                                         message: "目前沒有任何照片！")
            return
        }
            
        guard
            let moviePreviewVC = storyboard?.instantiateViewController(
                withIdentifier: "moviePreview"
        ) as? MoviePreviewViewController

        else {
            return
        }

        moviePreviewVC.makeMoviePhotos = selectedPhotos

        show(moviePreviewVC, sender: sender)
        
    }

    @IBAction func addPhotos(_ sender: Any) {
        
        imagePicker.showAlbum(presenter: self,
                              maximumAllowed: 10,
                              completion: nil)
    }
    
    @IBAction func backToHomePage(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
}

extension PhotoMovieViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        
        return selectedPhotos.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard
            let photoMovieCell = tableView.dequeueReusableCell(
                withIdentifier: PhotoMovieTableViewCell.identifier,
                for: indexPath) as? PhotoMovieTableViewCell
        else {
            return UITableViewCell()
        }
        
        photoMovieCell.delegate = self
        
        if selectedPhotos != [] {
        
        photoMovieCell.selectedPhotoImageView.image = selectedPhotos[indexPath.row]
            
        }
        
        return photoMovieCell
    }
    
    func tableView(
        _ tableView: UITableView,
        editingStyleForRowAt indexPath: IndexPath
    ) -> UITableViewCell.EditingStyle {

        return .none
    }
    
    func tableView(
        _ tableView: UITableView,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        
        let moveObject = self.selectedPhotos[sourceIndexPath.row]

        selectedPhotos.remove(at: sourceIndexPath.row)

        selectedPhotos.insert(moveObject, at: destinationIndexPath.row)
    
    }
}

extension PhotoMovieViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        
        return 220 * UIScreen.screenHeightRatio
    }

    func tableView(
        _ tableView: UITableView,
        canMoveRowAt indexPath: IndexPath
    ) -> Bool {

        return true
    }

    func tableView(
        _ tableView: UITableView,
        shouldIndentWhileEditingRowAt indexPath: IndexPath
    ) -> Bool {

        return false
    }
}

extension PhotoMovieViewController: PiggyImagePickerDelegate {
    
    func imagesProvider(
        _ provider: PiggyOpalImagePicker,
        didGet images: [UIImage]
    ) {
        
        for image in images {

            let fixedImage: UIImage = image.fixOrientation()

            selectedPhotos.append(fixedImage)
        }

        photoMovieTableView.reloadData()

        if selectedPhotos != [] {

            hideImages(true)
        }
    }
}

extension PhotoMovieViewController: PhotoMovieTableViewCellDelegate {
   
    func deleteCell(_ cell: PhotoMovieTableViewCell) {

        didClickDeleteInCell(cell)
    }
}
