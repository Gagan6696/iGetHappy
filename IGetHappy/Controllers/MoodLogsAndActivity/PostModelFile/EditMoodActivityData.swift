//
//  EditMoodActivityData.swift
//  IGetHappy
//
//  Created by Gagan on 11/4/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation


class EditMoodActivityData
{
    static let sharedInstance:EditMoodActivityData? = EditMoodActivityData()
    var moodTrack:String?
    var eventsActivity:String?
    var careReceiverId:String?
    var privacy_option:String?
    var description:String?
    var post_upload_type:String?
    var post_upload_file:URL?
    var user_id:String?
    var icon_name:String?
    var change_file_status:String?
    var evnt_id:String?

    
    private init()
    {
    }
    deinit
    {
        print("Dealloc")
    }
    func Reinitilize()
    {
        EditMoodActivityData.sharedInstance?.moodTrack = nil
        EditMoodActivityData.sharedInstance?.eventsActivity = nil
        EditMoodActivityData.sharedInstance?.careReceiverId = nil
        EditMoodActivityData.sharedInstance?.privacy_option = nil
        EditMoodActivityData.sharedInstance?.description = nil
        EditMoodActivityData.sharedInstance?.post_upload_type = nil
        EditMoodActivityData.sharedInstance?.post_upload_file = nil
        EditMoodActivityData.sharedInstance?.user_id = nil
        EditMoodActivityData.sharedInstance?.icon_name = ""
        EditMoodActivityData.sharedInstance?.change_file_status = ""
        
    }
}
