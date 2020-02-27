//
//  StartUpVC.swift
//  IGetHappy
//
//  Created by Gagan on 5/15/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.


import UIKit
import ImageSlideshow
import AttributedTextView

protocol StartUpViewDelegate : class {
    func showAlert(Message: String)
    func showLoader()
    func hideLoader()
}
class StartUpVC: BaseUIViewController {
    
    @IBOutlet weak var terms: UIButton!
    @IBOutlet weak var carousel: ZKCarousel!  = ZKCarousel()
    @IBOutlet weak var attributedTextView: AttributedTextView!
    
    var presenter:StartUpPresenter?
    var aceeptTerms:Bool? = false
    
    var fb: FaceBook?
    var google : Google?
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoggedIn()
        self.setupCarousel()
        fb = FaceBook.init(viewController: self, delegate: self)
        google = Google.init(viewController: self, delegate: self)
        self.presenter = StartUpPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        //self.HideNavigationBar(navigationController: self.navigationController!)
        self.setAttributedText()
    }
    private func setupCarousel() {
       
        
        let slide = ZKCarouselSlide(title: "", description: "lorem ipsum devornum cora fusoa foen sdie ha odab ebakldf shjbesd ljkhf", image: UIImage.init(named: "homeBg"))
        let slide1 = ZKCarouselSlide(title: "", description: "lorem ipsum devornum cora fusoa foen sdie ha odab ebakldf shjbesd ljkhf", image: UIImage.init(named: "homeBg"))
        let slide2 = ZKCarouselSlide(title: "", description: "lorem ipsum devornum cora fusoa foen sdie ha odab ebakldf shjbesd ljkhf", image: UIImage.init(named: "homeBg"))
        
        // Add the slides to the carousel
        self.carousel.slides = [slide, slide1, slide2] //, slide3, slide4, slide5]
        
        // You can optionally use the 'interval' property to set the timing for automatic slide changes. The default is 1 second.
        self.carousel.interval = 3
        
        // Optional - automatic switching between slides.
        self.carousel.start()
    }
    
    func setAttributedText() {
        attributedTextView.attributer = "Terms & Conditions".makeInteract { _ in
               CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .TermsVC, Data: nil)
            }.underline
            .all.font(UIFont.systemFont(ofSize: 14))
            .setLinkColor(UIColor(red: 0.25, green: 0.66, blue: 0.89, alpha: 1))
    }
    
    @IBAction func go_To_Fb(_ sender: Any) {
        
        if (checkInternetConnection()){
            if(aceeptTerms!){
                self.showLoader()
                fb?.LoginIntoFacebook()
            }else{
                self.view.makeToast("Please agree to the Terms and Conditions")
            }
        }else{
             self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
        }
    }
    
    func isLoggedIn(){
        let result = UserDefaults.standard.getLoggedIn()
        if(result ?? false){
            CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Home, Data: nil)
        }else{
            
        }
    }
    
    @IBAction func termsAndCondition(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            aceeptTerms = false
        }else{
            aceeptTerms = true
        }
    }
    @IBAction func go_To_Google(_ sender: Any) {
        if (checkInternetConnection()){
            if(aceeptTerms!){
                self.showLoader()
                google?.LoginIntoGoogle()
            }else{
                self.view.makeToast("Please agree to the Terms and Conditions")
            }
        }else{
            self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
        }
        
        
    }
    
    @IBAction func go_Via_Email(_ sender: Any)
    {
        
        if (checkInternetConnection()){
            
            if(aceeptTerms!){
                CommonFunctions.sharedInstance.clearUserDefaults()
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")as! LoginVC
                self.navigationController?.pushViewController(controller, animated: true)
            }else{
                self.view.makeToast("Please agree to the Terms and Conditions")
            }
        }else{
            self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
        }
       
        //self.clearUserDefaults()
        //self.clearUserDefaultsSimpleLogin()
       // CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Login, Data: nil)
        
        
    }
    
}
extension StartUpVC:FacebookDelegate{
    func Success(result: NSDictionary) {
        print(result)
         hideLoader()
        self.presenter?.Login(email:UserDefaults.standard.getEmail(),Passowrd: "Seasia@123",social_id:UserDefaults.standard.getUserId())
        
        //presenter?.CheckEmailExist(email: UserDefaults.standard.getEmail())
        //CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .StartBegin, Data: nil)
    }
    
    func Failure(message: String) {
         hideLoader()
    }
    
}
extension StartUpVC:GoogleDelagate{
    func Success(result: String) {
         hideLoader()
        self.presenter?.Login(email:UserDefaults.standard.getEmail(),Passowrd: "Seasia@123",social_id:UserDefaults.standard.getUserId())
        //          presenter?.CheckEmailExist(email: UserDefaults.standard.getEmail())
        // CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .StartBegin, Data: result)
        print(result)
    }
    
    func Fail(message: String) {
        hideLoader()
    }
    
}
extension StartUpVC:StartUpDelegate{
    func LoginDidSucceeed() {
        hideLoader()
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Home, Data: nil)
    }
    
    func LoginDidFailed(message: String?) {
        hideLoader()
        
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .StartBegin, Data: nil)
    }
    
    func CheckEmailFailed(message: String?) {
        hideLoader()
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .StartBegin, Data: nil)
    }
    
    func CheckEmailPassed() {
        hideLoader()
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Home, Data: nil)
    }
    
}
extension StartUpVC:StartUpViewDelegate{
    func showLoader() {
        self.ShowLoaderCommon()
    }
    
    func hideLoader() {
        self.HideLoaderCommon()
    }
    
}
