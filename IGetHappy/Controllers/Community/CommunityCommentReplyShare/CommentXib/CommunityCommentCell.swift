//
//  CommunityCommentCell.swift
//  IGetHappy
//
//  Created by Gagan on 9/24/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
@objc protocol CommentCellDelegate {
    @objc optional func commentButtonClicked(index: Int)
}
class CommunityCommentCell: UITableViewCell{
    
    //MARK:- IBOutlets
    var  delegate: AnyObject?
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblProfileName: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var btnReply: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.setRounded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
 
    @IBAction func actionReply(_ sender: UIButton) {
        print(delegate)
        
        delegate?.commentButtonClicked(index: sender.tag)
        print("Next screen reply calling....")
    }
}
