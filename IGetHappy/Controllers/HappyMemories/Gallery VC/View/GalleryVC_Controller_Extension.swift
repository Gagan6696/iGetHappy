//
//  GalleryVC_Controller_Extension.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/29/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import AVFoundation

class GalleryVC_Controller_Extension: NSObject
{
    
    static var Ref_GalleryVC:GalleryVC?
    static var arrData = NSMutableArray()
    
    class func download_file_from_server(fileURL:String,tag:Int,arr:NSMutableArray,successArr: @escaping (NSMutableArray) -> Void,failureResult: @escaping (String) -> Void)
    {
        
        if (fileURL.count > 0)
        {
            let myURL = URL(string:fileURL)
            let dic = arr.object(at: tag)as? NSMutableDictionary
            let tbID = dic?.value(forKey: coreDataKeys_HappyMemories.table_id)as? String ?? ""
            let type = dic?.value(forKey: coreDataKeys_HappyMemories.type)as? String ?? ""
            
            var path = ""
            
            if(type == "AUDIO")
            {
                path = "\(tbID).m4a"
            }
            if(type == "VIDEO")
            {
                path = "\(tbID).mp4"
            }
            
            
            if (type == "IMAGE")
            {
                
                //CONVETING IMAGE INTO BASE 64
                let base64 = CommonVc.AllFunctions.genrate_image_from_url(fileName: fileURL)
                if (base64.count > 0)
                {
                    //SAVING RETURNED FILE IN COREDATA
                    dic?.setValue(base64, forKey: coreDataKeys_HappyMemories.asset)
                  //  dic?.setValue("", forKey: coreDataKeys_HappyMemories.url)
                    dic?.setValue("1", forKey: coreDataKeys_HappyMemories.is_downloaded)
                    dic?.setValue("1", forKey: coreDataKeys_HappyMemories.is_offline)
                    
                    self.UPDATE_CORE_DATA_FOR_DOWNLOADED_FILES(dic: dic!, tag: tag, arr: arr, success: { (sccss) in
                        
                        successArr(sccss)
                        
                    }, failure: { (err) in
                        
                        failureResult(err)
                    })
                    
                }
                else
                {
                    failureResult("Sorry! Something went wrong. Please try again after sometime.")
                }
                
            }
            else
            {
                
                //DOWNLOAD AUDIO AND VIDEO
                GalleryVC_Controller_Extension.Ref_GalleryVC?.download_file(url: myURL!, pathNAme: path, completion: { (URL, err) in
                    if (err == nil)
                    {
                        let fileName = "\(String(describing: myURL?.lastPathComponent))"
                        print(fileName)
                        
                        //SAVING RETURNED FILE IN COREDATA
                        dic?.setValue(path, forKey: coreDataKeys_HappyMemories.url)
                        dic?.setValue("1", forKey: coreDataKeys_HappyMemories.is_downloaded)
                        dic?.setValue("1", forKey: coreDataKeys_HappyMemories.is_offline)
                        
                        let base64 = CommonVc.AllFunctions.genrate_base64_from_data(fileName: path)
                        dic?.setValue(base64, forKey: coreDataKeys_HappyMemories.asset)
                        
                        self.UPDATE_CORE_DATA_FOR_DOWNLOADED_FILES(dic: dic!, tag: tag, arr: arr, success: { (sccss) in
                            
                            successArr(sccss)
                            
                        }, failure: { (err) in
                            
                            failureResult(err)
                            
                        })
                    }
                    else
                    {
                        failureResult("\(err.debugDescription)")
                    }
                })
                
            }
        }
        else
        {
            failureResult("File URL not available!")
        }
        
    }
    
    
    
    class func UPDATE_CORE_DATA_FOR_DOWNLOADED_FILES(dic:NSMutableDictionary,tag:Int,arr:NSMutableArray,success: @escaping (NSMutableArray) -> Void,failure: @escaping (String) -> Void)
    {
        DatabaseModel_Gallery.save_GALLERY_offline_in_coreData(data_for_save: dic, success: { (result) in
            
            let tmpArr : NSMutableArray = arr.mutableCopy() as! NSMutableArray
            tmpArr.replaceObject(at: tag, with: dic as Any)
            let reArray = tmpArr.mutableCopy() as! NSMutableArray
            success(reArray)
            
        }) { (error) in
            print(error)
            failure(error)
        }
    }
    
    
    class func match_already_downloaded_happy_memories_with_server_files(fileURL:String) -> Bool
    {
        var val = false
        if (GalleryVC_Controller_Extension.arrData.count > 0)
        {
            for obj in GalleryVC_Controller_Extension.arrData
            {
                let dic = obj as! NSDictionary
               // let uniqID = dic.value(forKey: coreDataKeys_HappyMemories.unique_id)as? String ?? ""
                let fileID = dic.value(forKey: coreDataKeys_HappyMemories.file_URI)as? String ?? ""
                
                if (fileID == fileURL)
                {
                    val = true
                    break
                }
            }
        }
        
        return val
    }
    
    class func get_saved_happy_memories()
    {
        DatabaseModel_Gallery.get_offline_saved_GALLERY(success: { (arr) in
            
            GalleryVC_Controller_Extension.arrData = NSMutableArray(array: arr)
            
        }, failure: { (error) in
            print(error)
        })
    }
    
}
