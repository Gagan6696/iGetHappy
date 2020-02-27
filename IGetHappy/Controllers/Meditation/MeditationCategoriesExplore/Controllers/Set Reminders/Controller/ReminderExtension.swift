//
//  ReminderExtension.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 12/17/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import FSCalendar
import UserNotifications


extension SetRemindersVC : FSCalendarDelegate,FSCalendarDataSource,UNUserNotificationCenterDelegate
{
    
    //MARK: SETUP CALENDER FUNCTION
    func setup_calender()
    {
        self.view_Calender.delegate = self
        self.view_Calender.dataSource = self
        self.view_Calender.allowsMultipleSelection = true
        
        for d in self.view_Calender.selectedDates
        {
            self.view_Calender.deselect(d)
        }
        
        self.setup_ongoing_Calender()
    }
    
    func setup_ongoing_Calender()
    {
        //Ongoing
        self.view_Calender_Ongoing.delegate = self
        self.view_Calender_Ongoing.dataSource = self
        self.view_Calender_Ongoing.allowsMultipleSelection = true
        
        self.tf_recurringStartDate.text = ""
        self.tf_recurringEndDate.text = ""
        
        for d in self.view_Calender_Ongoing.selectedDates
        {
            self.view_Calender_Ongoing.deselect(d)
        }
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date
    {
        if (calendar == self.view_Calender_Ongoing)
        {
            if (firstDate != nil)
            {
                return firstDate ?? Date()
            }
            else
            {
               return Date()
            }
        }
        return Date()
    }
    
    
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        

        if (self.selectedApproach == "Daily" || self.selectedApproach == "Ongoing")
        {
            
            
            
            // nothing selected:
            if firstDate == nil
            {
                firstDate = date
                datesRange = [firstDate!]
                if (self.selectedApproach == "Ongoing")// ONGOING Start Date and End Date Handling
                {
                    let sdate = CommonVc.AllFunctions.return_string_from_date(myDate: date)
                    self.tf_recurringStartDate.text = sdate
                    self.view_Calender_Ongoing.isHidden = true
                }
                
                return
            }
            
            // only first date is selected:
            if firstDate != nil && lastDate == nil
            {
                // handle the case of if the last date is less than the first date:
                if date <= firstDate!
                {
                    calendar.deselect(firstDate!)
                    firstDate = date
                    datesRange = [firstDate!]
                    
                    return
                }
                
                let range = datesRange(from: firstDate!, to: date)
                lastDate = range.last
                
                for d in range
                {
                    calendar.select(d)
                }
                
                if (self.selectedApproach == "Ongoing")// ONGOING Start Date and End Date Handling
                {
                    // getting dates between Start Date and Date
                    let edate = CommonVc.AllFunctions.return_string_from_date(myDate: date)
                    self.tf_recurringEndDate.text = edate
                    self.view_Calender_Ongoing.isHidden = true
                    datesRange = range
                }
                else
                {
                    if(range.count > Singleton.shared().totalDays)
                    {
                        datesRange.removeAll()
                        for d in calendar.selectedDates
                        {
                            calendar.deselect(d)
                        }
                        self.view_Calender.reloadData()
                        CommonVc.AllFunctions.showAlert(message: "You can not select days more than \(String(describing: Singleton.shared().setGoalDays))", view: self,  title:Constants.Global.ConstantStrings.KAppname)
                    }
                    else
                    {
                        datesRange = range
                        self.view_Calender.reloadData()
                    }
                }
                
                return
            }
            
            // both are selected:
            if firstDate != nil && lastDate != nil
            {
                for d in calendar.selectedDates
                {
                    calendar.deselect(d)
                }
                
                lastDate = nil
                firstDate = nil
                datesRange = []
                
                if (self.selectedApproach == "Ongoing")// ONGOING Start Date and End Date Handling
                {
                    self.tf_recurringEndDate.text = ""
                    self.tf_recurringStartDate.text = ""
                }
                
            }
            
        }
        else
        {
            if(self.datesRange.count >= Singleton.shared().totalDays)
            {
                let sd = calendar.selectedDates.last
                calendar.deselect(sd ?? Date())
                self.view_Calender.reloadData()
                CommonVc.AllFunctions.showAlert(message: "You can not select days more than \(String(describing: Singleton.shared().setGoalDays))", view: self,  title:Constants.Global.ConstantStrings.KAppname)
            }
            else
            {
                datesRange.append(date)
                self.view_Calender.reloadData()
            }
        }
    }
    
    
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        
        if (self.selectedApproach == "Daily" || self.selectedApproach == "Ongoing")
        {
            
            // NOTE: the is a REDUANDENT CODE:
            if firstDate != nil && lastDate != nil
            {
                for d in calendar.selectedDates
                {
                    calendar.deselect(d)
                }
                
                lastDate = nil
                firstDate = nil
                
                datesRange = []
                
                if (self.selectedApproach == "Ongoing")// ONGOING Start Date and End Date Handling
                {
                    self.tf_recurringEndDate.text = ""
                    self.tf_recurringStartDate.text = ""
                    self.view_Calender_Ongoing.isHidden = true
                }
                
            }
        }
        else
        {
            if (self.datesRange.count > 0)
            {
                for i in 0...self.datesRange.count-1
                {
                    let sdate = self.datesRange[i]
                    
                    if (sdate == date)
                    {
                        self.datesRange.remove(at: i)
                        break
                    }
                }
            }
            else
            {
                self.datesRange.removeAll()
            }
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor?
    {
        
        if datesRange.contains(date)
        {
            return UIColor.blue
        }
        else
        {
            return appearance.selectionColor
        }
        
        
    }
    
    //    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor?
    //    {
    //        if datesRange?.contains(date) ?? false
    //        {
    //            return UIColor.blue
    //        }
    //        else
    //        {
    //            return UIColor.clear
    //        }
    //    }
    
    
    func datesRange(from: Date, to: Date) -> [Date]
    {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }
        
        var tempDate = from
        var array = [tempDate]
        
        while tempDate < to
        {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        
        return array
    }
    
    
    //MARK: DATE PICKER SETUP Reminders
    func showDatePicker()
    {
        //Formate Date
        datePicker.datePickerMode = .time
        // datePicker.maximumDate = Date()
         datePicker.minimumDate = Date()
       // datePicker.minuteInterval = 5
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        
        self.tfSelectTime.inputAccessoryView = toolbar
        self.tfSelectTime.inputView = datePicker
        
    }
    
    //MARK: DATE PICKER SETUP Reminders
    func showDatePicker_recurring_alertTime()
    {
        //Formate Date
        datePicker.datePickerMode = .time
        datePicker.minimumDate = Date()
       // datePicker.minuteInterval = 5
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker_recurring_alertTime));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        
        self.tf_alertTime_recurring.inputAccessoryView = toolbar
        self.tf_alertTime_recurring.inputView = datePicker
        
    }
    
    
    //MARK: DATE PICKER SETUP START DATE
