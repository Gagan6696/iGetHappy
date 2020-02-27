//
//  CellClass_SetReminderTable.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 12/16/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class CellClass_SetReminderTable: UITableViewCell
{

    
    @IBOutlet weak var tf: UITextField!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSwitch: UISwitch!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(false, animated: animated)
    }

}
