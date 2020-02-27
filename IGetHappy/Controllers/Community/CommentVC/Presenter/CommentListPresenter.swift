//
//  CommentListPresenter.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/4/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation

protocol CommentListDelegate : class
{
    func DidSucceeed()
    func DidFailed(message:String?)
}