/*    func showDatePicker_recurring_startDate(sourceView:UITextField)
    {
        //Formate Date
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        // datePicker.minuteInterval = 5
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker_recurring_startDate));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        
        sourceView.inputAccessoryView = toolbar
        sourceView.inputView = datePicker
        
    }  */
    
    //MARK: DATE PICKER SETUP END DATE
 /*   func showDatePicker_recurring_endDate(sourceView:UITextField)
    {
        //Formate Date
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        //  datePicker.minuteInterval = 5
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker_recurring_endDate));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        
        sourceView.inputAccessoryView = toolbar
        sourceView.inputView = datePicker
        
    } */
    
    
    //MARK: DATE PICKER DONE BUTTON
    @objc func donedatePicker()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        self.tfSelectTime.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        self.myTableView.reloadData()
    }
    
    //MARK: DATE PICKER DONE BUTTON
    @objc func donedatePicker_recurring_alertTime()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        self.tf_alertTime_recurring.text = formatter.string(from: datePicker.date)
        self.alertTime_recurring = datePicker.date
        self.view.endEditing(true)
    }
    
    
    //MARK: DATE PICKER DONE BUTTON
/*     @objc func donedatePicker_recurring_startDate()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm a"
        self.tf_recurringStartDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func donedatePicker_recurring_endDate()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm a"
        self.last_date_not_ongoing = datePicker.date
        self.tf_recurringEndDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }  */
    
    //MARK: DATE PICKER CANCEL BUTTON
    @objc func cancelDatePicker()
    {
        self.view.endEditing(true)
    }
    
    
    
    func HANDLE_ADD_REMINDER_ACTION()
    {
        if (self.tfSelectTime.text == "Select Time")
        {
            CommonVc.AllFunctions.showAlert(message: "Please click on Select Button and choose your reminder time.", view: self,  title:Constants.Global.ConstantStrings.KAppname)
        }
        else if (self.tf_Desc.text == "")
        {
            CommonVc.AllFunctions.showAlert(message: "Please add some words to remind you on Alert.", view: self,  title:Constants.Global.ConstantStrings.KAppname)
        }
        else
        {
            self.CREATE_REMINDERS()
        }
    }
    
    
    
    //MARK: CREATE DAILY REMINDER NON RECURRING
    func CREATE_REMINDERS()
    {
        
        
        self.tableID = CommonVc.AllFunctions.generateRandomString()//I am adding random string for Unique notification identifier
        
        //Convert Date array into string
        if (self.datesRange.count > 0)
        {
            let strDateArr = CommonVc.AllFunctions.convert_date_array_into_string_array(dateArr:self.datesRange)
            let totalDates = (strDateArr.map{String($0)}).joined(separator: ",")
            
            //  print(totalDates as Any)
            
            var notificn_idArr = [String]()
            
            
            for i in 0...self.datesRange.count-1
            {
                let f = self.datesRange[i]
               let date  = f.toLocalTime()
                var identifier = strDateArr[i]
                
                identifier = "\(identifier)_\(self.tableID)"
                notificn_idArr.append(identifier)
                
                if (self.btnSwitch.isOn == true)
                {
                    
                    KQNotification.shared.dailyNotification_without_repeating(identifier: identifier, title: "Daily Reminder", body: self.tf_Desc.text!, date: date, time: datePicker.date)
                }
                
            }
            
            let notification_ids = (notificn_idArr.map{String($0)}).joined(separator: ",")
            
            self.SAVE_DAILY_REMINDER_IN_DATABASE(tbID: self.tableID, idArray: notification_ids, reminderType: "\(self.selectedApproach) Reminder", totalDates: totalDates)
            
        }
        
    }
    
    
    
    //MARK: CREATE DAILY REMINDER RECURRING
    func CREATE_REMINDERS_RECURRING(recurringType:String,dayCount:Int,alertTime:Date,prsnlMsg:String,isOnGoing:Bool)
    {
        
        self.tableID = CommonVc.AllFunctions.generateRandomString()//I am adding random string for Unique notification identifier
        let identifier = "\(recurringType)_\(self.tableID)"
        
        if (recurringType == "Repeat Every Day")
        {
            KQNotification.shared.daily_Notification_with_repeating(identifier: identifier, title: "Reminder", body: prsnlMsg, date: alertTime)
        }
        else
        {
            KQNotification.shared.weekly_Notification_with_repeating(identifier: identifier, title: "Reminder", body: prsnlMsg, date: alertTime, weekDAY: dayCount)
        }
        
        self.SAVE_RECURRING_REMINDER_IN_DATABASE(tbID: self.tableID, reminderType: "Recurring", notif_id: identifier, recurringDay: dayCount,recurring_approach:recurringType)
    }
    
    
    //MARK: CREATE RECURRING REMINDER WITH START END DATE
    func CREATE_REMINDERS_RECURRING_with_START_END_DATE(recurringType:String,dayCount:Int,alertTime:Date,prsnlMsg:String,isOnGoing:Bool)
    {
        
        self.tableID = CommonVc.AllFunctions.generateRandomString()//I am adding random string for Unique notification identifier
        
        var strDateArr = [String]()
        var filterDates = [Date]()
        
        if (recurringType == "Repeat Every Day")
        {
           // filterDates = self.datesRange//no need to filter date here
            filterDates = CommonVc.AllFunctions.formatize_date_arr(dateArr:self.datesRange)
            strDateArr = CommonVc.AllFunctions.convert_date_array_into_string_array(dateArr:self.datesRange)
        }
        else
        {
            //filter date array according to week
            filterDates = CommonVc.AllFunctions.filter_date_array_with_weekDays(dateArr:self.datesRange,weekDay:dayCount)
            strDateArr = CommonVc.AllFunctions.convert_date_array_into_string_array(dateArr:filterDates)
        }
        
        
        var notificn_idArr = [String]()
        
        for i in 0...filterDates.count-1
        {
            let objdate = filterDates[i]
            var identifier = strDateArr[i]
            
            identifier = "\(identifier)_\(self.tableID)"
            notificn_idArr.append(identifier)
            
            KQNotification.shared.Add_notification_no_repeating(identifier: identifier, title: "Reminder", body: prsnlMsg, time: alertTime, fireDate: objdate)
            
        }
        
        let totalDates = (strDateArr.map{String($0)}).joined(separator: ",")
        let notification_ids = (notificn_idArr.map{String($0)}).joined(separator: ",")
        
        
        self.SAVE_RECURRING_REMINDER_START_END_DATE_IN_DATABASE(tbID: self.tableID, reminderType: "Recurring", notif_ids: notification_ids, recurringDay: dayCount,recurring_approach:recurringType, totalDates: totalDates)
    }
    
    
    
    //MARK: SAVE REMINDERS IN DATABASE
    func SAVE_DAILY_REMINDER_IN_DATABASE(tbID:String,idArray:String,reminderType:String,totalDates:String)
    {
        DispatchQueue.main.async {
            let dic = NSMutableDictionary()
            var state = "0"
            let trigerdate = CommonVc.AllFunctions.returnDate_from_Formatter(myDate: self.datePicker.date)
            let userid = UserDefaults.standard.getUserId() ?? ""
            
            if (self.btnSwitch.isOn == true)
            {
                state = "1"
            }
            
            if (self.tf_Desc.text == "")
            {
               self.tf_Desc.text = Constants.Global.ConstantStrings.KAppname
            }
            
            dic.setValue(self.datePicker.date, forKey: coreDataKeys_Reminders.complete_date)
            dic.setValue(self.tf_Desc.text!, forKey: coreDataKeys_Reminders.desc)
            dic.setValue(state, forKey: coreDataKeys_Reminders.state)
            dic.setValue(tbID, forKey: coreDataKeys_Reminders.table_id)
            dic.setValue(tbID, forKey: coreDataKeys_Reminders.identifier)
            dic.setValue(reminderType, forKey: coreDataKeys_Reminders.title)
            dic.setValue(trigerdate, forKey: coreDataKeys_Reminders.trigger_date)
            dic.setValue(self.tfSelectTime.text, forKey: coreDataKeys_Reminders.trigger_time)
            dic.setValue(self.selectedApproach, forKey: coreDataKeys_Reminders.type)
            dic.setValue(userid, forKey: coreDataKeys_Reminders.user_id)
            
            dic.setValue(idArray, forKey: coreDataKeys_Reminders.notification_ids)
            dic.setValue(totalDates, forKey: coreDataKeys_Reminders.total_dates)
            dic.setValue("0", forKey: coreDataKeys_Reminders.day_for_recurring)
            dic.setValue("0", forKey: coreDataKeys_Reminders.recurring_approach)
            dic.setValue("\(self.selectedApproach) Reminder", forKey: coreDataKeys_Reminders.text_info)
            
            
            
            DatabaseModel_Reminders.save_New_Reminders(data_for_save: dic)
            
            CommonVc.AllFunctions.showAlert(message: "Reminder added successfully!", view: self, title: Constants.Global.ConstantStrings.KAppname)
            
            self.refresh_calender_data_for_new_approach()
        }
        
    }
    
    
    //MARK: SAVE REMINDERS IN DATABASE
    func SAVE_RECURRING_REMINDER_IN_DATABASE(tbID:String,reminderType:String,notif_id:String,recurringDay:Int,recurring_approach:String)
    {
        DispatchQueue.main.async {
            let dic = NSMutableDictionary()
            let trigerdate = CommonVc.AllFunctions.returnDate_from_Formatter(myDate: self.datePicker.date)
            let userid = UserDefaults.standard.getUserId() ?? ""
            
            if (self.tf_recurringMsg.text == "")
            {
                self.tf_recurringMsg.text = Constants.Global.ConstantStrings.KAppname
            }
            
            dic.setValue(self.datePicker.date, forKey: coreDataKeys_Reminders.complete_date)
            dic.setValue(self.tf_recurringMsg.text!, forKey: coreDataKeys_Reminders.desc)
            dic.setValue("1", forKey: coreDataKeys_Reminders.state)
            dic.setValue(tbID, forKey: coreDataKeys_Reminders.table_id)
            dic.setValue(notif_id, forKey: coreDataKeys_Reminders.identifier)
            dic.setValue(reminderType, forKey: coreDataKeys_Reminders.title)
            dic.setValue(trigerdate, forKey: coreDataKeys_Reminders.trigger_date)
            dic.setValue(self.tf_alertTime_recurring.text, forKey: coreDataKeys_Reminders.trigger_time)
            dic.setValue(self.selectedApproach, forKey: coreDataKeys_Reminders.type)
            dic.setValue(userid, forKey: coreDataKeys_Reminders.user_id)
            
            dic.setValue(notif_id, forKey: coreDataKeys_Reminders.notification_ids)
            dic.setValue("", forKey: coreDataKeys_Reminders.total_dates)
            dic.setValue("\(recurringDay)", forKey: coreDataKeys_Reminders.day_for_recurring)
            dic.setValue(recurring_approach, forKey: coreDataKeys_Reminders.recurring_approach)
            
            let txtInfo = "Ongoing Reminder, \(self.recurring_alert_type!)"
            dic.setValue(txtInfo, forKey: coreDataKeys_Reminders.text_info)
            
            DatabaseModel_Reminders.save_New_Reminders(data_for_save: dic)
            
            CommonVc.AllFunctions.showAlert(message: "Recurring Reminder added successfully!", view: self, title: Constants.Global.ConstantStrings.KAppname)
            
            self.refresh_calender_data_for_new_approach()
        }
        
    }
    
    
    //MARK: SAVE REMINDERS IN DATABASE
    func SAVE_RECURRING_REMINDER_START_END_DATE_IN_DATABASE(tbID:String,reminderType:String,notif_ids:String,recurringDay:Int,recurring_approach:String,totalDates:String)
    {
        DispatchQueue.main.async {
            let dic = NSMutableDictionary()
            let trigerdate = CommonVc.AllFunctions.returnDate_from_Formatter(myDate: self.datePicker.date)
            let userid = UserDefaults.standard.getUserId() ?? ""
            
            if (self.tf_recurringMsg.text == "")
            {
                self.tf_recurringMsg.text = Constants.Global.ConstantStrings.KAppname
            }
            
            dic.setValue(self.datePicker.date, forKey: coreDataKeys_Reminders.complete_date)
            dic.setValue(self.tf_recurringMsg.text!, forKey: coreDataKeys_Reminders.desc)
            dic.setValue("1", forKey: coreDataKeys_Reminders.state)
            dic.setValue(tbID, forKey: coreDataKeys_Reminders.table_id)
            dic.setValue("", forKey: coreDataKeys_Reminders.identifier)
            dic.setValue(reminderType, forKey: coreDataKeys_Reminders.title)
            dic.setValue(trigerdate, forKey: coreDataKeys_Reminders.trigger_date)
            dic.setValue(self.tf_alertTime_recurring.text, forKey: coreDataKeys_Reminders.trigger_time)
            dic.setValue(self.selectedApproach, forKey: coreDataKeys_Reminders.type)
            dic.setValue(userid, forKey: coreDataKeys_Reminders.user_id)
            
            dic.setValue(notif_ids, forKey: coreDataKeys_Reminders.notification_ids)
            dic.setValue(totalDates, forKey: coreDataKeys_Reminders.total_dates)
            dic.setValue("\(recurringDay)", forKey: coreDataKeys_Reminders.day_for_recurring)
            dic.setValue(recurring_approach, forKey: coreDataKeys_Reminders.recurring_approach)
            
            let txtInfo = "Recurring Reminder, \(self.recurring_alert_type!)"
            dic.setValue(txtInfo, forKey: coreDataKeys_Reminders.text_info)
            
            DatabaseModel_Reminders.save_New_Reminders(data_for_save: dic)
            self.refresh_calender_data_for_new_approach()
            
            CommonVc.AllFunctions.showAlert(message: "Recurring Reminder added successfully!", view: self, title: Constants.Global.ConstantStrings.KAppname)
            
        }
        
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .sound, .badge])
    }
    
    
    
    func show_recurringView()
    {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.view_Recurring.isHidden = false
            self.viewDidLayoutSubviews()
        })
    }
    func hide_recurringView()
    {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.view_Recurring.isHidden = true
            self.viewDidLayoutSubviews()
        })
    }
    
    func hide_recurring_tableview()
    {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
           // self.height_recurringView.constant = 210
          //  self.myTableView_Recurring.isHidden = true
          //  self.view_selectAlertTime_recurring.isHidden = true
         //   self.tf_recurringMsg.isHidden = true
            self.viewDidLayoutSubviews()
        })
    }
    
    func show_recurring_tableview()
    {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
         //   self.height_recurringView.constant = 573
          //  self.myTableView_Recurring.isHidden = false
          //  self.view_selectAlertTime_recurring.isHidden = false
          //  self.tf_recurringMsg.isHidden = false
            self.viewDidLayoutSubviews()
        })
    }
    
    
    func handle_calenderView_Height(contnt:CGFloat)
    {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
            
            self.height_CalenderView.constant = contnt
            self.view.layoutIfNeeded()
            
        }, completion: { finished in
            
        })
    }
    
    
}


