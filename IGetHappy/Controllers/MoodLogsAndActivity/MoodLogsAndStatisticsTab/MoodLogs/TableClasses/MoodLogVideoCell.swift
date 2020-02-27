//
//  MoodLogVideoCell.swift
//  IGetHappy
//
//  Created by Gagan on 12/10/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class MoodLogVideoCell: UITableViewCell {
    
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var imgViewCuurentMood: UIImageView!
    @IBOutlet weak var lblMoodDetailDesc: UILabel!
    @IBOutlet weak var lblMoodDesc: UILabel!
    @IBOutlet weak var imgViewPrivacyIcon: UIImageView!
    @IBOutlet weak var lblMoodpostDate: UILabel!
    @IBOutlet weak var lblPrivacy: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var btnplay: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
