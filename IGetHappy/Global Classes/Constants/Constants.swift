//
//  Constants.swift
//  IGetHappy
//
//  Created by Gagan on 5/9/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
import UIKit

//Global Strings
class Constants: NSObject
{
    
    static let sharedInstance = Constants()
    static var isFromHappyMemories = Bool()
    static var pleaseTrackMood = Bool()
    struct  Global
    {
        
        struct ConstantStrings
        {
            static let KappDelegate = UIApplication.shared.delegate as! AppDelegate
            static let KOK =  "OK"
            static let KCancel  = "Cancel"
            static let KAppname = "iGetHappy"
            static let kChoosePhoto = "Choose Photo"
            static let kCamera = "Camera"
            static let kGallery = "Gallery"
            static let kOpenSettings = "OpenSettings"
            static let KMsgCameraPermission = "Select settings for camera"
            static let KDatabase_Offline_Emoji = "Offline_Emoji"
            static let KDatabase_Happy_Memories = "Happy_Memories"
            static let KDatabase_MoodLog_Events = "MoodLog_Events"
            static let KDatabase_Happy_Memories_Gallery = "Happy_Memories_Gallery"
            static let KDatabase_Happy_Memories_Changes = "Happy_Memories_Changes"
            static let KDatabase_Reminders = "Reminders"
            
            static let KImages_saved_offline = "Internet is not available. Your Memories is saved offline. They will automaticlly upload to the server whenever you will open this screen again!"
            static let KSorry_Error_occured = "Oops!, error occurred while updating database."
            
            
            static let KSaved = "Saved"
            static let KError = "Error"
            static let KNotSaved = "Could not save."
            static let KDeleted = "Deleted Successfully"
            static let KEntityNotFound = "Sorry Entity Not Found!"
            static let KDoYouWantDelete = "Do you want to delete this?"
            

        }
        
        struct MessagesStrings {
            static let ServerError = "Server Error"
            static let NoConnection = "No Internet Connection"
            static let ComingSoon = "Coming Soon"
             static let SomethingWentWrong = "Something Went Wrong, please try after sometime"
        }

    }
    
    struct TermsVC{
        struct Identifiers {
            static  let KTermsVC = "TermsVC"
            
        }
        
        struct MessagesStrings {
            
        }
        
        struct Validations{
            
        }
    }
    
    
    struct BeCaregiver{
        struct Identifiers {
            static  let KBeCaregiverVC = "BeCaregiverVC"
            
        }
        
        struct MessagesStrings {
            
        }
        
        struct Validations{
            
        }
    }
    
    
    struct AudioRecord{
        struct Identifiers {
            static  let KAudioVC = "RecordAudioVC"
            
        }
        
        struct MessagesStrings {
            
        }
        
        struct Validations{
            
        }
        
        
    }
    
    struct AddCareReciever{
        struct Identifiers {
            static  let KAddCareRecieverVC = "AddCareRecieverVC"
            
            
        }
        
        struct MessagesStrings {
            
        }
        
        struct Validations{
            static  let KEmptyName = "Please enter Care Reciever name"
            static  let KMinLengthName = "Your care receiver name length should be greater than 3 and less than 20"
            static  let KEmptyPhoneNumber = "Please enter your Phone Number"
            static  let KMinLengthPhoneNumber = "Your phone number should be 10 character long."
            static  let KEmptyEmail = "Please enter Email ID"
            static  let KWrongEmail = "please enter valid Email ID"
            static  let KMinLengthEmail = "Your email length is minimum."
            static  let KInvalidPhoneNum = "Please enter valid Phone Number."
        }
        
        
    }
    
    
    
    struct LanguagePreference{
        struct Identifiers {
            static  let KLanguagePreferenceVC = "LanguagePreferenceVC"
            
        }
        
        struct MessagesStrings {
            
        }
        
