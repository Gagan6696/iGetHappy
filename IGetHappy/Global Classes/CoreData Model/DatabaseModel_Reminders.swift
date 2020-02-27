//
//  DatabaseModel_Reminders.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 12/17/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import ObjectMapper

class DatabaseModel_Reminders: NSObject
{
    
    static let myAppDelegate = Constants.Global.ConstantStrings.KappDelegate
    static let managedContext = myAppDelegate.persistentContainer.viewContext
    
    
    //MARK: <------------------ SAVE REMINDERS OFFLINE IN DATABASE --------------------->
    class func save_New_Reminders(data_for_save : NSDictionary)
    {
        
        let userEntity = NSEntityDescription.entity(forEntityName: Constants.Global.ConstantStrings.KDatabase_Reminders, in: DatabaseModel_Reminders.managedContext)!
        
        let REMINDERS = NSManagedObject(entity: userEntity, insertInto: DatabaseModel_Reminders.managedContext)
        
        REMINDERS.setValue(data_for_save.value(forKey: coreDataKeys_Reminders.complete_date),forKey: coreDataKeys_Reminders.complete_date)
        REMINDERS.setValue(data_for_save.value(forKey: coreDataKeys_Reminders.desc),forKey: coreDataKeys_Reminders.desc)
        REMINDERS.setValue(data_for_save.value(forKey: coreDataKeys_Reminders.state),forKey: coreDataKeys_Reminders.state)
        REMINDERS.setValue(data_for_save.value(forKey: coreDataKeys_Reminders.table_id),forKey: coreDataKeys_Reminders.table_id)
        REMINDERS.setValue(data_for_save.value(forKey: coreDataKeys_Reminders.title),forKey: coreDataKeys_Reminders.title)
        REMINDERS.setValue(data_for_save.value(forKey: coreDataKeys_Reminders.trigger_date),forKey: coreDataKeys_Reminders.trigger_date)
        REMINDERS.setValue(data_for_save.value(forKey: coreDataKeys_Reminders.trigger_time),forKey: coreDataKeys_Reminders.trigger_time)
        REMINDERS.setValue(data_for_save.value(forKey: coreDataKeys_Reminders.type),forKey: coreDataKeys_Reminders.type)
        REMINDERS.setValue(data_for_save.value(forKey: coreDataKeys_Reminders.user_id),forKey: coreDataKeys_Reminders.user_id)
        REMINDERS.setValue(data_for_save.value(forKey: coreDataKeys_Reminders.identifier),forKey: coreDataKeys_Reminders.identifier)
        
        REMINDERS.setValue(data_for_save.value(forKey: coreDataKeys_Reminders.notification_ids),forKey: coreDataKeys_Reminders.notification_ids)
        REMINDERS.setValue(data_for_save.value(forKey: coreDataKeys_Reminders.total_dates),forKey: coreDataKeys_Reminders.total_dates)
        REMINDERS.setValue(data_for_save.value(forKey: coreDataKeys_Reminders.day_for_recurring),forKey: coreDataKeys_Reminders.day_for_recurring)
        REMINDERS.setValue(data_for_save.value(forKey: coreDataKeys_Reminders.recurring_approach),forKey: coreDataKeys_Reminders.recurring_approach)
        
        REMINDERS.setValue(data_for_save.value(forKey: coreDataKeys_Reminders.text_info),forKey: coreDataKeys_Reminders.text_info)
        
        
        
        //Now we have set all the values. The next step is to save them inside the Core Data
        
        do
        {
            try DatabaseModel_Reminders.managedContext.save()
            // success(Constants.Global.ConstantStrings.KSaved)
        }
        catch let error as NSError
        {
            let errorStr = ("\(Constants.Global.ConstantStrings.KNotSaved) \(error), \(error.userInfo)")
            print(errorStr)
            //  failure(errorStr)
        }
        
        
    }
    
    
    //MARK: <------------------ DELETE REMINDERS FROM DATABASE --------------------->
    class func delete_DATA_FROM_coreData_for_Reminders(tableID : String,success: @escaping (String) -> Void, failure: @escaping (String) -> Void)
    {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Global.ConstantStrings.KDatabase_Reminders)
        let userKey_name = coreDataKeys_Reminders.user_id
        let tbIDKey_name = coreDataKeys_Reminders.table_id
        let userID = UserDefaults.standard.getUserId() ?? ""
        
