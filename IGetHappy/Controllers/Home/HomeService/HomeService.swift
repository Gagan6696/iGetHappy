//
//  HomeService.swift
//  IGetHappy
//
//  Created by Gagan on 7/22/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
class  HomeService:NSObject{
    
    static let sharedInstance =  HomeService()
    
    
    func GetEmaotionService(image:UIImage?,url : String,completionResponse:  @escaping (String) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void,networkError: @escaping (String) -> Void) {
        ServiceCall.sharedManager.MultipartServiceFacialApi(type: .Image, urlString: url, fileData: image, requestDict: nil, method: .post, compBlock: { (responseDict, response) in
            if let message  = responseDict["prediction"] as? String{
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
