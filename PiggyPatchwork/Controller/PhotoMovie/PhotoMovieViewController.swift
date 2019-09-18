//
//  PhotoMovieViewController.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/15.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit
import OpalImagePicker

class PhotoMovieViewController: UIViewController {
    
    @IBOutlet weak var photoMovieTableView: UITableView! {
        
        didSet {
            photoMovieTableView.delegate = self
            
            photoMovieTableView.dataSource = self
        }
    }
    
    var selectedPhotos: [UIImage] = []
    
    var cellIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoMovieTableView.custom_registerCellWithNib(identifier: PhotoMovieTableViewCell.identifier,
                                                       bundle: nil)
        photoMovieTableView.isEditing = true
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard
            let moviePreviewVC = segue.destination as? MoviePreviewViewController
        else {
            return
        }
        
        moviePreviewVC.moviePhotos = selectedPhotos
    }
    
    @IBAction func showAlbum(_ sender: Any) {
        
        showMyAlbum()
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
    
    func tableView(
        _ tableView: UITableView,
        editActionsForRowAt indexPath: IndexPath
        ) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive,
                                          title: "Delete") { [weak self] (_, indexPath)  in
                                            
            self?.selectedPhotos.remove(at: indexPath.row)
                                                
            self?.photoMovieTableView.deleteRows(at: [indexPath], with: .left)
        }
        
        return [delete]
    }
}

extension PhotoMovieViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
        ) -> CGFloat {
        
        return 207 / 896 * UIScreen.height
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

        return true
    }
}

extension PhotoMovieViewController: OpalImagePickerControllerDelegate {
    
    func showMyAlbum() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            
            let imagePicker = OpalImagePickerController()
            
            imagePicker.imagePickerDelegate = self
            
            imagePicker.maximumSelectionsAllowed = 10
            
            let configuration = OpalImagePickerConfiguration()
            
            let message = "無法選取超過 \(imagePicker.maximumSelectionsAllowed) 張照片哦！"
            
            configuration.maximumSelectionsAllowedMessage = message
            
            imagePicker.configuration = configuration
            
            present(imagePicker, animated: true, completion: nil)
            
        } else {
            
            PiggyJonAlert.showCustomIcon(icon: UIImage.asset(.error_mark),
                                         message: "無法讀取相簿 Σ(ﾟдﾟ)")
        }
    }
    
    func imagePicker(
        _ picker: OpalImagePickerController,
        didFinishPickingImages images: [UIImage]
        ) {
        
        for image in images {
            
            selectedPhotos.append(image)
        }
        
        photoMovieTableView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
}

extension PhotoMovieViewController: PhotoMovieTableViewCellDelegate {
   
    func deleteCell(_ cell: PhotoMovieTableViewCell) {

        didClickDeleteInCell(cell)
    }
}
