//
//  MIBubbleCollectionViewCell.swift
//  IGetHappy
//
//  Created by Gagan on 5/22/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class MIBubbleCollectionViewCell: UICollectionViewCell {
    @IBOutlet var lblTitle:UILabel!
    
    @IBOutlet weak var bgImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2
    }
}