        struct Validations{
            static  let KSelectLanguage = "Please select atleast one language"
        }
    }
    
    
    struct UserProfileSetup{
        struct Identifiers {
            static  let KUserProfileSetupVC = "UserProfileSetupVC"
            
        }
        
        struct MessagesStrings {
            
        }
        
        struct Validations{
            static let kemptyFirstName = "Please enter First name"
            static let kemptyLastName = "Please enter Last name"
            static let kemptyNickName = "Please enter Nick name"
            static let kemptyProfilePhoto = "Please select Profile Photo"
            static let kemptyProfession = "Please select Profession"
            static let kminLengthFirst = "Your first name length should be greater than three"
            static let kminLengthLast = "Your last name length should be greater than three"
            static let kminLengthNick = "Your nick name length should be greater than three"
        }
    }
    struct StartBegin{
        struct Identifiers {
            static  let KStartBeginVC = "StartBeginVC"
            
        }
        
        struct MessagesStrings {
            
        }
        
        struct Validations{
            
        }
        
    }
    
    struct SelectGender{
        struct Identifiers {
            static  let KSelectGenderVC = "SelectGenderVC"
            
        }
        
        struct MessagesStrings {
            
        }
        
        struct Validations{
            static let kselectGender = "Please select your Gender"
            static let kselectDOB = "Please select your Date of Birth"
            
        }
        
        
    }
    struct VideoRecord{
        struct Identifiers {
            static  let KVideoVC = "addVideoVC"
            
        }
        
        struct MessagesStrings {
            
        }
        
        struct Validations
        {
            
        }
        
        
    }
    
    
    struct WriteThoughts{
        struct Identifiers {
            static  let KWriteThoughtsVC = "WriteThoughtsVC"
            
        }
        
        struct MessagesStrings {
            
        }
        
        struct Validations
        {
            static  let KEmptyText = "Please Enter Some Thoughts Before Post."
            static  let KEmptyPrivacy = "Please select privacy for your post"
            static  let KEmptyisAnonymous = "Please select isAnonymous feature "
            static  let KMaxtextLength = "You can enter text Upto 100 characters"
        }
        
    }
    struct PreviewVC{
        struct Identifiers {
            static  let KPreview = "PreviewVC"
            
        }
        
        struct MessagesStrings {
            
        }
        
        struct Validations
        {
            
        }
        
        
    }
    struct Login
    {
        struct Identifiers {
            static  let KLoginVC = "LoginVC"
            static let KStartUpVC  = "StartUpVC"
            
        }
        
        struct MessagesStrings {
            
        }
        
        struct Validations
        {
            static let kemptyUserName = "Please enter Email ID / Phone Number"
            static let kemptypassword = "Please enter Password"
            static let kweakPassword = "Your Password should contain one numeric, one special character, one upper & lower case character"
            static let kminLength  = "Password should be minimum 8 characters"
            static let kemailMinLength  = "Email should be less than 50 characters"
            static let kinvalidEmail = "Please enter valid Email ID"
            static let kinvalidPhone = "Please enter valid Phone Number"
            static let kinvalidEmailPhone = "Please enter valid Phone Number and Email"
            static let kMinLengthPhone = "Phone Number should be 10 character long"
        }
        
        
    }
    struct Home{
        
        struct Identifiers {
            static  let KHomeVC = "HomeVC"
            
        }
        
        struct MessagesStrings {
            
        }
        
        struct Validations{
            
        }
    }
    struct ChatBot{
        
        struct Identifiers {
            static  let KChatBotVC = "ChatBotVC"
            
        }
        
        struct MessagesStrings {
            
        }
        
        struct Validations{
            
        }
    }
    
    struct Register {
        struct Identifiers{
            static let KRegisterVC = "RegisterVC"
            
        }
        
        struct MessagesStrings{
            static let KTermsCheked = "Please agree to the Terms and Conditions"
        }
        struct Validations{
            
