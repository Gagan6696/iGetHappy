//
//  DatabaseModel.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/6/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreData_Model : NSObject
{
    
    static let myAppDelegate = Constants.Global.ConstantStrings.KappDelegate
    static let managedContext = myAppDelegate.persistentContainer.viewContext
    
    
    
    
    //MARK: <------------------ GET OFFLINE SAVED MOOD EMOJY --------------------->
    class func get_offline_saved_emoji(success: @escaping (NSDictionary) -> Void, failure: @escaping (String) -> Void)
    {
        let managedContext2 = myAppDelegate.persistentContainer.viewContext
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Global.ConstantStrings.KDatabase_Offline_Emoji)
        
        let user_id_key = coreDataKeys_HappyMemories.user_id
        let userID = UserDefaults.standard.getUserId() ?? ""
        fetchRequest.predicate = NSPredicate(format: "\(user_id_key) = %@", userID)
        
       
        do
        {
            let result = try managedContext2.fetch(fetchRequest)
            
            if (result.count > 0)
            {
                for data in result
                {
                    let dic = CoreData_Model.convertToDictionary(object: data as! NSManagedObject)
                    success(dic)
                    break
                }
            }
            else
            {
               failure("No Records for Offline Emojy")
            }
            
        }
        catch
        {
            failure("\(error.localizedDescription)")
        }
    }
    
    
    //MARK: <------------------ SAVE OFFLINE EMOJY MOOD --------------------->
    class func save_emoji_offline_in_coreData(data_for_save : NSDictionary,success: @escaping (String) -> Void, failure: @escaping (String) -> Void)
    {
        
        //Now let’s create an entity and new user records.
        let userEntity = NSEntityDescription.entity(forEntityName: Constants.Global.ConstantStrings.KDatabase_Offline_Emoji, in: CoreData_Model.managedContext)!
        
        //final, we need to add some data to our newly created record for each keys using
        //here adding 5 data with loop
        
        let EMOJI = NSManagedObject(entity: userEntity, insertInto: CoreData_Model.managedContext)
        
        EMOJI.setValue(data_for_save.value(forKey: coreDataKeys_SavedEmoji.date), forKeyPath: coreDataKeys_SavedEmoji.date)
        EMOJI.setValue(data_for_save.value(forKey: coreDataKeys_SavedEmoji.image_name), forKey: coreDataKeys_SavedEmoji.image_name)
        EMOJI.setValue(data_for_save.value(forKey: coreDataKeys_SavedEmoji.index), forKey: coreDataKeys_SavedEmoji.index)
        EMOJI.setValue(data_for_save.value(forKey: coreDataKeys_SavedEmoji.mood_name), forKey: coreDataKeys_SavedEmoji.mood_name)
        EMOJI.setValue(data_for_save.value(forKey: coreDataKeys_SavedEmoji.is_posted), forKey: coreDataKeys_SavedEmoji.is_posted)
        EMOJI.setValue(data_for_save.value(forKey: coreDataKeys_SavedEmoji.user_id), forKey: coreDataKeys_SavedEmoji.user_id)
        EMOJI.setValue(data_for_save.value(forKey: coreDataKeys_SavedEmoji.icon_name), forKey: coreDataKeys_SavedEmoji.icon_name)
        
        EMOJI.setValue(data_for_save.value(forKey: coreDataKeys_SavedEmoji.current_time), forKey: coreDataKeys_SavedEmoji.current_time)
        
        //Now we have set all the values. The next step is to save them inside the Core Data
        
        do
        {
            try CoreData_Model.managedContext.save()
            success(Constants.Global.ConstantStrings.KSaved)
        }
        catch let error as NSError
        {
            let errorStr = ("\(Constants.Global.ConstantStrings.KNotSaved) \(error), \(error.userInfo)")
            failure(errorStr)
        }
    }
    
    
    //MARK: <------------------ UPDATE OFFLINE EMOJY MOOD --------------------->
    class func update_emoji_offline_in_coreData(data_for_save : NSDictionary,success: @escaping (String) -> Void, failure: @escaping (String) -> Void)
    {
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: Constants.Global.ConstantStrings.KDatabase_Offline_Emoji)
        
        let ID = coreDataKeys_SavedEmoji.table_id
        
        fetchRequest.predicate = NSPredicate(format: "\(ID) = 0")
        
        do
        {
            //CHECKING IF EMOJY IS ALREADY SAVED THEN UPDATE HERE OTHERWISE ADD NEW VALUE BECAUSE ITS EMPTY
            let test = try managedContext.fetch(fetchRequest)
            if (test.count > 0)
            {
                let EMOJI = test[0] as! NSManagedObject
                
                EMOJI.setValue(data_for_save.value(forKey: coreDataKeys_SavedEmoji.date), forKeyPath: coreDataKeys_SavedEmoji.date)
                EMOJI.setValue(data_for_save.value(forKey: coreDataKeys_SavedEmoji.image_name), forKey: coreDataKeys_SavedEmoji.image_name)
                EMOJI.setValue(data_for_save.value(forKey: coreDataKeys_SavedEmoji.index), forKey: coreDataKeys_SavedEmoji.index)
                EMOJI.setValue(data_for_save.value(forKey: coreDataKeys_SavedEmoji.mood_name), forKey: coreDataKeys_SavedEmoji.mood_name)
                EMOJI.setValue(data_for_save.value(forKey: coreDataKeys_SavedEmoji.is_posted), forKey: coreDataKeys_SavedEmoji.is_posted)
                EMOJI.setValue(data_for_save.value(forKey: coreDataKeys_SavedEmoji.user_id), forKey: coreDataKeys_SavedEmoji.user_id)
                EMOJI.setValue(data_for_save.value(forKey: coreDataKeys_SavedEmoji.icon_name), forKey: coreDataKeys_SavedEmoji.icon_name)
                
                EMOJI.setValue(data_for_save.value(forKey: coreDataKeys_SavedEmoji.current_time), forKey: coreDataKeys_SavedEmoji.current_time)
                
                
                
                do
                {
                    try managedContext.save()
                    success(Constants.Global.ConstantStrings.KSaved)
                }
                catch
                {
                    print(error)
                    let errorStr = ("\(Constants.Global.ConstantStrings.KNotSaved) \(error.localizedDescription)")
                    failure(errorStr)
                }
            }
            else
            {
                //ADDING NEW VALUE BECAUSE DATABASE IS EMPTY
                CoreData_Model.save_emoji_offline_in_coreData(data_for_save: data_for_save, success:
                    { (result) in
                    success(Constants.Global.ConstantStrings.KSaved)
                }) { (error) in
                    failure(error.description)
                }
            }
            
        }
        catch
        {
            print(error)
            failure(error.localizedDescription)
        }
      
    }
    
    
    
    //MARK: UPDATING COREDATA WHEN EMOJI IS UPDATED TO THE SERVER
    class func update_emoji_status_posted(status : String,moodID:String)
    {
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: Constants.Global.ConstantStrings.KDatabase_Offline_Emoji)
        
        let ID = coreDataKeys_SavedEmoji.table_id
        
        fetchRequest.predicate = NSPredicate(format: "\(ID) = 0")
        
        do
        {
            //CHECKING IF EMOJY IS ALREADY SAVED THEN UPDATE HERE OTHERWISE ADD NEW VALUE BECAUSE ITS EMPTY
            let test = try managedContext.fetch(fetchRequest)
            if (test.count > 0)
            {
                let EMOJI = test[0] as! NSManagedObject
                
                EMOJI.setValue(status, forKeyPath: coreDataKeys_SavedEmoji.is_posted)
                EMOJI.setValue(moodID, forKeyPath: coreDataKeys_SavedEmoji.mood_id)
                
                do
                {
                    try managedContext.save()
                }
                catch
                {
                    print(error)
                }
            }
            
        }
        catch
        {
            print(error)
        }
        
    }
    
    
    //MARK: <------------------ DELETE OFFLINE EMOJY MOOD SAVED --------------------->
    class func delete_emoji_offline_in_coreData(success: @escaping (String) -> Void, failure: @escaping (String) -> Void)
    {
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Global.ConstantStrings.KDatabase_Offline_Emoji)
        
        let table_id = coreDataKeys_SavedEmoji.table_id
        fetchRequest.predicate = NSPredicate(format: "\(table_id) = 0")
        
        do
        {
            let test = try CoreData_Model.managedContext.fetch(fetchRequest)
            
            if (test.count > 0)
            {
                let objectToDelete = test[0] as! NSManagedObject
                CoreData_Model.managedContext.delete(objectToDelete)
                
                do
                {
                    try CoreData_Model.managedContext.save()
                    success(Constants.Global.ConstantStrings.KDeleted)
                }
                catch
                {
                    print(error)
                }
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
    
    
    
    
    
    
    
    
    //MARK: #---------------------------Happy Memories Database Handling---------------------------------#
    
    class func get_offline_saved_memories(success: @escaping (NSArray) -> Void, failure: @escaping (String) -> Void)
    {
      
        let managedContext2 = myAppDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Global.ConstantStrings.KDatabase_Happy_Memories)
        
        let user_id_key = coreDataKeys_HappyMemories.user_id
        let userID = UserDefaults.standard.getUserId() ?? ""
        fetchRequest.predicate = NSPredicate(format: "\(user_id_key) = %@", userID)
        
        do
        {
            let result = try managedContext2.fetch(fetchRequest)
            
            if (result.count > 0)
            {
                let arry = CoreData_Model.convertToJSONArray(moArray: result as! [NSManagedObject])
                success(arry)
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
    
    
    //MARK: <------------------ GET OFFLINE SAVED AUDIO FILES --------------------->
    class func get_offline_saved_audios(success: @escaping (NSArray) -> Void, failure: @escaping (String) -> Void)
    {
        
        let managedContext2 = myAppDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Global.ConstantStrings.KDatabase_Happy_Memories)
        
        let user_id_key = coreDataKeys_HappyMemories.user_id
        let userID = UserDefaults.standard.getUserId() ?? ""
        fetchRequest.predicate = NSPredicate(format: "\(user_id_key) = %@ AND type = audio", userID)
        
        do
        {
            let result = try managedContext2.fetch(fetchRequest)
            
            if (result.count > 0)
            {
                let arry = CoreData_Model.convertToJSONArray(moArray: result as! [NSManagedObject])
                success(arry)
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
    
    
    
    //MARK: <------------------ SAVE HAPPY MEMORIES OFFLINE IN DATABASE --------------------->
    class func save_memories_offline_in_coreData(data_for_save : NSDictionary,success: @escaping (String) -> Void, failure: @escaping (String) -> Void)
    {
        
        let userEntity = NSEntityDescription.entity(forEntityName: Constants.Global.ConstantStrings.KDatabase_Happy_Memories, in: CoreData_Model.managedContext)!
        
        let MEMORIES = NSManagedObject(entity: userEntity, insertInto: CoreData_Model.managedContext)
        
        let asset =   data_for_save.value(forKey: coreDataKeys_HappyMemories.asset)
        //  let encodedData = NSKeyedArchiver.archivedData(withRootObject: asset as Any)
        
        
        MEMORIES.setValue(asset,forKey: coreDataKeys_HappyMemories.asset)
        
        MEMORIES.setValue(data_for_save.value(forKey: coreDataKeys_HappyMemories.url),forKey: coreDataKeys_HappyMemories.url)
        MEMORIES.setValue(data_for_save.value(forKey: coreDataKeys_HappyMemories.location),forKey: coreDataKeys_HappyMemories.location)
        
        MEMORIES.setValue(data_for_save.value(forKey: coreDataKeys_HappyMemories.name), forKeyPath: coreDataKeys_HappyMemories.name)
        MEMORIES.setValue(data_for_save.value(forKey: coreDataKeys_HappyMemories.type), forKey: coreDataKeys_HappyMemories.type)
        MEMORIES.setValue(data_for_save.value(forKey: coreDataKeys_HappyMemories.user_id), forKey: coreDataKeys_HappyMemories.user_id)
        MEMORIES.setValue(data_for_save.value(forKey: coreDataKeys_HappyMemories.table_id), forKey: coreDataKeys_HappyMemories.table_id)
        
        //Now we have set all the values. The next step is to save them inside the Core Data
        
        do
        {
            try CoreData_Model.managedContext.save()
            success(Constants.Global.ConstantStrings.KSaved)
        }
        catch let error as NSError
        {
            let errorStr = ("\(Constants.Global.ConstantStrings.KNotSaved) \(error), \(error.userInfo)")
            failure(errorStr)
        }
        
        
    }
    
    
    
     //MARK: <------------------ DELETE HAPPY MEMORIES OFFLINE FROM DATABASE --------------------->
   class func delete_memories_offline_in_coreData(tableID : String,success: @escaping (String) -> Void, failure: @escaping (String) -> Void)
    {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Global.ConstantStrings.KDatabase_Happy_Memories)
        let table_id = coreDataKeys_HappyMemories.table_id
        fetchRequest.predicate = NSPredicate(format: "\(table_id) = %@", tableID)
        
        do
        {
            let test = try CoreData_Model.managedContext.fetch(fetchRequest)
            
            if (test.count > 0)
            {
                let objectToDelete = test[0] as! NSManagedObject
                CoreData_Model.managedContext.delete(objectToDelete)
                
                do
                {
                    try CoreData_Model.managedContext.save()
                    success(Constants.Global.ConstantStrings.KDeleted)
                }
                catch
                {
                    print(error)
                }
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
 
 
    
    
    
    
    //MARK: #---------------------MOOD LOGS WITH EVENTS DATABASE HANDLING------------------------------#
 
 
    
    //MARK: <------------------ SAVE OFFLINE MOOD LOG EVENTS --------------------->
    class func UPDATE_MOOD_LOG_EVENTS_offline_in_coreData(data_for_save : NSDictionary,success: @escaping (String) -> Void, failure: @escaping (String) -> Void)
    {
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: Constants.Global.ConstantStrings.KDatabase_MoodLog_Events)
        
        let ID = coreDataKeys_MoodLog_Events.table_id
        let user_id_key = coreDataKeys_HappyMemories.user_id
        let userID = UserDefaults.standard.getUserId() ?? ""
        
        //fetchRequest.predicate = NSPredicate(format: "\(ID) = 0")
        fetchRequest.predicate = NSPredicate(format: "\(ID) = 0 AND \(user_id_key) = %@",userID)
        
        do
        {
            //CHECKING IF EMOJY IS ALREADY SAVED THEN UPDATE HERE OTHERWISE ADD NEW VALUE BECAUSE ITS EMPTY
            let test = try managedContext.fetch(fetchRequest)
            if (test.count > 0)
            {
                var EVENTS = test[0] as! NSManagedObject
                let new = CoreData_Model.update_entity_with_new_value_MOOD_LOGS(mngdOBJ: EVENTS, dic: data_for_save)
                EVENTS = new
                
                do
                {
                    try managedContext.save()
                    success(Constants.Global.ConstantStrings.KSaved)
                }
                catch
                {
                    print(error)
                    let errorStr = ("\(Constants.Global.ConstantStrings.KNotSaved) \(error.localizedDescription)")
                    failure(errorStr)
                }
            }
            else
            {
                //ADDING NEW VALUE BECAUSE DATABASE IS EMPTY
                CoreData_Model.SAVE_MOOD_LOGS_EVENTS_in_coreData(data_for_save: data_for_save, success:
                    { (result) in
                        success(Constants.Global.ConstantStrings.KSaved)
                }) { (error) in
                    failure(error.description)
                }
            }
            
        }
        catch
        {
            print(error)
            failure(error.localizedDescription)
        }
    }
    
    
    
    
    
    //MARK: <------------------ IF MOOD LOG DATABASE IS EMPTY THEN ADD VALUE --------------------->
    class func SAVE_MOOD_LOGS_EVENTS_in_coreData(data_for_save : NSDictionary,success: @escaping (String) -> Void, failure: @escaping (String) -> Void)
    {
        
        //Now let’s create an entity and new user records.
        let userEntity = NSEntityDescription.entity(forEntityName: Constants.Global.ConstantStrings.KDatabase_MoodLog_Events, in: CoreData_Model.managedContext)!
        
        //final, we need to add some data to our newly created record for each keys using
        //here adding 5 data with loop
        
        var MOOD_LOGS = NSManagedObject(entity: userEntity, insertInto: CoreData_Model.managedContext)
        let new = CoreData_Model.update_entity_with_new_value_MOOD_LOGS(mngdOBJ: MOOD_LOGS, dic: data_for_save)
        MOOD_LOGS = new
        
        //Now we have set all the values. The next step is to save them inside the Core Data
        
        do
        {
            try CoreData_Model.managedContext.save()
            success(Constants.Global.ConstantStrings.KSaved)
        }
        catch let error as NSError
        {
            let errorStr = ("\(Constants.Global.ConstantStrings.KNotSaved) \(error), \(error.userInfo)")
            failure(errorStr)
        }
    }
    
    
    
    //MARK: <------------------ GET OFFLINE SAVED MOOD EMOJY --------------------->
    class func get_offline_MOOD_LOG_EVENTS(success: @escaping (NSDictionary) -> Void, failure: @escaping (String) -> Void)
    {
        let managedContext2 = myAppDelegate.persistentContainer.viewContext
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Global.ConstantStrings.KDatabase_MoodLog_Events)
        
        let userID = UserDefaults.standard.getUserId() ?? ""
        let databseKey = coreDataKeys_MoodLog_Events.user_id
        
        fetchRequest.predicate = NSPredicate(format: "\(databseKey) = %@",userID)
        
        do
        {
            let result = try managedContext2.fetch(fetchRequest)
            
            if (result.count > 0)
            {
                for data in result
                {
                    let dic = CoreData_Model.convertToDictionary(object: data as! NSManagedObject)
                    success(dic)
                    break
                }
            }
            else
            {
                failure("no data")
            }
            
           
        }
        catch
        {
            failure("\(error.localizedDescription)")
        }
    }
    
    
    //MARK: <------------------ DELETE SAVED OFFLINE EVENT LOG --------------------->
    class func delete_MOOD_LOG_FROM_coreData(success: @escaping (String) -> Void, failure: @escaping (String) -> Void)
    {
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Global.ConstantStrings.KDatabase_MoodLog_Events)
        
        let table_id = coreDataKeys_MoodLog_Events.table_id
        fetchRequest.predicate = NSPredicate(format: "\(table_id) = 0")
        
        do
        {
            let test = try CoreData_Model.managedContext.fetch(fetchRequest)
            
            if (test.count > 0)
            {
                let objectToDelete = test[0] as! NSManagedObject
                CoreData_Model.managedContext.delete(objectToDelete)
                
                do
                {
                    try CoreData_Model.managedContext.save()
                    success(Constants.Global.ConstantStrings.KDeleted)
                }
                catch
                {
                    print(error)
                }
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
    
    
 
}

extension CoreData_Model
{
    class func convertToDictionary(object: NSManagedObject) -> NSDictionary
    {
        var result = NSDictionary()
        var dict: [String: Any] = [:]
        for attribute in object.entity.attributesByName
        {
            //check if value is present, then add key to dictionary so as to avoid the nil value crash
            if let value = object.value(forKey: attribute.key)
            {
                dict[attribute.key] = value
            }
        }
        
        result = dict as NSDictionary
        return result
    }
    
    
    class func convertToJSONArray(moArray: [NSManagedObject]) -> NSArray
    {
        let jsonArray = NSMutableArray()
        for item in moArray
        {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName
            {
                //check if value is present, then add key to dictionary so as to avoid the nil value crash
                if let value = item.value(forKey: attribute.key)
                {
                    dict[attribute.key] = value
                }
            }
            jsonArray.add(dict)
        }
        return NSArray(array: jsonArray)
    }
    
    
    
    class func update_entity_with_new_value_MOOD_LOGS(mngdOBJ:NSManagedObject,dic:NSDictionary) -> NSManagedObject
    {
        
        let MOODLogEntity = mngdOBJ
        
        
        MOODLogEntity.setValue(dic.value(forKey: coreDataKeys_MoodLog_Events.change_file_status), forKeyPath: coreDataKeys_MoodLog_Events.change_file_status)
        
        MOODLogEntity.setValue(dic.value(forKey: coreDataKeys_MoodLog_Events.event_id), forKeyPath: coreDataKeys_MoodLog_Events.event_id)
        
  //      MOODLogEntity.setValue(dic.value(forKey: coreDataKeys_MoodLog_Events.icon_name), forKeyPath: coreDataKeys_MoodLog_Events.icon_name)
        
        MOODLogEntity.setValue(dic.value(forKey: coreDataKeys_MoodLog_Events.table_id), forKeyPath: coreDataKeys_MoodLog_Events.table_id)
        
        MOODLogEntity.setValue(dic.value(forKey: coreDataKeys_MoodLog_Events.user_id), forKeyPath: coreDataKeys_MoodLog_Events.user_id)
        
        MOODLogEntity.setValue(dic.value(forKey: coreDataKeys_MoodLog_Events.privacy), forKeyPath: coreDataKeys_MoodLog_Events.privacy)
        
        MOODLogEntity.setValue(dic.value(forKey: coreDataKeys_MoodLog_Events.desc), forKeyPath: coreDataKeys_MoodLog_Events.desc)
        
        MOODLogEntity.setValue(dic.value(forKey: coreDataKeys_MoodLog_Events.location), forKeyPath: coreDataKeys_MoodLog_Events.location)
        
        MOODLogEntity.setValue(dic.value(forKey: coreDataKeys_MoodLog_Events.date), forKeyPath: coreDataKeys_MoodLog_Events.date)
        
        MOODLogEntity.setValue(dic.value(forKey: coreDataKeys_MoodLog_Events.image_name), forKeyPath: coreDataKeys_MoodLog_Events.image_name)
        
        MOODLogEntity.setValue(dic.value(forKey: coreDataKeys_MoodLog_Events.mood_name), forKeyPath: coreDataKeys_MoodLog_Events.mood_name)
        
        MOODLogEntity.setValue(dic.value(forKey: coreDataKeys_MoodLog_Events.is_posted), forKeyPath: coreDataKeys_MoodLog_Events.is_posted)
        
        MOODLogEntity.setValue(dic.value(forKey: coreDataKeys_MoodLog_Events.care_rcvr_id), forKeyPath: coreDataKeys_MoodLog_Events.care_rcvr_id)
        
        MOODLogEntity.setValue(dic.value(forKey: coreDataKeys_MoodLog_Events.video_path), forKeyPath: coreDataKeys_MoodLog_Events.video_path)
        
        MOODLogEntity.setValue(dic.value(forKey: coreDataKeys_MoodLog_Events.audio_path), forKeyPath: coreDataKeys_MoodLog_Events.audio_path)
        
        MOODLogEntity.setValue(dic.value(forKey: coreDataKeys_MoodLog_Events.upload_type), forKeyPath: coreDataKeys_MoodLog_Events.upload_type)
        
        MOODLogEntity.setValue(dic.value(forKey: coreDataKeys_MoodLog_Events.file_name_audio), forKeyPath: coreDataKeys_MoodLog_Events.file_name_audio)
        
        MOODLogEntity.setValue(dic.value(forKey: coreDataKeys_MoodLog_Events.file_name_video), forKeyPath: coreDataKeys_MoodLog_Events.file_name_video)
        
        MOODLogEntity.setValue(dic.value(forKey: coreDataKeys_MoodLog_Events.events_activity), forKeyPath: coreDataKeys_MoodLog_Events.events_activity)
        
        
        return MOODLogEntity
    }
    
}