         fetchRequest.predicate = NSPredicate(format: "\(tbIDKey_name) = %@ AND \(userKey_name) = %@", tableID,userID)
        
        do
        {
            let test = try DatabaseModel_Reminders.managedContext.fetch(fetchRequest)
            
            if (test.count > 0)
            {
                
                for obj in test
                {
                    let objectToDelete = obj as! NSManagedObject
                    DatabaseModel_Reminders.managedContext.delete(objectToDelete)
                    do
                    {
                        try DatabaseModel_Reminders.managedContext.save()
                    }
                    catch
                    {
                        print(error)
                    }
                }
                
                success(Constants.Global.ConstantStrings.KDeleted)
            }
            else
            {
                failure(Constants.Global.ConstantStrings.KEntityNotFound)
            }
            
        }
        catch let error as NSError
        {
            let errorStr = ("\(Constants.Global.ConstantStrings.KNotSaved) \(error), \(error.userInfo)")
            failure(errorStr)
        }
        
        
    }
    
    
    class func get_offline_saved_Reminders(success: @escaping ([EditReminderMapper]) -> Void, failure: @escaping (String) -> Void)
    {
        
        let managedContext2 = myAppDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Global.ConstantStrings.KDatabase_Reminders)
        
        let userKey_name = coreDataKeys_Reminders.user_id
        
        let userID = UserDefaults.standard.getUserId() ?? ""
        fetchRequest.predicate = NSPredicate(format: "\(userKey_name) = %@",userID)
        
        do
        {
            let result = try managedContext2.fetch(fetchRequest)
            
            if (result.count > 0)
            {
                let arry = CoreData_Model.convertToJSONArray(moArray: result as! [NSManagedObject])
              //  let dict  = arry[0] as? [String:Any]
              //  print(dict)
                allReminderJSON(data: arry, completionResponse: { (reminderData) in
                success(reminderData)
                    //send data to delegate
                    
                }, completionError: { (error) in
                  
                    
                    //print(error!)
                })
                
                
                print("get reminder data",arry)
               
            }
            else
            {
                failure(Constants.Global.ConstantStrings.KEntityNotFound)
            }

        }
        catch
        {
            failure("\(error.localizedDescription)")
        }
        
    }
    class func allReminderJSON(data: NSArray,completionResponse:  @escaping ([EditReminderMapper]) -> Void,completionError: @escaping (Error?) -> Void)
    {
       // let json = data.toJSONString()
        //let shops = Array<EditReminderMapper>(JSONString: data)
        
        let data = Mapper<EditReminderMapper>().mapArray(JSONArray: data as! [[String : Any]])
       
        completionResponse(data)
    }
    
    
    //MARK: UPDATING REMINDER STATE
    class func update_reminder_status(status:String,tableID:String,success: @escaping (String) -> Void)
    {
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: Constants.Global.ConstantStrings.KDatabase_Reminders)
        let ID = coreDataKeys_Reminders.table_id
        
        fetchRequest.predicate = NSPredicate(format: "\(ID) = %@",tableID)
        
        do
        {
            //CHECKING IF EMOJY IS ALREADY SAVED THEN UPDATE HERE OTHERWISE ADD NEW VALUE BECAUSE ITS EMPTY
            let test = try managedContext.fetch(fetchRequest)
            if (test.count > 0)
            {
                let REMINDER = test[0] as! NSManagedObject
                REMINDER.setValue(status, forKeyPath: coreDataKeys_Reminders.state)
                
                do
                {
                    try managedContext.save()
                    success("true")
                }
                catch
                {
                    print(error)
                    success("false")
                }
            }
            else
            {
                success("false")
            }
            
        }
        catch
        {
            print(error)
            success("false")
        }
        
    }
    
}
