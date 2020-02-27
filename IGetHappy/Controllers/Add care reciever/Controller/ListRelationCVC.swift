//
//  ListRelationCVC.swift
//  IGetHappy
//
//  Created by Gagan on 6/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class ListRelationCVC: UICollectionViewCell {
    @IBOutlet weak var lbl_Realtion: CustomUILabel!
    
    @IBOutlet weak var imgViewBackground: UIImageView!
    
    
    
    override func awakeFromNib() {
        
        lbl_Realtion.textColor = .black
        lbl_Realtion.layer.cornerRadius = lbl_Realtion.frame.height/2
        lbl_Realtion.layer.masksToBounds = true
        
        imgViewBackground.layer.cornerRadius = imgViewBackground.frame.height/2
        imgViewBackground.layer.masksToBounds = true
        
        //imgViewBackground.contentMode = .scaleAspectFit
    }
    
    func SetupView(item:String,isSelected:Bool)  {
        
        
        lbl_Realtion.text = item
        
        if isSelected == true {
            
            imgViewBackground.image = UIImage.init(named: "globalBackground")
           //cell.imgViewBackground.backgroundColor = UIColor.red
            //contentView.backgroundColor = .red
        }
        else
        {
            imgViewBackground.image  = UIImage()
            //lbl_Realtion.backgroundColor = .white
            //contentView.backgroundColor = .white
        }
        
    }
    
}
