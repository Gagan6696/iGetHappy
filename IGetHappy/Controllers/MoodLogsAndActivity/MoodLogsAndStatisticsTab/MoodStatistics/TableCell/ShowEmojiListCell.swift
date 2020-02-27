//
//  ShowEmojiListCell.swift
//  IGetHappy
//
//  Created by Gagan on 12/17/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class ShowEmojiListCell: UITableViewCell {

    @IBOutlet weak var lblEmojiNameList: UILabel!
    @IBOutlet weak var imgViewListEmoji: UIImageView!
    
    @IBOutlet weak var btnSelectEmoji: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
