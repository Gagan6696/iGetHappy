//
//  cellClass_ReplyVC.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/1/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class cellClass_ReplyVC: UITableViewCell
{

    @IBOutlet weak var iv_Avatar: UIImageView!
    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var lbl_message: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        self.iv_Avatar.layer.cornerRadius = 25
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

    }

}
