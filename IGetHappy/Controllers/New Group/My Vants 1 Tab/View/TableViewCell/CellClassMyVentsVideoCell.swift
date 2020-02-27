//
//  CellClassMyVentsVideoCell.swift
//  IGetHappy
//
//  Created by Gagan on 12/3/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation


class CellClassMyVentsVideoCell: UITableViewCell
{
    
    @IBOutlet weak var btnDropDownVideo: UIButton!
    
    @IBOutlet weak var bgViewVideoCell: CustomUIView!
    
    @IBOutlet weak var ivUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var ivPrivacy: UIImageView!
    @IBOutlet weak var lblPrivacy: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var btnplay: UIButton!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
