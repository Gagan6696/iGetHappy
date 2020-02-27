//
//  CellClassMyVentsFeeling.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class CellClassMyVentsFeeling: UITableViewCell
{

    @IBOutlet weak var view_Feeling: CustomUIView!
    @IBOutlet weak var ivUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var ivPrivacy: UIImageView!
    @IBOutlet weak var lblPrivacy: UILabel!
    @IBOutlet weak var ivFeeling: UIImageView!
    @IBOutlet weak var lblFeeling: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        view_Feeling.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
