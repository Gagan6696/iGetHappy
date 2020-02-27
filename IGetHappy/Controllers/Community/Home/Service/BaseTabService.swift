//
//  BaseTabService.swift
//  IGetHappy
//
//  Created by Gagan on 7/22/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
class  BaseTabService:NSObject{
    
    static let sharedInstance =  BaseTabService()
    
    
    func GetEmaotionService(urlMedia:URL,url : String,completionResponse:  @escaping (String) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void,networkError: @escaping (String) -> Void) {
        ServiceCall.sharedManager.MultipartServiceApi(type: .Image, urlMedia: urlMedia, urlString: url, fileData: nil, requestDict: nil, method: .post, compBlock: { (responseDict, response) in
            if let message  = responseDict["message"] as? String{
                print(message)
                completionResponse(message)
            }
            //let message = responseDict["message"] as! String
            
            //completionResponse(response.error)
        }) { (networkError) in
            completionnilResponse(networkError.localizedDescription)
            print(networkError)
        }
        
    }
    
    
}
