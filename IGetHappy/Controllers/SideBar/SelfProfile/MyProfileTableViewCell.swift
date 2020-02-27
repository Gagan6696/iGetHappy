//
//  MyProfileTableViewCell.swift
//  IGetHappy
//
//  Created by Gagan on 11/4/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class MyProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var imgViewArrow: UIImageView!
    @IBOutlet weak var lblMenuItems: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
