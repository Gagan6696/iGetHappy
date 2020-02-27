//
//  FeedServices.swift
//  IGetHappy
//
//  Created by Gagan on 7/18/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation

class FeedServices:NSObject{
    
    static let sharedInstance = FeedServices()
     var finalPostDict = [String : Any]()
    func AddTextPostService(url : String,postDict:[String : Any],completionResponse:  @escaping (String) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void,networkError: @escaping (String) -> Void)
    {
       
        finalPostDict = postDict
        finalPostDict["created_at"] = Utility.dateFromISOStringForCreatedAt(string: Date())
//        ServiceCall.sharedManager.PostApi(url: url, parameter: postDict, completionResponse: { (result) in
//
//            if (result.count > 0)
//            {
//               let msg = result["message"]as? String ?? "Post added successfully!"
//               completionResponse(msg)
//            }
//            else
//            {
//               completionResponse(Constants.Global.MessagesStrings.SomethingWentWrong)
//            }
//
//        }, completionnilResponse: { (errResponse) in
//            completionResponse(Constants.Global.MessagesStrings.SomethingWentWrong)
//        }, completionError: { (err) in
//            completionResponse(err?.localizedDescription ?? "Internal error!")
//        }) { (err) in
//            completionnilResponse(err.description)
//        }
        
        
        
        
        ServiceCall.sharedManager.MultipartServiceApi(type: .none, urlMedia: nil, urlString: url, fileData: nil, requestDict: finalPostDict, method: .post, compBlock: { (responseDict, response) in
            if let message  = responseDict["message"] as? String
            {
                print(message)
                completionResponse(message)
            }
            else
            {
                completionResponse(Constants.Global.MessagesStrings.SomethingWentWrong)
            }

             //let message = responseDict["message"] as! String

           //completionResponse(response.error)
        }) { (networkError) in
            completionnilResponse(networkError.localizedDescription)
            print(networkError)
        }
        
    }
    
    func editTextPatchService(url : String, postDict:[String : AnyObject],completionResponse:  @escaping (String) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void,networkError: @escaping (String) -> Void) {
        ServiceCall.sharedManager.serviceApi(url, requestDict: postDict as [String : AnyObject], method: .patch, compBlock: { (response, dataResponse) in
            if let message  = response["message"] as? String
            {
                print(message)
                completionResponse(message)
            }
            else
            {
                completionResponse(Constants.Global.MessagesStrings.SomethingWentWrong)
            }
        }) { (error) in
            print(error)
            completionError(error)
        }
    }
    
    func editAudioPatchService(url : String,fileUrl : URL, postDict:[String : AnyObject],completionResponse:  @escaping (String) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void,networkError: @escaping (String) -> Void) {
        
        ServiceCall.sharedManager.MultipartServiceApi(type: .Audio, urlMedia: fileUrl, urlString: url, fileData: nil , requestDict: postDict, method: .patch, compBlock: { (response, completeResponse) in
            if let message  = response["message"] as? String
            {
                print(message)
                completionResponse(message)
            }
            else
            {
                completionResponse(Constants.Global.MessagesStrings.SomethingWentWrong)
            }
            
        }) { (Error) in
            completionnilResponse(Error.localizedDescription)
            // completionError(Error.localizedDescription as? Error)
        }
    }
    
    func editVideoPatchService(url : String,fileUrl : URL, postDict:[String : AnyObject],completionResponse:  @escaping (String) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void,networkError: @escaping (String) -> Void) {
        
        ServiceCall.sharedManager.MultipartServiceApi(type: .Video, urlMedia: fileUrl, urlString: url, fileData: nil , requestDict: postDict, method: .patch, compBlock: { (response, completeResponse) in
            if let message  = response["message"] as? String
            {
                print(message)
                completionResponse(message)
            }
            else
            {
                completionResponse(Constants.Global.MessagesStrings.SomethingWentWrong)
            }
            
        }) { (Error) in
            completionnilResponse(Error.localizedDescription)
            // completionError(Error.localizedDescription as? Error)
        }
    }
    
    
    
    
    func AddVideoPostService(urlMedia:URL,url : String, postDict:[String : Any],completionResponse:  @escaping (String) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void,networkError: @escaping (String) -> Void) {
        
        
        finalPostDict = postDict
        finalPostDict["created_at"] = Utility.dateFromISOStringForCreatedAt(string: Date())
        
        
        ServiceCall.sharedManager.MultipartServiceApi(type: .Video, urlMedia: urlMedia, urlString: url, fileData: nil, requestDict: finalPostDict, method: .post, compBlock: { (responseDict, response) in
            if let message  = responseDict["message"] as? String
            {
                print(message)
                completionResponse(message)
            }
            else
            {
                completionResponse(Constants.Global.MessagesStrings.SomethingWentWrong)
            }
            
            //completionResponse(response.error)
        }) { (networkError) in
            completionnilResponse(networkError.localizedDescription)
            print(networkError)
        }
        
    }
    func AddSoundPostService(urlMedia:URL,url : String,postDict:[String : Any],completionResponse:  @escaping (String) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void,networkError: @escaping (String) -> Void) {
        print(postDict)
       
        finalPostDict = postDict
        finalPostDict["created_at"] = Utility.dateFromISOStringForCreatedAt(string: Date())
        ServiceCall.sharedManager.MultipartServiceApi(type: .Audio, urlMedia: urlMedia, urlString: url, fileData: nil, requestDict: finalPostDict, method: .post, compBlock: { (responseDict, response) in
            if let message  = responseDict["message"] as? String
            {
                print(message)
                completionResponse(message)
            }
            else
            {
                completionnilResponse(Constants.Global.MessagesStrings.SomethingWentWrong)
            }
           
        }) { (networkError) in
            completionnilResponse(networkError.localizedDescription)
            print(networkError)
        }
        
    }
    
}
