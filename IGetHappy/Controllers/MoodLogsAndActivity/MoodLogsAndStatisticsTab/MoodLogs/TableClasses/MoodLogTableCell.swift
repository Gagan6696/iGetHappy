//
//  MoodLogTableCell.swift
//  IGetHappy
//
//  Created by Gagan on 11/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class MoodLogTableCell: UITableViewCell {

    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var imgViewCuurentMood: UIImageView!
    @IBOutlet weak var lblMoodDetailDesc: UILabel!
    @IBOutlet weak var lblMoodDesc: UILabel!
    @IBOutlet weak var imgViewPrivacyIcon: UIImageView!
    @IBOutlet weak var lblMoodpostDate: UILabel!
    @IBOutlet weak var lblPrivacy: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}
