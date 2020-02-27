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
    
    class func get_offline_saved_emoji(success: @escaping (NSDictionary) -> Void, failure: @escaping (String) -> Void)
    {
        
         let managedContext2 = myAppDelegate.persistentContainer.viewContext
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Global.ConstantStrings.KDatabase_Offline_Emoji)
        
        //        fetchRequest.fetchLimit = 1
        //        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur")
        //        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
        //
        do
        {
            let result = try managedContext2.fetch(fetchRequest)
            
            for data in result as! [NSDictionary]
            {
                print(data)
                success(data)
                break
            }
        }
        catch
        {
            failure("\(error.localizedDescription)")
        }
    }
    
    
    
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
    
    
    
    class func update_emoji_offline_in_coreData(data_for_save : NSDictionary,success: @escaping (String) -> Void, failure: @escaping (String) -> Void)
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
    
    
    
    func delete_emoji_offline_in_coreData(success: @escaping (String) -> Void, failure: @escaping (String) -> Void)
    {
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Global.ConstantStrings.KDatabase_Offline_Emoji)
       // fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur3")
        
        do
        {
            let test = try CoreData_Model.managedContext.fetch(fetchRequest)
            
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
        catch let error as NSError
        {
            let errorStr = ("\(Constants.Global.ConstantStrings.KNotSaved) \(error), \(error.userInfo)")
            failure(errorStr)
        }
    }
    
}

