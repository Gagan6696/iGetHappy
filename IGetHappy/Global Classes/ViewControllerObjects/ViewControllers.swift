//
//  ViewControllers.swift
//  IGetHappy
//
//  Created by Gagan
//  Copyright © 2019 Seasia. All rights reserved.
//

import Foundation
import UIKit

enum NavigationType
{
    case root
    case push
    case present
    case pop
}


enum ViewControllers
{
    case StartUp
    case Login
    case Register
    case Forgot
    case AudioRecord
    case VideoRecord
    case WriteThoughts
    case Preview
    case Home
    case UserProfileSetupVC
    case SelectGender
    case StartBegin
    case LanguagePreference
    case BeCaregiver
    case AddCareReciever
    case ChatBot
    case SelectUserChatBot
    case TermsVC
    //SecondMileStone
    case AddHappyMemories
    case ChooseMood
    case UploadMemoriesMultiplePhotos
    case UploadMemoriesMultipleRecordedAudio
    case UploadMemoriesSelectMusic
    case UploadMemoriesSelectVideo
    case AudioRecordNav
    case Comment
    case ReplyOnComment
    case ReplyCommentVC
    case SharePost
    case AddActivityWithMood
    case JournelThoughts
    case MoodLogs
    case MoodLogAndStatBase
    case MyProfile
    
    case ReminderVC
    case MyVentsVC
    case CareReciverTabs
    case AllCareReceiverList
    case MoodStatistics
    //Meditation
    
    case MediationWelcome
    case MeditationSetGoal
    case MeditationHowItWorks
    case MeditationExploree
    case BreatheInhaleExhaleViewController
    case BreatheInhaleExhaleVCNavID
    case none
    
    //MoodLogs And Activites Screens
    
