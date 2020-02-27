//
//  CellClassMyVentsPrivate.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class CellClassMyVentsPrivate: UITableViewCell
{

    @IBOutlet weak var view_BG: CustomUIView!
    @IBOutlet weak var iv_User: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPrivacy: UILabel!
    @IBOutlet weak var ivOPrivacy: UIImageView!
    @IBOutlet weak var lblDesc: UILabel!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
        self.view_BG.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
