//
//  MenuVC.swift
//  IGetHappy
//
//  Created by Gagan on 6/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit


class MenuVC: BaseUIViewController  {
    
    var array = ["Happy Memories","Mood Logs","My Vents","Documents","Reminders","My Appointments","Care Receivers","Community","Chat Bot","Meditation","Help and Support","Settings","Logout"]
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        
        if let firstName  = UserDefaults.standard.getFirstName(), let lastName = UserDefaults.standard.getLastName() {
            let name = firstName + " " + lastName
            self.profileName.text = name
        }
        
        //        if let profilImage = UserDefaults.standard.getProfileImage(){
        //            self.profileImage.kf.setImage(with: URL.init(string: profilImage))
        //        }
        
        let url = URL(string:  UserDefaults.standard.getProfileImage() ?? "")
        
        self.profileImage?.kf.indicatorType = .activity
        self.profileImage?.kf.setImage(
            with: url,
            placeholder: UIImage(named: "community_listing_user"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.view.isUserInteractionEnabled = true
        //        self.revealViewController().view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().frontViewController.revealViewController().tapGestureRecognizer()
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.revealViewController().frontViewController.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = true
    }
    
    @IBAction func actionMyProfile(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "SideBarOptions", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: MyProfileVC.className)
        let frontVC = revealViewController().frontViewController as? UINavigationController
        frontVC?.pushViewController(vc, animated: false)
        revealViewController().pushFrontViewController(frontVC, animated: true)
        
    }
}

extension MenuVC : UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        var newFrontController: UIViewController? = nil
        if ( indexPath.row == 0)
        {
            self.view.isUserInteractionEnabled = false
            // self.view.makeToast(Constants.Global.MessagesStrings.ComingSoon)
            
            let storybaord = UIStoryboard.init(name:"HappyMemories", bundle: nil)
            if let presentedViewController = storybaord.instantiateViewController(withIdentifier: "AddHappyMemoriesNav") as? UIViewController
            {
                let frontVC = revealViewController().frontViewController as? UINavigationController
                presentedViewController.providesPresentationContextTransitionStyle = true
                presentedViewController.definesPresentationContext = true
                presentedViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
                presentedViewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                frontVC?.present(presentedViewController, animated: false)
            //frontVC?.present(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)(presentedViewController, animated: false)
             revealViewController().pushFrontViewController(frontVC, animated: true)
            }
            
            
//            let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: HomeVC.className)
//            let frontVC = revealViewController().frontViewController as? UINavigationController
//            frontVC?.pushViewController(vc, animated: false)
//            revealViewController().pushFrontViewController(frontVC, animated: true)
            
        }
        else if ( indexPath.row == 1)
        {
            self.view.isUserInteractionEnabled = false
            let storyboard = UIStoryboard.init(name: "SideBarOptions", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: MoodLogAndStatBaseVC.className)
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            
            // CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .MoodLogAndStatBase, Data: nil)
            
        }
        else if ( indexPath.row == 2)
        {
            self.view.isUserInteractionEnabled = false
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: MyVentsTabVC.className)
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            // self.view.makeToast(Constants.Global.MessagesStrings.ComingSoon)
            
        }
        else if ( indexPath.row == 3)
        {
            
            self.view.makeToast(Constants.Global.MessagesStrings.ComingSoon)
        }
        else if ( indexPath.row == 4)
        {
            self.view.isUserInteractionEnabled = false
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: RemindersVC.className)
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            
            // CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .ReminderVC, Data: nil)
            
        }
        else if ( indexPath.row == 5)
        {
            self.view.makeToast(Constants.Global.MessagesStrings.ComingSoon)
        }
        else if ( indexPath.row == 6)
        {
            self.view.isUserInteractionEnabled = false
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: CareReceiverVC.className)
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            
            //  self.view.makeToast(Constants.Global.MessagesStrings.ComingSoon)
            
        }
        else if ( indexPath.row == 7)
        {
            self.view.isUserInteractionEnabled = false
            let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CommunityListingViewController")
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            
        }
        else if ( indexPath.row == 8)
        {
            //Reminder
            //            let storyboard = UIStoryboard.init(name: "SideBarOptions", bundle: nil)
            //            let vc = storyboard.instantiateViewController(withIdentifier: MyProfileVC.className)
            //            let frontVC = revealViewController().frontViewController as? UINavigationController
            //            frontVC?.pushViewController(vc, animated: false)
            //            revealViewController().pushFrontViewController(frontVC, animated: true)

            //            var revealController = self.revealViewController
            self.view.makeToast(Constants.Global.MessagesStrings.ComingSoon)
            
        }
        else if ( indexPath.row == 9)
        {
            self.view.isUserInteractionEnabled = false
            let storyboard = UIStoryboard.init(name: "Meditation", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: MeditationPagerVC.className)
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
        }
        else if ( indexPath.row == 9)
        {
            self.view.makeToast(Constants.Global.MessagesStrings.ComingSoon)
            
        }
        else if ( indexPath.row == 10)
        {
            self.view.makeToast(Constants.Global.MessagesStrings.ComingSoon)
            
        }
        else if ( indexPath.row == 11)
        {
            
            self.view.makeToast(Constants.Global.MessagesStrings.ComingSoon)
            
        }
        else if ( indexPath.row == 12)
        {
            
            self.dismiss(animated: true, completion: nil)
            
            self.AlertMessageWithOkCancelAction(titleStr: Constants.Global.ConstantStrings.KAppname, messageStr: "Do you want to logout?", Target: self) { (action) in
                if action == "Yes"
                {
                    CommonFunctions.sharedInstance.clearUserDefaults()
                    //self.clearUserDefaults()
                    //CommonFunctions.sharedInstance.SetRootViewController(rootVC: .LoginNavigation)
                    
                    let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
                    let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "StartUpVCNav")
                    
                    Constants.Global.ConstantStrings.KappDelegate.window = UIWindow(frame: UIScreen.main.bounds)
                    Constants.Global.ConstantStrings.KappDelegate.window?.rootViewController = initialViewControlleripad
                    Constants.Global.ConstantStrings.KappDelegate.window?.makeKeyAndVisible()
                    
                    
                    //CommonFunctions.sharedInstance.popTocontroller(from: self)
                }
            }
            
            //CommonFunctions.sharedInstance.SetRootViewController(rootVC: .LoginNavigation)
            //self.view.makeToast(Constants.Global.MessagesStrings.ComingSoon)
            
        }
        
        
        //
        //        if ( indexPath.row == 2) {
        //
        //            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        //            let vc = storyboard.instantiateViewController(withIdentifier: "ThirdVC")
        //            let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //
        //            appDelegate.window!.rootViewController = vc
        //
        //        }
        
        
        
        
        
        
        
    }


func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
{
    return   array.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
{
    let cell = tableView.dequeueReusableCell(withIdentifier: "Menu") as! MenuTVC
    cell.selectionStyle = UITableViewCell.SelectionStyle.none
    cell.lbl_Menu.text =     "\(self.array[indexPath.row])"
    return cell
}
}
