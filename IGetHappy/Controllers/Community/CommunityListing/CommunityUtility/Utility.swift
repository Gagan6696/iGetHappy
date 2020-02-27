//
//  Utility.swift
//  SamplePostApp
//  Created by Akash Dhiman on 7/22/19.
//  Copyright © 2019 Akash Dhiman. All rights reserved.
//

import UIKit
import Kingfisher
import FTPopOverMenu_Swift
import Reactions

protocol UtilityDelegate
{
    func emojiButtonTapped()
    func popUpMenuButtonTappedForMoodLogs(selectedIndex: Int)
    func popUpMenuButtonTapped(selectedIndex: Int, isEdit:Bool, isReportAbuse : Bool)
    func commentButtonTapped(selectedIndex:Int)
    func  shareButtonTapped(selectedIndex:Int)
    func replyButtonTapped(selectedIndex:[String:Any])
}

class Utility: NSObject
{
    
    //MARK:- Variables
    static var delegate: UtilityDelegate?
    
    
    static func calculateHeight(inString:String) -> CGFloat
    {
        let messageString = inString
        let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15.0)]
        
        let attributedString : NSAttributedString = NSAttributedString(string: messageString, attributes: attributes)
        
        let rect : CGRect = attributedString.boundingRect(with: CGSize(width: 222.0, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        let requredSize:CGRect = rect
        return requredSize.height
    }
    
    
    static func selectedIndexOfThePost(sender: UIButton?) -> Int?
    {
        var selectedIndex = Int()
        selectedIndex = (sender?.superview?.tag)!
        return selectedIndex
    }
    
    
    static func replyButtonTapped(selectedIndexDict:[String:Any]){
        delegate?.replyButtonTapped(selectedIndex: selectedIndexDict)
    }
    
    
    static func commentButtonTapped(selectedIndex:Int){
        delegate?.commentButtonTapped(selectedIndex: selectedIndex)
    }
    static func shareButtonTapped(selectedIndex:Int)
    {
        delegate?.shareButtonTapped(selectedIndex: selectedIndex)
    }
    static func setUserDetailOnPost(selectedData: Post?, userTitle: UILabel, userImage: UIImageView, postDescription: UILabel, postTimeStamp:UILabel)
    {

        if(selectedData?.postTimeStamp != nil)
        {
            
            let localDate = Utility.UTCToLocal(UTCDateString: selectedData?.postTimeStamp ?? "", format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
            postTimeStamp.text = Utility.dateConvertToISOString(string: localDate)
            
        }
        
      //self.dateFromISOString(string: selectedData?.postTimeStamp)
        
        if selectedData?.isAnonymous == "NO"
        {
            userTitle.text = selectedData?.userName
            self.loadImage(onImageView: userImage, imageURLString: selectedData?.shared_user_image ?? "", placeHolder: "community_listing_user")
        }
        else
        {
            if isSameUserID(selectedData: selectedData)
            {
//                userTitle.text = selectedData?.userName
                if let userName  = UserDefaults.standard.getFirstName(){
                    userTitle.text = userName
                }
                
                self.loadImage(onImageView: userImage, imageURLString: selectedData?.shared_user_image ?? "", placeHolder: "community_listing_user")
            }
            else
            {
                userTitle.text = "Anonymous"
                self.loadImage(onImageView: userImage, imageURLString: "", placeHolder: "community_listing_user")
            }
        }
        
        if selectedData?.isShared == 1{
             postTimeStamp.text = selectedData?.mood_track_time
            postDescription.text = selectedData?.post_description
        }else{
            if selectedData?.isMoodLog == 1{
                
                let localDate = Utility.UTCToLocal(UTCDateString: selectedData?.mood_track_time ?? "", format: "EEEE,ddMMM hh:mmaa")
                postTimeStamp.text = localDate
                
                
               // postTimeStamp.text =  Utility.UTCToLocal(UTCDateString: selectedData?.mood_track_time ?? "", format: <#String#>)
                // = selectedData?.mood_track_time
            }
            postDescription.text = selectedData?.postDescription
        }
       // postDescription.text = selectedData?.postDescription
    }
    
    
    // For change UTC date from server to local
    static func UTCToLocal(UTCDateString: String, format : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format //Input Format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let UTCDate = dateFormatter.date(from: UTCDateString)
        
        
        dateFormatter.dateFormat = format // Output Format
        dateFormatter.timeZone = TimeZone.current
        let UTCToCurrentFormat = dateFormatter.string(from: UTCDate!)
        return UTCToCurrentFormat
    }
    
    static func dateFromISOStringForCreatedAt(string: Date) -> String?
    {
//        let dateFormatter = DateFormatter()
//        //dateFormatter.locale = .defa
//        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//
//       // let dt = dateFormatter.date(from: string)
//        //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//       // dateFormatter.timeZone = TimeZone.autoupdatingCurrent
//        dateFormatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        print("\(dateFormatter.string(from: string.toLocalTime()))")
//        return dateFormatter.string(from: string.toGlobalTime())
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale.current
        let convertedDate = formatter.string(from: string)
        formatter.timeZone = TimeZone(identifier: "UTC")
        return convertedDate
        
        
        
    }
    
    static func dateConvertToISOString(string: String) -> String?
    {
        let dateFormatter = DateFormatter()
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let dt = dateFormatter.date(from: string)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        print("\(dateFormatter.string(from: dt?.toLocalTime() ?? Date()))")
        
        let date = Date()
        let calendar = Calendar.current
        let componentCurrent = calendar.dateComponents(in: .current, from: date.toLocalTime())
        componentCurrent.day
        componentCurrent.hour
        componentCurrent.minute
        let components = calendar.dateComponents([.month, .day, .year, .minute, .hour], from: (dt?.toLocalTime())!)
        let month = components.month
        let day = components.day
        let year = components.year
        let minute = components.minute
        let hour = components.hour

        if (componentCurrent.year == components.year){
            if(componentCurrent.month) == components.month{
                if componentCurrent.day == components.day{
                    if componentCurrent.hour == components.hour{
                        if componentCurrent.minute == components.minute{
                           
                            if componentCurrent.second == components.second{
                                
                                return "few seconds ago"
                                //return "\(second) seconds ago"
                            }else{
                                
                                if let seconds  = componentCurrent.second{
                                if(seconds ?? 0 <= 1){
                                    return "\(seconds) second ago"
                                }else{
                                    return "\(seconds) seconds ago"
                                }
                                }
                            }
                            //return "\(second) seconds ago"
                        }else{
                            
                            let minute  = componentCurrent.minute! - components.minute!
                            if(minute <= 1){
                                return "\(minute) minute ago"
                            }else{
                                return "\(minute) minutes ago"
                            }
                            
                        }
                    }else{
                        
                        let hour  = componentCurrent.hour! - components.hour!
                        if(hour <= 1){
                            return "\(hour) hour ago"
                        }else{
                            return "\(hour) hours ago"
                        }
                        
                    }
                }else{
                     let day  = componentCurrent.day! - components.day!
                    if(day <= 1){
                        return "\(day) day ago"
                    }else{
                        return "\(day) days ago"
                    }
                }
            }else{
                 let month  = componentCurrent.month! - components.month!
                if(month <= 1){
                    return "\(month) month ago"
                }else{
                    return "\(month) months ago"
                }
            }
        }else{
            //let ss = componentCurrent.year!
            let year  = componentCurrent.year! - components.year!
            if(year <= 1){
                return "\(year) year ago"
            }else{
                return "\(year) years ago"
            }
        }
        
        return dateFormatter.string(from: dt!)
        
    }

    static func isSameUserID(selectedData: Post?) -> Bool
    {
        return selectedData?.userId == UserDefaults.standard.getUserId()
    }
    
    static func setEmoji(selectedData: Post?) -> Reaction?
    {
        
        var type = selectedData?.emojiType
        
      //  if (selectedData?.isShared == 1)
      //  {/
           //type = selectedData?.post_liked_type
          //  type = selectedData?.post_liked
       // }
        
        
        //Set emoji or like status
        if type == Constants.Emoji.like
        {
            return Reaction.facebook.like
        }
        if type == Constants.Emoji.heart
        {
            return Reaction.facebook.love
        }
        if type == Constants.Emoji.haha
        {
            return Reaction.facebook.haha
        }
        if type == Constants.Emoji.wow
        {
            return Reaction.facebook.wow
        }
        if type == Constants.Emoji.sad
        {
            return Reaction.facebook.sad
        }
        if type == Constants.Emoji.angry
        {
            return Reaction.facebook.angry
        }
        return nil
    }
    
    static func loadImage(onImageView: UIImageView, imageURLString: String, placeHolder:String)
    {
        if imageURLString != ""
        {
            let url = URL(string: imageURLString )
            onImageView.kf.indicatorType = .activity
            onImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: placeHolder),
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            {
                result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }
        }else{
            onImageView.image = UIImage(named: "community_listing_user")
        }
    }
    
    static func showDropDownMenu(sender: UIButton, selectedData: Post?)
    {
        if self.isSameUserID(selectedData: selectedData)
        {
            
            if (selectedData?.isShared == 1)
            {
                FTPopOverMenu.showForSender(sender: sender,
                                            with: ["Delete"],
                                            menuImageArray: [],
                                            done: { (selected) -> () in
                                                switch selected {
                                                case 0:
                                                    delegate?.popUpMenuButtonTapped(selectedIndex: sender.tag, isEdit: false, isReportAbuse: false)
                                                    break
                                                default:
                                                    break
                                                }
                }) {
                    
                }
            }else if selectedData?.isMoodLog == 1{
                FTPopOverMenu.showForSender(sender: sender,
                                            with: ["Delete", "Edit"],
                                            menuImageArray: [],
                                            done: { (selected) -> () in
                                                switch selected {
                                                case 0:
                                                    delegate?.popUpMenuButtonTapped(selectedIndex: sender.tag, isEdit: false, isReportAbuse: false)
                                                    break
                                                case 1:
                                                    delegate?.popUpMenuButtonTappedForMoodLogs(selectedIndex: sender.tag)
                                                    break
                                                default:
                                                    break
                                                }
                }) {
                    
                }
            }else{
                FTPopOverMenu.showForSender(sender: sender,
                                            with: ["Delete", "Edit"],
                                            menuImageArray: [],
                                            done: { (selected) -> () in
                                                switch selected {
                                                case 0:
                                                    delegate?.popUpMenuButtonTapped(selectedIndex: sender.tag, isEdit: false, isReportAbuse: false)
                                                    break
                                                case 1:
                                                    delegate?.popUpMenuButtonTapped(selectedIndex: sender.tag, isEdit: true, isReportAbuse: false)
                                                    break
                                                default:
                                                    break
                                                }
                }) {
                    
                }
            }
            
          
        }
            
            
       // else if (selectedData?.isShared == 1)
//        {
//            FTPopOverMenu.showForSender(sender: sender,
//                                        with: ["Delete"],
//                                        menuImageArray: [],
//                                        done: { (selected) -> () in
//                                            switch selected {
//                                            case 0:
//                                                delegate?.popUpMenuButtonTapped(selectedIndex: sender.tag, isEdit: false, isReportAbuse: false)
//                                                break
//                                            default:
//                                                break
//                                            }
//            }) {
//
//            }
//        }
            
        else
        {
            FTPopOverMenu.showForSender(sender: sender,
                                       with: ["Report Abuse",],
                                       menuImageArray: [],
                                       done: { (selected) -> () in
                                        switch selected {
                                        case 0:
                                            delegate?.popUpMenuButtonTapped(selectedIndex: sender.tag, isEdit: false, isReportAbuse: true)
                                            break
                                    
                                        default:
                                            break
                                        }
            }) {
                
            }
        }
    }
    
    static func likePost(postID: String, likeType: String,isMoodLog:Int)
    {
        var parameters = [:] as [String : String]
        
        if isMoodLog == 1{
            parameters["check"] = "moodLog"
            parameters["mood_log_id"] = postID
        }else{
            parameters["check"] = "post"
            parameters["post_id"] = postID
        }
        
      //  parameters["post_id"] = postID
        parameters["user_id"] = UserDefaults.standard.getUserId()
        parameters["like_type"] = likeType.uppercased()
        CommunityViewModel.likePostService(params: parameters as [String : AnyObject]) { (success, error) in
            if success
            {
                delegate?.emojiButtonTapped()
            }
        }
    }
}
