//
//  AddActivityPresenter.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/7/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation


class AddActivityPresenter
{
    
    
    func get_emoji_offline()
    {
        CoreData_Model.get_offline_saved_emoji(success: { (data) in
            print(data)
            
        })
        { (error) in
            print(error)
        }
    }
    
    
    func update_emoji_offline(imageName:String,feel:String,indx:Int,iconName:String)
    {
        
        let dic = NSMutableDictionary()
        let currentDate = CommonVc.AllFunctions.getCurrentDate_InString()
        let user = UserDefaults.standard.getUserId()
        
        dic.setValue(iconName, forKey: coreDataKeys_SavedEmoji.icon_name)
        dic.setValue(imageName, forKey: coreDataKeys_SavedEmoji.image_name)
        dic.setValue(currentDate, forKey: coreDataKeys_SavedEmoji.date)
        dic.setValue(indx, forKey: coreDataKeys_SavedEmoji.index)
        dic.setValue(feel, forKey: coreDataKeys_SavedEmoji.mood_name)
        dic.setValue("0", forKey: coreDataKeys_SavedEmoji.is_posted)
        dic.setValue(user, forKey: coreDataKeys_SavedEmoji.user_id)
        
        let dic2 : NSDictionary = dic
        
        CoreData_Model.update_emoji_offline_in_coreData(data_for_save: dic2, success:
            { (result) in
                
                // print(result)
                
        }) { (error) in
            
            // print(error)
        }
    }
}
