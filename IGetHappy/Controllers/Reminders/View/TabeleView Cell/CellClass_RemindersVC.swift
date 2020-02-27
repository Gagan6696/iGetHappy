//
//  CellClass_RemindersVC.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/4/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class CellClass_RemindersVC: UITableViewCell
{
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnSwitch: UISwitch!
    

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
