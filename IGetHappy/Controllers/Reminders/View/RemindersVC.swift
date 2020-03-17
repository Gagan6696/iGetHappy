//
//  RemindersVC.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/4/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import EventKit
import UserNotifications

class RemindersVC: UIViewController
{
    
    
    //MARK: OUTLETS
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var btnAlarm: UIButton!
    
    
    //MARK: VARIABLES
    let cellID = "CellClass_RemindersVC"
    //var dataArray = NSMutableArray()
    var reminderMapperData = [EditReminderMapper]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
      //  get_pending_reminders()
    }
    
    func get_pending_reminders()
    {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests
            {
                print(request)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.GET_REMINDERS_FROM_DATABASE()
    }
    
    func GET_REMINDERS_FROM_DATABASE()
    {
        DatabaseModel_Reminders.get_offline_saved_Reminders(success: { (arr) in
            self.reminderMapperData = arr
            //Gagan R Chnage
           // self.dataArray = NSMutableArray(array: arr)
            self.myTableView.reloadData()
            
        }) { (err) in
            
            self.myTableView.setEmptyMessage("No Reminders Found!")
        }
    }
    
    
    
    //MARK: BUTTON ACTIONS ->
    @IBAction func ACTION_DISMISS_VIEW(_ sender: Any)
    {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    
    @IBAction func ACTION_SWITCH(_ sender: UISwitch)
    {
        //Gagan R change
       // let obj = self.dataArray.object(at: sender.tag)as? NSDictionary
        let obj  = self.reminderMapperData[sender.tag]
        if sender.isOn == true
        {
            self.ADD_REMINDERS_AGAIN_WHEN_SWITCH_IS_ON(dicData: obj)
        }
        else
        {
            self.Disable_reminders_when_switch_is_off(dicData: obj)
        }
        
        
    }
    
    
    @IBAction func ACTION_ALARM(_ sender: Any)
    {
        let story = UIStoryboard.init(name: "Meditation", bundle: nil)
        let controller = story.instantiateViewController(withIdentifier: "SetRemindersVC")as! SetRemindersVC
        controller.isFromSideBar = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func showAlert_deleteReminder(tbID:String,index:Int)
    {
        // Create the alert controller
        let alertController = UIAlertController(title: Constants.Global.ConstantStrings.KAppname, message: Constants.Global.ConstantStrings.KDoYouWantDelete, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            
            
            //  let obj = self.dataArray.object(at: index)as? NSDictionary
            
            let obj = self.reminderMapperData[index]
            //let ids = obj?.value(forKey: coreDataKeys_Reminders.notification_ids) as? String ?? "0"
            let ids = obj.notification_ids
            
            if (ids?.count ?? 0 > 0)
            {
                let arr = ids?.components(separatedBy: ",")
                print(arr as Any)
                self.REMOVE_REMINDER_NOTIFICATIONS_FROM_SYSTEM(notif_ids: arr ?? [""])
            }
            
            DatabaseModel_Reminders.delete_DATA_FROM_coreData_for_Reminders(tableID: tbID, success: { (sccss) in
                print(sccss)
                
            }, failure: { (err) in
                print(err)
            })
            
//            let tmparr = self.dataArray.mutableCopy() as! NSMutableArray
//            tmparr.removeObject(at: index)
//            self.dataArray = tmparr
            self.reminderMapperData.remove(at: index)
            
            self.myTableView.reloadData()
            if (self.reminderMapperData.count == 0)
            {
                self.myTableView.setEmptyMessage("No Reminders Found!")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //func Disable_reminders_when_switch_is_off(dicData:NSDictonary)
    func Disable_reminders_when_switch_is_off(dicData:EditReminderMapper)
    {
       // let notif_ids = dicData.value(forKey: coreDataKeys_Reminders.notification_ids)as? String ?? ""
        let notif_ids = dicData.notification_ids
        //let tableID = dicData.value(forKey: coreDataKeys_Reminders.table_id)as? String ?? ""
         let tableID = dicData.table_id
        if (notif_ids?.count ?? 0 > 0)
        {
            let arr = notif_ids?.components(separatedBy: ",")
            self.REMOVE_REMINDER_NOTIFICATIONS_FROM_SYSTEM(notif_ids: arr ?? [""])
            self.update_state_for_reminder_in_databse(status: "0", tbID: tableID ?? "")
        }
        
    }

    func REMOVE_REMINDER_NOTIFICATIONS_FROM_SYSTEM(notif_ids:[String])
    {
        if (notif_ids.count > 0)
        {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notif_ids)
        }
        
    }
    
    func ADD_REMINDERS_AGAIN_WHEN_SWITCH_IS_ON(dicData:EditReminderMapper)
    {
        //non recurring
        let tableID = dicData.table_id
       // let tableID = dicData.value(forKey: coreDataKeys_Reminders.table_id)as? String ?? ""
        //let notif_ids = dicData.value(forKey: coreDataKeys_Reminders.notification_ids)as? String ?? ""
         let notif_ids = dicData.notification_ids
        //let type = dicData.value(forKey: coreDataKeys_Reminders.type)as? String ?? ""
        let type = dicData.type
//        let trigerDateArr = dicData.value(forKey: coreDataKeys_Reminders.total_dates)as? String ?? ""
        let trigerDateArr = dicData.total_dates
//        let descpn = dicData.value(forKey: coreDataKeys_Reminders.desc)as? String ?? ""
        let descpn = dicData.desc
//        let str_triger_time = dicData.value(forKey: coreDataKeys_Reminders.trigger_time)as? String ?? ""
        let str_triger_time = dicData.trigger_time
        let triggerTime = CommonVc.AllFunctions.return_time_from_string(myTime:str_triger_time ?? "")
        
        //RECURRING
//        let notif_id = dicData.value(forKey: coreDataKeys_Reminders.identifier)as? String ?? ""
        let notif_id = dicData.identifier
//        let recurringDay = dicData.value(forKey: coreDataKeys_Reminders.day_for_recurring)as? String ?? "0"
       let recurringDay = dicData.day_for_recurring

        let dayCount = Int(recurringDay ?? "0")
       // let recurring_approach = dicData.value(forKey: coreDataKeys_Reminders.recurring_approach)as? String ?? ""
        let recurring_approach = dicData.recurring_approach
        
        
        if(type == "Recurring")
        {
            self.CREATE_REMINDERS_RECURRING(identifier: notif_id ?? "", recurringType: recurring_approach ?? "", dayCount: dayCount!, alertTime: triggerTime, prsnlMsg: descpn ?? "", isOnGoing: true)
            self.update_state_for_reminder_in_databse(status: "1", tbID: tableID ?? "")
        }
        else
        {
            if (notif_ids?.count ?? 0 > 0 && trigerDateArr?.count ?? 0 > 0)
            {
                let arr_ids = notif_ids?.components(separatedBy: ",")
                let arr_str_dates = trigerDateArr?.components(separatedBy: ",")
                let arrDates = CommonVc.AllFunctions.convert_string_into_date(strArr:arr_str_dates ?? [""])
                
                for i in 0...(arr_ids?.count ?? 0)-1
                {
                    let notif_ID = arr_ids?[i]
                    
                    if (i <= arrDates.count-1)
                    {
                        let notif_date = arrDates[i]
                        
                        if (type == "Ongoing")
                        {
                            self.CREATE_REMINDERS_FOR_START_END_DATE_RECURRING(identifier: notif_ID ?? "", alertTime: triggerTime, prsnlMsg: descpn ?? "", fireDATE: notif_date)
                        }
                        else
                        {
                            self.CREATE_REMINDERS(identifier: notif_ID ?? "", desc: descpn ?? "", date: notif_date, time: triggerTime)
                        }
                    }
                }
                
                self.update_state_for_reminder_in_databse(status: "1", tbID: tableID ?? "")
            }
        }
        
    }
    
    
    func update_state_for_reminder_in_databse(status:String,tbID:String)
    {
        DatabaseModel_Reminders.update_reminder_status(status: status,tableID: tbID) { (result) in
            
            if (result == "true")
            {
                self.GET_REMINDERS_FROM_DATABASE()
            }
            else
            {
                CommonVc.AllFunctions.showAlert(message: "Error in updating database.", view: self, title: "Sorry!")
            }
        }
    }
    
}

extension RemindersVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return reminderMapperData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! CellClass_RemindersVC
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let obj = reminderMapperData[indexPath.row]
        //let state = obj?.value(forKey: coreDataKeys_Reminders.state) as? String ?? "0"
         let state = obj.state
       // cell.lblName.text = obj?.value(forKey: coreDataKeys_Reminders.title) as? String ?? "Reminder"
        cell.lblName.text = "Meditation"
       // cell.lblDesc.text = obj?.value(forKey: coreDataKeys_Reminders.text_info) as? String ?? "Description"
        cell.lblDesc.text = obj.text_info
        cell.lblTime.text = obj.trigger_time
        
        if (state == "1")
        {
            cell.btnSwitch.setOn(true, animated: true)
        }
        else
        {
            cell.btnSwitch.setOn(false, animated: true)
        }
        
        cell.btnSwitch.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
//        if (editingStyle == .delete)
//        {
//            let obj = dataArray.object(at: indexPath.row)as? NSDictionary
//            let id = obj?.value(forKey: coreDataKeys_Reminders.table_id) as? String ?? "0"
//            self.showAlert_deleteReminder(tbID: id,index:indexPath.row)
//        }
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        return nil
    }

 //   @available(iOS 11.0, *)
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        let deleteAction = UIContextualAction.init(style: UIContextualAction.Style.destructive, title: "Delete", handler: { (action, view, completion) in
//            //TODO: Delete
//           // let obj = self.dataArray.object(at: indexPath.row)as? NSDictionary
//            let obj = self.reminderMapperData[indexPath.row]
//            //let id = obj?.value(forKey: coreDataKeys_Reminders.table_id) as? String ?? "0"
//            let id = obj.table_id
//            self.showAlert_deleteReminder(tbID: id ?? "",index:indexPath.row)
//            print("favorite button tapped")
//            completion(true)
//        })
//
//        let editAction = UIContextualAction.init(style: UIContextualAction.Style.normal, title: "Edit", handler: { (action, view, completion) in
//            //TODO: Edit
//            completion(true)
//        })
//
//        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
//
//        config.performsFirstActionWithFullSwipe = false
//        return config
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90.0
    }
}