            static let kemptyEmailAndPHone = "Please enter EmailID/PhoneNumber"
            static let kemptyEmailId = "Please enter Email ID"
            static let kemptyPhoneNumber = "Please enter Phone Number"
            static let kemptypassword = "Please enter Password"
            static let kweakPassword = "Your Password should contain one numeric, one special character, one upper & lower case character"
            static let kminLength  = "Password should be minimum 8 characters"
            static let kwrongPhoneNumber = "Phone number is invalid"
            static let kminLengthPhoneNumber  = "Please enter valid Phone Number"
            static let kemailMinLength  = "Email should be less than 50 characters"
            static let kinvalidEmail = "Please enter valid Email ID"
            static let kinvalidPhone = "Please enter valid Phone Number"
        }
        
    }
    struct Forgot {
        struct Identifiers {
            static let KForgotVC = "ForgotVC"
            
        }
        
        struct MessagesStrings {
            
        }
        struct Validations
        {
            static let kemptyEmail = "Please enter Email ID"
            
            static let kemptyPhone = "Please enter Phone Number"
            static let kminLengthPhone = "Phone Number should be 10 characters long"
            static let kemailMinLength  = "Email should be less than 50 characters"
            static let kinvalidEmail = "Please enter valid Email ID"
            static let kinvalidPhone = "Please enter valid Phone Number"
            
        }
        
    }
    //Second MileStone
    struct AddHappyMemories {
        struct Identifiers {
            static let KAddHappyMemoriesVC = "AddHappyMemoriesVC"
        }
        struct MessagesStrings {
        }
        struct Validations{
        }
    }
    
    struct UploadMemoriesMultiplePhotos {
        struct Identifiers {
            static let KUploadMemoriesMultiplePhotosVC = "AddPhotosMemories"
        }
        struct MessagesStrings {
        }
        struct Validations{
        }
    }
    struct UploadMemoriesMultipleRecordedAudio {
        struct Identifiers {
            static let KUploadMemoriesMultipleRecordedAudioVC = "RecordAudioMemories"
        }
        struct MessagesStrings {
        }
        struct Validations{
        }
    }
    struct Comment {
        struct Identifiers {
            static let KCommentVC = "CommentVC"
        }
        struct MessagesStrings {
        }
        struct Validations{
        }
    }
    struct Reply {
        
        struct MessagesStrings {
        }
        struct Validations{
        }
    }
    
    struct Reminder
    {
        struct Identifiers
        {
            static let KReminderVC = "RemindersVC"
        }
        struct MessagesString
        {
            
        }
        struct Validations
        {
            
        }
    }
    
    struct ReplyComment
    {
        struct Identifiers
        {
            static let KReplyVC = "ReplyViewController"
        }
        struct MessagesString
        {
            
        }
        struct Validations
        {
            
        }
    }
    
    struct myVentsTab
    {
        struct Identifiers
        {
            static let KMyVentsTabVC = "MyVentsTabVC"
        }
        
    }
    struct AboutTab {
       
        struct MessagesStrings {
           
             static let kupdatedSuccesfully = " Profile updated successfully"
        }
        struct Validations
        {
            static let kemptyFirstName = "Please enter first name"
            static let kemptyRelationship = "Please select relationship"
            static let kemptyEmail = "Please enter email"
            static let kemailMinLength  = "Email should be less than 50 characters"
            static let kinvalidEmail = "Please enter valid Email ID"
            
        }
        
    }
    struct StoryBoard {
        struct Identifiers {
            static let KAuth = "Auth"
            static let KMain = "Main"
            
        }
        
        struct MessagesStrings {
            
        }
        
    }
    
    struct Singleton {
        struct Objects {
            static let KCommonFunctions = CommonFunctions.sharedInstance
            
        }
        
        struct MessagesStrings {
            
        }
        
    }
    
    struct  NavigationsIdentifier {
        struct Identifiers {
            static let KLoginNavigation = "StartUpVC"
            static let kChatRoomNavigation = "ChatRoomNavigation"
            
        }
        
