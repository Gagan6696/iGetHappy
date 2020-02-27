//
//  BaseTabVC.swift
//  IGetHappy
//
//  Created by Gagan on 5/30/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
protocol BaseTabViewDelegate:class
{
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
}

class BaseTabVC: BaseUIViewController {
    
    @IBOutlet weak var btnSample2: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var slider1: UIView!
    @IBOutlet weak var slider2: UIView!
    @IBOutlet weak var sampleButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var floatView: UIView!
    @IBOutlet weak var floatViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var myImg: UIImageView!
    
    var presenter:BaseTabPresenter?
    //MARK:- Variables
    var circularMenu: IGCMenu?
    
    var selectedIndex: Int = 0
    var previousIndex: Int = 0
    
    var viewControllers = [UIViewController]()
    
    @IBOutlet var buttons:[UIButton]!
    @IBOutlet var tabView:UIView!
    var footerHeight: CGFloat = 50
    
    static let firstVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: CommunityListingViewController.className)
    static let secondVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "CommunityChatVC")
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        self.presenter = BaseTabPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        viewControllers.append(BaseTabVC.firstVC)
        viewControllers.append(BaseTabVC.secondVC)
        buttons[selectedIndex].isSelected = true
        tabChanged(sender: btnLeft)
        
        
        self.customizeCircularMenu()
        //self.floatView.bringSubviewToFront(tabView)
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(gestureHandlerMethod(sender:)))
        
//        floatView.addGestureRecognizer(tapGesture)
        
        //floatView.backgroundColor = .red
        
        
        
       // decreaseView_Height()
        
      //  self.decreaseView_Height()
       // floatView.alpha = 0
        //self.view.bringSubviewToFront(btnRight)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.view.bringSubviewToFront(floatView)
        floatView.isUserInteractionEnabled = false;
        self.view.bringSubviewToFront(btnLeft)
        self.view.bringSubviewToFront(btnRight)
        self.view.bringSubviewToFront(btnSample2)
    }
    
    
    @objc func gestureHandlerMethod(sender:UIGestureRecognizer)
    {
        sampleButtonAction(sampleButton)
    }
    
    func customizeCircularMenu()
    {
        if circularMenu == nil
        {
            circularMenu = IGCMenu()
        }
        circularMenu?.menuButton = sampleButton //Pass refernce of menu button
        circularMenu?.menuSuperView = floatView
        circularMenu?.numberOfMenuItem = 3
        circularMenu?.menuItemsNameArray = ["Text", "Audio", "Video"]
        circularMenu?.menuImagesNameArray = ["baseTabWrite", "baseTabAudio", "baseTabVideo"]
        circularMenu?.delegate = self
    }
    
    @IBAction func sampleButtonAction(_ sender: UIButton)
    {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected
        {
            //self.increaseView_Height()
            floatView.isUserInteractionEnabled = true;
            circularMenu?.showCircularMenu()
        }
        else
        {
            //self.decreaseView_Height()
            floatView.isUserInteractionEnabled = false;
            circularMenu?.hideCircularMenu()
        }
    }
    
    
    
}

// MARK: - Actions
extension BaseTabVC
{
    
    @IBAction func tabChanged(sender:UIButton)
    {
        previousIndex = selectedIndex
        selectedIndex = sender.tag
        if(selectedIndex == 1){
            slider1.isHidden = true
            slider2.isHidden = false
        }else{
            slider1.isHidden = false
            slider2.isHidden = true
        }
        buttons[previousIndex].isSelected = false
        let previousVC = viewControllers[previousIndex]
        
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
        sender.isSelected = true
        
        let vc = viewControllers[selectedIndex]
        vc.view.frame = UIApplication.shared.windows[0].frame
        vc.didMove(toParent: self)
        self.addChild(vc)
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(floatView)
        
        
        self.view.bringSubviewToFront(btnLeft)
        self.view.bringSubviewToFront(btnRight)
        self.view.bringSubviewToFront(btnSample2)
    }
    
    
    func hideHeader()
    {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            if #available(iOS 11.0, *) {
                self.tabView.frame = CGRect(x: self.tabView.frame.origin.x, y: (self.view.frame.height + self.view.safeAreaInsets.bottom + 16), width: self.tabView.frame.width, height: self.footerHeight)
            } else {
                // Fallback on earlier versions
            }
        })
    }
    
    func showHeader() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            if #available(iOS 11.0, *) {
                self.tabView.frame = CGRect(x: self.tabView.frame.origin.x, y: self.view.frame.height - (self.footerHeight + self.view.safeAreaInsets.bottom + 16), width: self.tabView.frame.width, height: self.footerHeight)
            } else {
                // Fallback on earlier versions
            }
        })
    }
}
extension BaseTabVC: IGCMenuDelegate {
    func igcMenuSelected(_ selectedMenuName: String?, at index: Int) {
        
        circularMenu?.hideCircularMenu()
        sampleButton.isSelected = false
        
        switch index {
        case 0:
            //Do something
            CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .WriteThoughts, Data: nil)
            
            break
        case 1:
            //Do something
            CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .AudioRecord, Data: nil)
            
            break
        case 2:
            //Do something
//            SingletonPost.sharedInstance.isEditingMode = false
            CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .VideoRecord, Data: false)
            break
        default:
            break
        }
    }
}
extension BaseTabVC:BaseTabDelegate{
    func BaseTabDidSucceeed(message:String?)
    {
        self.showAlert(alertMessage: message!)
        
    }
    
    func BaseTabDidFailed(message:String?) {
        //self.showAlert(alertMessage: )
    }
}

extension BaseTabVC:BaseTabViewDelegate{
    func showAlert(alertMessage: String) {
        self.showAlert(Message: alertMessage)
    }
    
    func showLoader() {
        ShowLoaderCommon()
    }
    
    func hideLoader() {
        HideLoaderCommon()
    }
    
    
}

