//
//  SelectMusicTableViewCell.swift
//  IGetHappy
//
//  Created by Prabhjot Singh on 05/11/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class SelectMusicTableViewCell: UITableViewCell {

    
    @IBOutlet weak var musicNameLabel: UILabel!
    @IBOutlet weak var musicSelectionButton: UIButton!
    @IBOutlet weak var playMusicButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
