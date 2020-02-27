//
//  DatabaseModel_Gallery.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/22/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DatabaseModel_Gallery: NSObject
{

    static let myAppDelegate = Constants.Global.ConstantStrings.KappDelegate
    static let managedContext = myAppDelegate.persistentContainer.viewContext
    
    
    
    class func get_offline_saved_GALLERY(success: @escaping (NSArray) -> Void, failure: @escaping (String) -> Void)
    {
        
        let managedContext2 = myAppDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Global.ConstantStrings.KDatabase_Happy_Memories_Gallery)
        
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
    
    
    
    //MARK: <------------------ SAVE HAPPY MEMORIES GALLLERY OFFLINE IN DATABASE --------------------->
    class func save_GALLERY_offline_in_coreData(data_for_save : NSDictionary,success: @escaping (String) -> Void, failure: @escaping (String) -> Void)
    {
        
        let userEntity = NSEntityDescription.entity(forEntityName: Constants.Global.ConstantStrings.KDatabase_Happy_Memories_Gallery, in: DatabaseModel_Gallery.managedContext)!
        
        let MEMORIES = NSManagedObject(entity: userEntity, insertInto: DatabaseModel_Gallery.managedContext)
        
        let asset =   data_for_save.value(forKey: coreDataKeys_HappyMemories.asset)
        
        
        MEMORIES.setValue(data_for_save.value(forKey: coreDataKeys_HappyMemories.file_URI),forKey: coreDataKeys_HappyMemories.file_URI)
        
        MEMORIES.setValue(asset,forKey: coreDataKeys_HappyMemories.asset)
        
        MEMORIES.setValue(data_for_save.value(forKey: coreDataKeys_HappyMemories.url),forKey: coreDataKeys_HappyMemories.url)
        MEMORIES.setValue(data_for_save.value(forKey: coreDataKeys_HappyMemories.location),forKey: coreDataKeys_HappyMemories.location)
        
        MEMORIES.setValue(data_for_save.value(forKey: coreDataKeys_HappyMemories.name), forKeyPath: coreDataKeys_HappyMemories.name)
        MEMORIES.setValue(data_for_save.value(forKey: coreDataKeys_HappyMemories.type), forKey: coreDataKeys_HappyMemories.type)
        MEMORIES.setValue(data_for_save.value(forKey: coreDataKeys_HappyMemories.user_id), forKey: coreDataKeys_HappyMemories.user_id)
        MEMORIES.setValue(data_for_save.value(forKey: coreDataKeys_HappyMemories.table_id), forKey: coreDataKeys_HappyMemories.table_id)
        
        MEMORIES.setValue(data_for_save.value(forKey: coreDataKeys_HappyMemories.is_offline), forKey: coreDataKeys_HappyMemories.is_offline)
        MEMORIES.setValue(data_for_save.value(forKey: coreDataKeys_HappyMemories.unique_id), forKey: coreDataKeys_HappyMemories.unique_id)
        
        MEMORIES.setValue(data_for_save.value(forKey: coreDataKeys_HappyMemories.is_downloaded), forKey: coreDataKeys_HappyMemories.is_downloaded)
        
        
        
        //Now we have set all the values. The next step is to save them inside the Core Data
        
        do
        {
            try DatabaseModel_Gallery.managedContext.save()
            success(Constants.Global.ConstantStrings.KSaved)
        }
        catch let error as NSError
        {
            let errorStr = ("\(Constants.Global.ConstantStrings.KNotSaved) \(error), \(error.userInfo)")
            failure(errorStr)
        }
        
        
    }
    
    
    
    //MARK: <------------------ DELETE HAPPY MEMORIES GALLERY OFFLINE FROM DATABASE --------------------->
    class func delete_GALLERY_offline_FROM_coreData(tableID : String,success: @escaping (String) -> Void, failure: @escaping (String) -> Void)
    {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Global.ConstantStrings.KDatabase_Happy_Memories_Gallery)
        let table_id = coreDataKeys_HappyMemories.table_id
        fetchRequest.predicate = NSPredicate(format: "\(table_id) = %@", tableID)
        
        do
        {
            let test = try DatabaseModel_Gallery.managedContext.fetch(fetchRequest)
            
            if (test.count > 0)
            {
                let objectToDelete = test[0] as! NSManagedObject
                DatabaseModel_Gallery.managedContext.delete(objectToDelete)
                
                do
                {
                    try DatabaseModel_Gallery.managedContext.save()
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
