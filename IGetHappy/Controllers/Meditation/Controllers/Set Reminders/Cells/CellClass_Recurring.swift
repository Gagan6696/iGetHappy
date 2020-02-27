//
//  CellClass_Recurring.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 12/19/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class CellClass_Recurring: UITableViewCell
{
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ivSeleced: UIImageView!
    

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }

}
