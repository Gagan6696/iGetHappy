//
//  LanguagePresenter.swift
//  IGetHappy
//
//  Created by Gagan on 7/4/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.

import Foundation
protocol LanguagePreferenceDelegate : class {
    func LanguagePreferenceDidSucceeed(languagesData:[AllLanguages]?)
    func LanguagePreferenceDidFailed()
}
class LanguagePresenter{
    //Register Delegate
    var delegate:LanguagePreferenceDelegate
    // Login Controllers weak object to save from being retain cycle
    weak var languagePreferenceDelegateView: LanguagePreferenceViewDelegate?
    
    init(delegate:LanguagePreferenceDelegate) {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: LanguagePreferenceViewDelegate) {
        languagePreferenceDelegateView = view
    }
    //Detaching login view
    func detachView() {
       languagePreferenceDelegateView = nil
    }
    
    func getLanguages(currentLocale:String){
        let appendUrl = UrlStrings.Languages.getLanguages + currentLocale
        AuthenticationService.sharedInstance.FindLanguagesService(url: appendUrl, completionResponse: { (languagesData) in
            self.languagePreferenceDelegateView?.hideLoader()
            if (languagesData.data?.count)! > 0 {
                self.delegate.LanguagePreferenceDidSucceeed(languagesData: languagesData.data?[0].languages)
            }
        }, completionnilResponse: { (message) in
            self.languagePreferenceDelegateView?.hideLoader()
            self.languagePreferenceDelegateView?.showAlert(alertMessage: message)
        }, completionError: { (error) in
            print(error)
             self.languagePreferenceDelegateView?.hideLoader()
            self.languagePreferenceDelegateView?.showAlert(alertMessage: "\(error)")
        }) { (networkerror) in
             self.languagePreferenceDelegateView?.hideLoader()
            self.languagePreferenceDelegateView?.showAlert(alertMessage: Constants.Global.MessagesStrings.ServerError)
            
        }
        
    }
    
    func Validations(language:[String?]) throws{
       
        
        if(language.isEmpty){
            throw ValidationError.SelectLanguage.selectlang
        }
        
    }
}
