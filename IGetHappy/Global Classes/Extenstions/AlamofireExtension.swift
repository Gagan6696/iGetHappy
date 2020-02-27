//
//  AlamofireExtension.swift
//  IGetHappy
//
//  Created by Gagan on 2/6/20.
//  Copyright © 2020 AditiSeasia Infotech. All rights reserved.
//

import Foundation
import Alamofire
///Alomafire global structure to make timeinterval and one instance
struct AlamofireManager {
    static let shared: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        let sessionManager = Alamofire.SessionManager(configuration: configuration, delegate: SessionDelegate(), serverTrustPolicyManager: nil)
        return sessionManager
    }()
}
