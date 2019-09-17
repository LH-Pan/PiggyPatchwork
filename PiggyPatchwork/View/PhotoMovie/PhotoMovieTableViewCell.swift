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
    
    weak var delegate: PhotoMovieTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectedPhotoImageView.contentMode = .scaleAspectFill
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func didClickDelete(_ sender: Any) {
        
        delegate?.deleteCell(self)
    }
}
