//
//  ReminderVC_Extension.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 12/23/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation


extension RemindersVC
{
    //MARK: CREATE DAILY REMINDER NON RECURRING
    func CREATE_REMINDERS(identifier:String,desc:String,date:Date,time:Date)
    {
        KQNotification.shared.dailyNotification_without_repeating(identifier: identifier, title: "Daily Reminder", body: desc, date: date, time: time)
    }
    
    
    
    //MARK: CREATE DAILY REMINDER RECURRING
    func CREATE_REMINDERS_RECURRING(identifier:String,recurringType:String,dayCount:Int,alertTime:Date,prsnlMsg:String,isOnGoing:Bool)
    {
        if (recurringType == "Repeat Every Day")
        {
            KQNotification.shared.daily_Notification_with_repeating(identifier: identifier, title: "Reminder", body: prsnlMsg, date: alertTime)
        }
        else
        {
            KQNotification.shared.weekly_Notification_with_repeating(identifier: identifier, title: "Reminder", body: prsnlMsg, date: alertTime, weekDAY: dayCount)
        }
    }
    
    func CREATE_REMINDERS_FOR_START_END_DATE_RECURRING(identifier:String,alertTime:Date,prsnlMsg:String,fireDATE:Date)
    {
        KQNotification.shared.Add_notification_no_repeating(identifier: identifier, title: "Reminder", body: prsnlMsg, time: alertTime, fireDate: fireDATE)
    }
}
