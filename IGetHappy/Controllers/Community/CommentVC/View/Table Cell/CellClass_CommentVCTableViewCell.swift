//
//  CellClass_CommentVCTableViewCell.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/1/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class CellClass_CommentVCTableViewCell: UITableViewCell
{

    @IBOutlet weak var iv_Avatar: UIImageView!
    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var lbl_message: UILabel!
    @IBOutlet weak var btn_Reply: UIButton!
    
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.iv_Avatar.layer.cornerRadius = 25
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

    }
    
    

}
