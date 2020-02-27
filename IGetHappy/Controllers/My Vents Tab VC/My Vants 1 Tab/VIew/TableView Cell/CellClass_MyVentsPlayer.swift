//
//  CellClass_MyVentsPlayer.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class CellClass_MyVentsPlayer: UITableViewCell
{
    
    @IBOutlet weak var view_Player: CustomUIView!
    @IBOutlet weak var ivUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        self.view_Player.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
