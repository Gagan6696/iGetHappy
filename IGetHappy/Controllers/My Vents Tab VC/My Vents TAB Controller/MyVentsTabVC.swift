//
//  MyVentsTabVC.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class MyVentsTabVC: UIViewController
{
    
    //MARK: <-OUTLETS ->
    @IBOutlet weak var mySegmentControl: UISegmentedControl!
    @IBOutlet weak var myContanerView: UIView!
    
    
    //MARK: <- VARIABLES->
    var myAllVentsTab = MyAllVentsTabVC()
    var myPrivateVentTab = MyPrivateVentTabVC()
    
    var currentController = UIViewController()
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.All_Vents_Selected()
        self.mySegmentControl.layer.cornerRadius = 10
        self.mySegmentControl.layer.masksToBounds = true
        self.mySegmentControl.layer.borderColor = UIColor.gray.cgColor
        self.mySegmentControl.layer.borderWidth = 1
    }
    
    @IBAction func ACTION_MOVE_BACK(_ sender: Any)
    {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    
    @IBAction func ACTION_FILTER(_ sender: Any)
    {
        
    }
    
    @IBAction func ACTION_SEARCH(_ sender: Any)
    {
        
    }
    
    @IBAction func ACTION_TABS_HANDLING(_ sender: Any)
    {
        if (self.mySegmentControl.selectedSegmentIndex == 0)
        {
            self.All_Vents_Selected()
        }
        else
        {
            self.Private_Vent_Selected()
        }
    }
    
    
    
    
    //MARK: <-HANDLING OF SELECTED TABS AND CHILD VIEW CONTROLLERS ->
    private var activeViewController: UIViewController?
    {
        didSet
        {
            removeInactiveViewController(inactiveViewController: oldValue)
            updateActiveViewController()
        }
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?)
    {
        if let inActiveVC = inactiveViewController
        {
            // call before removing child view controller's view from hierarchy
            inActiveVC.willMove(toParent: nil)
            
            inActiveVC.view.removeFromSuperview()
            
            // call after removing child view controller's view from hierarchy
            inActiveVC.removeFromParent()
        }
    }
    
    private func updateActiveViewController()
    {
        
        let mapViewController = self.currentController
        mapViewController.willMove(toParent: self)
        
        mapViewController.view.frame.size.width = self.myContanerView.frame.size.width
        mapViewController.view.frame.size.height = self.myContanerView.frame.size.height
        // Add to containerview
        self.myContanerView.addSubview(mapViewController.view)
        self.addChild(mapViewController)
        mapViewController.didMove(toParent: self)
    }
    
    
    func All_Vents_Selected()
    {
        self.currentController = (self.storyboard?.instantiateViewController(withIdentifier: "MyAllVentsTabVC") as? MyAllVentsTabVC)!
        self.activeViewController = self.currentController
    }
    
    func Private_Vent_Selected()
    {
        self.currentController = (self.storyboard?.instantiateViewController(withIdentifier: "MyPrivateVentTabVC") as? MyPrivateVentTabVC)!
        self.activeViewController = self.currentController
    }
}
