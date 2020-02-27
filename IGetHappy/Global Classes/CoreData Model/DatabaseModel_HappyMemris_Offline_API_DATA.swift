//
//  DatabaseModel_HappyMemris_Offline_API_DATA.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 12/4/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DatabaseModel_HappyMemris_Offline_API_DATA: NSObject
{

    static let myAppDelegate = Constants.Global.ConstantStrings.KappDelegate
    static let managedContext = myAppDelegate.persistentContainer.viewContext
    
    
    //MARK: <------------------ SAVE HAPPY MEMORIES GALLLERY OFFLINE IN DATABASE --------------------->
    class func save_HappyMemris_Changes_offline(data_for_save : NSDictionary)
    {
        
        let userEntity = NSEntityDescription.entity(forEntityName: Constants.Global.ConstantStrings.KDatabase_Happy_Memories_Changes, in: DatabaseModel_HappyMemris_Offline_API_DATA.managedContext)!
        
        let MEMORIES = NSManagedObject(entity: userEntity, insertInto: DatabaseModel_HappyMemris_Offline_API_DATA.managedContext)
        
        MEMORIES.setValue(data_for_save.value(forKey: coreDataKeys_HappyMemories_Changes.audio_path),forKey: coreDataKeys_HappyMemories_Changes.audio_path)
        
        MEMORIES.setValue(data_for_save.value(forKey: coreDataKeys_HappyMemories_Changes.video_path),forKey: coreDataKeys_HappyMemories_Changes.video_path)
        
        MEMORIES.setValue(data_for_save.value(forKey: coreDataKeys_HappyMemories_Changes.group),forKey: coreDataKeys_HappyMemories_Changes.group)
        
        MEMORIES.setValue(data_for_save.value(forKey: coreDataKeys_HappyMemories_Changes.image_data),forKey: coreDataKeys_HappyMemories_Changes.image_data)
        
        MEMORIES.setValue(data_for_save.value(forKey: coreDataKeys_HappyMemories_Changes.type),forKey: coreDataKeys_HappyMemories_Changes.type)
        
        MEMORIES.setValue(data_for_save.value(forKey: coreDataKeys_HappyMemories_Changes.user_id),forKey: coreDataKeys_HappyMemories_Changes.user_id)
        
        MEMORIES.setValue(data_for_save.value(forKey: coreDataKeys_HappyMemories_Changes.location),forKey: coreDataKeys_HappyMemories_Changes.location)
        
        MEMORIES.setValue(data_for_save.value(forKey: coreDataKeys_HappyMemories_Changes.desc),forKey: coreDataKeys_HappyMemories_Changes.desc)
       
        //Now we have set all the values. The next step is to save them inside the Core Data
        
        do
        {
            try DatabaseModel_HappyMemris_Offline_API_DATA.managedContext.save()
           // success(Constants.Global.ConstantStrings.KSaved)
        }
        catch let error as NSError
        {
            let errorStr = ("\(Constants.Global.ConstantStrings.KNotSaved) \(error), \(error.userInfo)")
            print(errorStr)
          //  failure(errorStr)
        }
        
        
    }
    
    
    //MARK: <------------------ DELETE HAPPY MEMORIES GALLERY OFFLINE FROM DATABASE --------------------->
    class func delete_DATA_FROM_coreData_for_HappyMemoris_Changes(groupKEY : String,success: @escaping (String) -> Void, failure: @escaping (String) -> Void)
    {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Global.ConstantStrings.KDatabase_Happy_Memories_Changes)
      //  let groupKey_name = coreDataKeys_HappyMemories_Changes.group
      //  let userKey_name = coreDataKeys_HappyMemories_Changes.user_id
       // let userID = UserDefaults.standard.getUserId() ?? ""
        
       // fetchRequest.predicate = NSPredicate(format: "\(groupKey_name) = %@ AND \(userKey_name) = %@", groupKEY,userID)
        
        do
        {
            let test = try DatabaseModel_HappyMemris_Offline_API_DATA.managedContext.fetch(fetchRequest)
            
            if (test.count > 0)
            {
                
                for obj in test
                {
                    let objectToDelete = obj as! NSManagedObject
                    DatabaseModel_HappyMemris_Offline_API_DATA.managedContext.delete(objectToDelete)
                    do
                    {
                        try DatabaseModel_HappyMemris_Offline_API_DATA.managedContext.save()
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
    
    
    
    
    class func get_offline_saved_Happy_memris_for_upload(groupKEY : String,success: @escaping (NSArray) -> Void, failure: @escaping (String) -> Void)
    {
        
        let managedContext2 = myAppDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Global.ConstantStrings.KDatabase_Happy_Memories_Changes)
        
        let groupKey_name = coreDataKeys_HappyMemories_Changes.group
        let userKey_name = coreDataKeys_HappyMemories_Changes.user_id
        
        let userID = UserDefaults.standard.getUserId() ?? ""
        fetchRequest.predicate = NSPredicate(format: "\(groupKey_name) = %@ AND \(userKey_name) = %@", groupKEY,userID)
        
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
    
    
}