    var viewcontroller: UIViewController?{
        switch self {
        case .StartUp:
            return StoryBoards.Auth.instantiateViewController(withIdentifier: Constants.Login.Identifiers.KStartUpVC)
        case .TermsVC:
            return StoryBoards.Auth.instantiateViewController(withIdentifier: Constants.TermsVC.Identifiers.KTermsVC)
        case .Login:
            return StoryBoards.Auth.instantiateViewController(withIdentifier: Constants.Login.Identifiers.KLoginVC)
        case .VideoRecord:
            return StoryBoards.Auth.instantiateViewController(withIdentifier: Constants.VideoRecord.Identifiers.KVideoVC)
        case .AddCareReciever:
            return StoryBoards.Auth.instantiateViewController(withIdentifier: Constants.AddCareReciever.Identifiers.KAddCareRecieverVC)
        case .LanguagePreference:
            return StoryBoards.Auth.instantiateViewController(withIdentifier: Constants.LanguagePreference.Identifiers.KLanguagePreferenceVC)
        case .Preview:
            return StoryBoards.Auth.instantiateViewController(withIdentifier: Constants.PreviewVC.Identifiers.KPreview)
        case .WriteThoughts:
            return StoryBoards.Auth.instantiateViewController(withIdentifier: Constants.WriteThoughts.Identifiers.KWriteThoughtsVC)
        case .Register:
            return StoryBoards.Auth.instantiateViewController(withIdentifier: Constants.Register.Identifiers.KRegisterVC)
            
        case .Forgot:
            return StoryBoards.Auth.instantiateViewController(withIdentifier: Constants.Forgot.Identifiers.KForgotVC)
        case .BeCaregiver:
            return StoryBoards.Auth.instantiateViewController(withIdentifier: Constants.BeCaregiver.Identifiers.KBeCaregiverVC)
        case .AudioRecord:
            return StoryBoards.Auth.instantiateViewController(withIdentifier: RecordAudioVC.className)
        case .AudioRecordNav:
            return StoryBoards.Auth.instantiateViewController(withIdentifier: "AudioRecordNav")
        case .StartBegin:
            return StoryBoards.Auth.instantiateViewController(withIdentifier: Constants.StartBegin.Identifiers.KStartBeginVC)
        case .Home:
            return StoryBoards.Auth.instantiateViewController(withIdentifier: Constants.Home.Identifiers.KHomeVC)
        case .UserProfileSetupVC:
            return StoryBoards.Auth.instantiateViewController(withIdentifier: Constants.UserProfileSetup.Identifiers.KUserProfileSetupVC)
        case .SelectGender:
            return StoryBoards.Auth.instantiateViewController(withIdentifier: Constants.SelectGender.Identifiers.KSelectGenderVC)
        case .ChatBot:
            return StoryBoards.Auth.instantiateViewController(withIdentifier: Constants.ChatBot.Identifiers.KChatBotVC)
        case .SelectUserChatBot:
            return StoryBoards.Auth.instantiateViewController(withIdentifier: SelectUserChatBotVC.className)
            
        //SecondMilestone
        case .AddHappyMemories:
            return StoryBoards.HappyMemories.instantiateViewController(withIdentifier: Constants.AddHappyMemories.Identifiers.KAddHappyMemoriesVC)
        case .ChooseMood:
            return
            StoryBoards.Auth.instantiateViewController(withIdentifier: ChooseMoodVC.className)
            
        case .UploadMemoriesMultiplePhotos:
            return StoryBoards.HappyMemories.instantiateViewController(withIdentifier: Constants.UploadMemoriesMultiplePhotos.Identifiers.KUploadMemoriesMultiplePhotosVC)
        case .UploadMemoriesMultipleRecordedAudio:
            return StoryBoards.HappyMemories.instantiateViewController(withIdentifier: Constants.UploadMemoriesMultipleRecordedAudio.Identifiers.KUploadMemoriesMultipleRecordedAudioVC)
        case .UploadMemoriesSelectMusic:
            return StoryBoards.HappyMemories.instantiateViewController(withIdentifier: SelectMusicVC.className)
        case .UploadMemoriesSelectVideo:
            return StoryBoards.HappyMemories.instantiateViewController(withIdentifier: SelectVideoMemoriesVC.className)
        case .Comment:
            return StoryBoards.Community.instantiateViewController(withIdentifier: CommentViewController.className)
        case .ReplyOnComment:
            return StoryBoards.Community.instantiateViewController(withIdentifier: ReplyVC.className)
        case .SharePost:
            return StoryBoards.Community.instantiateViewController(withIdentifier: SharedPostVC.className)
        case .AddActivityWithMood:
            return StoryBoards.MoodLogs.instantiateViewController(withIdentifier: AddActivityWithMoodVC.className)
        case .JournelThoughts:
            return StoryBoards.MoodLogs.instantiateViewController(withIdentifier: JournelThoughtsVC.className)
        case .MoodLogs:
            return StoryBoards.SideBarOptions.instantiateViewController(withIdentifier: MoodLogsVC.className)
        case .MoodLogAndStatBase:
            return StoryBoards.SideBarOptions.instantiateViewController(withIdentifier: MoodLogAndStatBaseVC.className)
        case .MoodStatistics:
            return StoryBoards.SideBarOptions.instantiateViewController(withIdentifier: MoodStatisticsVC.className)
        case .MyProfile:
            return StoryBoards.SideBarOptions.instantiateViewController(withIdentifier: MyProfileVC.className)
            //Reminder
        case .CareReciverTabs:
            return StoryBoards.Main.instantiateViewController(withIdentifier: CareReceiverTabsVC.className)
        case .AllCareReceiverList:
            return StoryBoards.Main.instantiateViewController(withIdentifier: CareReceiverVC.className)
            
            
        //Mediattion
        case .MediationWelcome:
            return StoryBoards.Meditation.instantiateViewController(withIdentifier: MeditationWecomeVC.className)
        case .MeditationSetGoal:
            return StoryBoards.Meditation.instantiateViewController(withIdentifier: MeditationSetGoalVC.className)
        case .MeditationHowItWorks:
            return StoryBoards.Meditation.instantiateViewController(withIdentifier: MeditationHowItWorksVC.className)
        case .MeditationExploree:
            return StoryBoards.Meditation.instantiateViewController(withIdentifier: MeditationExplore.className)
        //Mood Logs And Activites Screens
            
        case .BreatheInhaleExhaleViewController:
            return StoryBoards.Meditation.instantiateViewController(withIdentifier: "BreatheInhaleExhaleViewController")
            
            
        case .MeditationExploree:
            return StoryBoards.MoodLogs.instantiateViewController(withIdentifier: AddActivityWithMoodVC.className)
            
        case .BreatheInhaleExhaleVCNavID:
            return StoryBoards.Meditation.instantiateViewController(withIdentifier: "BreatheInhaleExhaleVCNavID")
        
        case .ReminderVC:
            return StoryBoards.Main.instantiateViewController(withIdentifier: Constants.Reminder.Identifiers.KReminderVC)
            
        case .ReplyCommentVC:
            return StoryBoards.Community.instantiateViewController(withIdentifier: Constants.ReplyComment.Identifiers.KReplyVC)
            
        case .MyVentsVC:
            return StoryBoards.Main.instantiateViewController(withIdentifier: Constants.myVentsTab.Identifiers.KMyVentsTabVC)
            
        case .none:
            return nil
        }
        
    }
}
enum RootViewControllers
{
    case LoginNavigation
    
    case none
    
    var rootViewcontroller: UIViewController?{
        switch self {
        case .LoginNavigation:
            return StoryBoards.Auth.instantiateViewController(withIdentifier: Constants.NavigationsIdentifier.Identifiers.KLoginNavigation)
            
        case .none:
            return nil
        }
    }
}

struct StoryBoards {
    
    static var Main : UIStoryboard
    {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    static var Auth : UIStoryboard
    {
        return UIStoryboard(name: "Auth", bundle: nil)
    }
    static var HappyMemories : UIStoryboard
    {
        return UIStoryboard(name: "HappyMemories", bundle: nil)
    }
    static var Community : UIStoryboard
    {
        return UIStoryboard(name: "Community", bundle: nil)
    }
    static var Meditation : UIStoryboard
    {
        return UIStoryboard(name: "Meditation", bundle: nil)
    }
    static var MoodLogs : UIStoryboard
    {
        return UIStoryboard(name: "MoodLogs", bundle: nil)
    }
    static var SideBarOptions : UIStoryboard
    {
        return UIStoryboard(name: "SideBarOptions", bundle: nil)
    }
    
}
