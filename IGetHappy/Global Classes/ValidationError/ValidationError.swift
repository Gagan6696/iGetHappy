//
//  ValidationError.swift
//  IGetHappy
//
//  Created by Gagan on 5/16/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
class ValidationError{
    
   
    enum Login: Error{
        case emptyUserName
        case emptyPassword
        case weakPassword
        case wrongEmail
        case MinLength
        case emailMinLength
        case emptyPhoneNumber
        case minPhoneNumber
        case invalidEmailPhone
       
    }
    
    
    enum AboutTab: Error{
        
        case emptyEmail
        case emptyFirstname
        case emptyRelationship
        case wrongEmail
        case minEmailLength
        
    }
    enum Register: Error{
     
        case emptyEmailAndPhone
        case emptyEmail
        case emptyPhoneNumber
        case emptyPassword
        case weakPassword
        case wrongEmail
        case wrongPhoneNum
        case MinLength
        case emailMinLength
        case minPhoneNumber
        case wrongPhoneNumber
        case minEmailLength
        
    }
    enum AddCareReciever: Error{
        case emptyProfilePic
        case MinLengthName
        case emptyName
        case phoneNumberMinLength
        case emptyPhoneNumber
        case emptyEmail
        case wrongEmail
        case emailMinLength
        case validPhoneNumber
        case emptyRelation
        
    }
    enum Forgot: Error{
        case emptyEmail
        case wrongEmail
        case emailMinLength
        case emptyPhoneNumber
        case phoneMinLength
        case invalidPhoneNumber
        
    }
    enum UserProfileSetup: Error{
        case MinLengthFirstName
        case MinLengthLastName
        case MinLengthNickName
        case emptyFirstName
        case emptyLastName
        case emptyNickName
        case emptyProfileImage
        case emptyProfession
        
    }
    enum SelectGender: Error{
        case selectGender
        case selectDOB
    }
    enum SelectLanguage: Error{
        case selectlang
       
    }
    enum AddPost: Error{
        case emptyText
        case emptyPrivacy
        case emptyisAnonymous
        case emptyFile
        case textMaxLength
        
    }
    
}
