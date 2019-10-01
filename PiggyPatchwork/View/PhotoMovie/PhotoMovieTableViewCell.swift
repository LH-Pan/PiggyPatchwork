//
//  PhotoMovieTableViewCell.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/16.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

protocol PhotoMovieTableViewCellDelegate: AnyObject {
    
    func deleteCell(_ cell: PhotoMovieTableViewCell)
}

class PhotoMovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectedPhotoImageView: UIImageView!
    
    @IBOutlet weak var cardView: CardView!
    
    weak var delegate: PhotoMovieTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectedPhotoImageView.contentMode = .scaleAspectFill
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        selectedPhotoImageView.layer.maskedCorners = [.layerMinXMaxYCorner,
                                                      .layerMinXMinYCorner]
        
        selectedPhotoImageView.layer.cornerRadius = 8
    }
    
    @IBAction func didClickDelete(_ sender: Any) {
        
        delegate?.deleteCell(self)
    }
}
