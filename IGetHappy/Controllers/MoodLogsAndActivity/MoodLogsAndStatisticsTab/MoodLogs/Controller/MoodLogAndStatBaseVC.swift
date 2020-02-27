//
//  MoodLogAndStatBaseVC.swift
//  IGetHappy
//
//  Created by Gagan on 11/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class MoodLogAndStatBaseVC: UIViewController
{
    
    @IBOutlet weak var btnMoodLogs: UIButton!
    @IBOutlet weak var btnMoodStats: UIButton!
    static let firstVC = UIStoryboard(name: "SideBarOptions", bundle: nil).instantiateViewController(withIdentifier: MoodLogsVC.className)
    
    static let secondVC = UIStoryboard(name: "SideBarOptions", bundle: nil).instantiateViewController(withIdentifier: MoodStatisticsVC.className)
    
    @IBOutlet weak var viewForControllers: UIView!
    
    
    var statsTAB = secondVC
    var moodsTAB = firstVC
    var currentController = UIViewController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.actionMoodLogs(self)
    }
    
    @IBAction func actionMoodStat(_ sender: Any)
    {
        
        self.btnMoodLogs.setTitleColor(UIColor.black, for: UIControl.State.normal)
        self.btnMoodStats.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        
        
       STATS_Selected()
    }
    
    @IBAction func actionMoodLogs(_ sender: Any)
    {
        self.btnMoodLogs.setTitleColor(UIColor.white, for: UIControl.State.normal)
        self.btnMoodStats.setTitleColor(UIColor.black, for: UIControl.State.normal)
        
        MOOD_Selected()
    }
    
    @IBAction func actionback(_ sender: Any)
    {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    
    
    
    func STATS_Selected()
    {
        self.currentController = UIStoryboard(name: "SideBarOptions", bundle: nil).instantiateViewController(withIdentifier: MoodStatisticsVC.className) as? MoodStatisticsVC ?? UIStoryboard(name: "SideBarOptions", bundle: nil).instantiateViewController(withIdentifier: MoodStatisticsVC.className)
        
        
        
        self.activeViewController = self.currentController
    }
    
    func MOOD_Selected()
    {
        self.currentController = UIStoryboard(name: "SideBarOptions", bundle: nil).instantiateViewController(withIdentifier: MoodLogsVC.className)
        self.activeViewController = self.currentController
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
        
        mapViewController.view.frame.size.width = self.viewForControllers.frame.size.width
        mapViewController.view.frame.size.height = self.viewForControllers.frame.size.height
        // Add to containerview
        self.viewForControllers.addSubview(mapViewController.view)
        self.addChild(mapViewController)
        mapViewController.didMove(toParent: self)
    }
}
