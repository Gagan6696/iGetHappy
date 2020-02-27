//
//  GalleryScreenCollectionViewCell.swift
//  IGetHappy
//
//  Created by Prabhjot Singh on 23/10/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class GalleryScreenCollectionViewCell: UICollectionViewCell
{
    
    @IBOutlet weak var ivPlay: UIImageView!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnDeleteGallery: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ivSelected: UIImageView!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
    }
    
    
    
    
    
    
    
}