        struct MessagesStrings {
            
        }
        
    }
    
    struct Emoji {
        static let like = "LIKE"
        static let heart = "HEART"
        static let haha = "HAHA"
        static let wow = "WOW"
        static let sad = "SAD"
        static let angry = "ANGRY"
    }
    
    struct PostType
    {
        static let audio = "AUDIO"
        static let video = "VIDEO"
        static let text = "TEXT"
        static let shared = "SHARED"
        static let image = "IMAGE"
    }
    
}


struct defaultKeys
{
    static let userID = "userID"
    static let userName = "userName"
    static let userImage = "userImage"
    static let userEmail = "userEmail"
    static let userDeviceToken = "userDeviceToken"
    static let userAuthToken = "userAuthToken"
    static let userDOB = "userDOB"
    static let userHomeAddress = "userHomeAddress"
    static let appColor_Name = "appColor_Name"
    static let Emoji_CurrentPage = "Emoji_CurrentPage"
    static let stored_happyMemories_array = "stored_happyMemories_array"
    
    
}


struct coreDataKeys_SavedEmoji
{
    static let date = "date"
    static let image_name = "image_name"
    static let index = "index"
    static let mood_name = "mood_name"
    static let Entity_Emoji = "Offline_Emoji"
    static let table_id = "table_id"
    static let is_posted = "is_posted"
    static let user_id = "user_id"
    static let mood_id = "mood_id"
    static let icon_name = "icon_name"
    
    static let current_time = "current_time"
    
}

struct coreDataKeys_HappyMemories
{
    static let name = "name"
    static let type = "type"
    static let user_id = "user_id"
    static let table_id = "table_id"
    static let asset = "asset"
    static let url = "url"
    static let phasst = "phasst"
    static let location = "location"
    static let is_offline = "is_offline"
    static let is_downloaded = "is_downloaded"
    static let unique_id = "unique_id"
    static let file_URI = "file_URI"
    
}

struct coreDataKeys_HappyMemories_Changes
{
    static let audio_path = "audio_path"
    static let image_data = "image_data"
    static let type = "type"
    static let user_id = "user_id"
    static let video_path = "video_path"
    static let group = "group"
    static let location = "location"
    static let desc = "desc"
}

struct coreDataKeys_MoodLog_Events
{
    static let user_id = "user_id"
    static let table_id = "table_id"
    static let privacy = "privacy"
    static let desc = "desc"
    static let location = "location"
    static let mood_index = "mood_index"
  //  static let icon_name = "icon_name"
    static let change_file_status = "change_file_status"
    static let event_id = "event_id"
    
    
    
    
    static let date = "date"
    static let image_name = "image_name"
    static let mood_name = "mood_name"
    static let Entity_MoodLogs = "MoodLog_Events"
    static let is_posted = "is_posted"
    static let care_rcvr_id = "care_rcvr_id"
    static let video_path = "video_path"
    static let audio_path = "audio_path"
    static let upload_type = "upload_type"
    
    static let file_name_audio = "file_name_audio"
    static let file_name_video = "file_name_video"
    static let events_activity = "events_activity"
    
}

struct coreDataKeys_Reminders
{
    static let complete_date = "complete_date"
    static let desc = "desc"
    static let state = "state"
    static let table_id = "table_id"
    static let title = "title"
    static let trigger_date = "trigger_date"
    static let trigger_time = "trigger_time"
    static let type = "type"
    static let user_id = "user_id"
    static let identifier = "identifier"
    
    static let notification_ids = "notification_ids"
    static let total_dates = "total_dates"
    static let day_for_recurring = "day_for_recurring"
    static let recurring_approach = "recurring_approach"
    
    static let text_info = "text_info"
    
    
}

struct reminderKeys
{
    static let daily_Reminder_Indentifier = "dailyReminder"
}



