//
//  CarouselCollectionViewCell.swift
//  UPCarouselFlowLayoutDemo
//
//  Created by Paul Ulric on 23/06/2016.
//  Copyright © 2016 Paul Ulric. All rights reserved.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var image: UIImageView!
    static let identifier = "CarouselCollectionViewCell"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
      //  self.layer.cornerRadius = self.frame.size.height/10
       // self.layer.borderWidth = 5
       // self.layer.borderColor = UIColor(red: 36.0/255.0, green: 150.0/255.0, blue: 245.0/255.0, alpha: 1.0).cgColor
    }
}
