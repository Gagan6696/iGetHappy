//
//  CellClass_SharePostVC.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/1/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class CellClass_SharePostVC: UITableViewCell
{
    
    //MARK: USER OUTLETS
    @IBOutlet weak var iv_user_image: UIImageView!
    @IBOutlet weak var lbl_user_name: UILabel!
    @IBOutlet weak var lbl_user_time: UILabel!
    
    
    @IBOutlet weak var view_shadow: RoundShadowView!
    
    //MARK: SHARED POST OUTLETS
    
    @IBOutlet weak var iv_shared_user_image: UIImageView!
    
    @IBOutlet weak var lbl_shared_user_name: UILabel!
    @IBOutlet weak var lbl_shared_user_time: UILabel!
    
    @IBOutlet weak var lbl_shared_user_desc: UILabel!
    @IBOutlet weak var iv_shared_postImage: UIImageView!
    
    @IBOutlet weak var btn_Support: UIButton!
    @IBOutlet weak var btn_Share: UIButton!
    @IBOutlet weak var btn_Comment: UIButton!
    @IBOutlet weak var btn_Dots: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.iv_user_image.layer.cornerRadius = 25
        self.iv_user_image.layer.masksToBounds = true
        
        self.iv_shared_user_image.layer.cornerRadius = 25
        self.iv_shared_user_image.layer.masksToBounds = true
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

    }

}
