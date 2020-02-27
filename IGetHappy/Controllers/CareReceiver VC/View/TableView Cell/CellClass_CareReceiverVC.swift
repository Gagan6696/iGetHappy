//
//  CellClass_CareReceiverVC.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/4/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class CellClass_CareReceiverVC: UITableViewCell
{
    
    
    @IBOutlet weak var ivUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
