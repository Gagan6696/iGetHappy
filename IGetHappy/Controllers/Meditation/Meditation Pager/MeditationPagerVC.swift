//
//  MeditationPagerVC.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/15/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit


class MeditationPagerVC: UIViewController,CAPSPageMenuDelegate
{
    
    @IBOutlet weak var myPager: UIPageControl!
    var pageMenu : CAPSPageMenu?

    @IBOutlet weak var viewButtonBG: UIView!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        MeditationExplore.refrncPagerParent = self
        CommonVc.AllFunctions.addLOADER(controller: self)
        
    }
    
   

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        
        if (myPager.currentPage != 2)
        {
            self.setup_pager()
        }
        else
        {
            //nothing
          //  self.pageMenu?.view.frame = self.myView.frame
            self.viewDidLayoutSubviews()
        }
        
        
//        CommonVc.AllFunctions.addLOADER(controller: self)
//        // checking how it works controller issue when we play video and dismiss controller the here view will appear is called. So to prevent re load pager I am adding this check.
//        if Singleton.shared().isPlayerDismissed == false
//        {
//            self.setup_pager()
//            CommonVc.AllFunctions.hideLOADER(controller: self)
//        }
//        else
//        {
//            self.pageMenu?.removeFromParent()
//            self.setup_pager()
//            Singleton.shared().isPlayerDismissed = false
//            pageMenu!.moveToPage(2)
//            self.myPager.currentPage = 2
//            CommonVc.AllFunctions.hideLOADER(controller: self)
//        }

    }
    
    @objc func didTapGoToLeft()
    {
        let currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex > 0
        {
            pageMenu!.moveToPage(currentIndex - 1)
            self.myPager.currentPage = currentIndex - 1
        }
    }
    
    @objc func didTapGoToRight()
    {
        let currentIndex = pageMenu!.currentPageIndex
        self.myPager.currentPage = currentIndex + 1
        
    }
    
    func skip()
    {

        pageMenu!.moveToPage(4)
        self.myPager.currentPage = 5
        self.btnBack.isHidden = true
        self.btnNext.isHidden = true
        self.viewButtonBG.isHidden = true
    }
    
    @IBAction func moveback(_ sender: Any)
    {
        let currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex > 0
        {
            pageMenu!.moveToPage(currentIndex - 1)
             self.myPager.currentPage = currentIndex - 1
        }else{
            if currentIndex == 0{
                CommonFunctions.sharedInstance.popTocontroller(from: self)
            }
        }
    }
    
    @IBAction func moveNext(_ sender: Any)
    {
        let currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex < pageMenu!.controllerArray.count
        {
            if (currentIndex >= 3)
            {
                self.btnBack.isHidden = true
                self.btnNext.isHidden = true
                self.viewButtonBG.isHidden = true
            }
            else
            {
                self.btnBack.isHidden = false
                self.btnNext.isHidden = false
                self.viewButtonBG.isHidden = false
            }
            pageMenu!.moveToPage(currentIndex + 1)
            self.myPager.currentPage = currentIndex + 1
        }
    }
    
    
    
    // MARK: - Container View Controller
    
    //COULD NOT RESOLVE
    //    override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
    //        return true
    //    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool
    {
        return true
    }
    
    
    func willMoveToPage(_ controller: UIViewController, index: Int)
    {
        
    }
    
    func didMoveToPage(_ controller: UIViewController, index: Int)
    {
        self.handle_pager(index:index)
    }
    
    func handle_pager(index:Int)
    {
        self.myPager.currentPage = index
         MeditationHowItWorksVC.playerViewController.player?.pause()
        if (index >= 4)
        {
            self.btnBack.isHidden = true
            self.btnNext.isHidden = true
            self.viewButtonBG.isHidden = true
        }
        else
        {
            
            self.btnBack.isHidden = false
            self.btnNext.isHidden = false
            self.viewButtonBG.isHidden = false
        }
    }
    
    
    func setup_pager()
    {
        // MARK: - UI Setup
        self.title = "PAGE MENU"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<-", style: UIBarButtonItem.Style.done, target: self, action: #selector(MeditationPagerVC.didTapGoToLeft))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "->", style: UIBarButtonItem.Style.done, target: self, action: #selector(MeditationPagerVC.didTapGoToRight))
        
        // MARK: - Scroll menu setup
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        let story = UIStoryboard.init(name:
            "Meditation", bundle: nil)
        
        
        
        let controller1 = story.instantiateViewController(withIdentifier: "MeditationWecomeVC")as! MeditationWecomeVC
        controller1.title = "FRIENDS"
        controllerArray.append(controller1)
        
        let controller2 = story.instantiateViewController(withIdentifier: "MeditationSetGoalVC")as! MeditationSetGoalVC
        controller2.title = "MOOD"
        controllerArray.append(controller2)
        
        let controller3 = story.instantiateViewController(withIdentifier: "SetRemindersVC")as! SetRemindersVC
        controller3.title = "REMINDER"
        controllerArray.append(controller3)
        
        let controller4 = story.instantiateViewController(withIdentifier: "MeditationHowItWorksVC")as! MeditationHowItWorksVC
        controller4.title = "MUSIC"
        controllerArray.append(controller4)
        
        let controller5 = story.instantiateViewController(withIdentifier: "MeditationExplore")as! MeditationExplore
        controller5.title = "FAVORITES"
        controllerArray.append(controller5)
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.clear),
            .viewBackgroundColor(UIColor.clear),
            .selectionIndicatorColor(UIColor.clear),
            .bottomMenuHairlineColor(UIColor.clear),
            .menuHeight(0.0),
            .menuItemWidth(90.0),
            .centerMenuItems(true)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: self.myView.frame.origin.x, y: self.myView.frame.origin.y, width: self.myView.frame.size.width, height: self.myView.frame.size.height-20), pageMenuOptions: parameters)
        pageMenu?.delegate = self
        self.addChild(pageMenu!)
        self.myView.addSubview(pageMenu!.view)
        
        pageMenu!.didMove(toParent: self)
        CommonVc.AllFunctions.hideLOADER(controller: self)
    }
}

