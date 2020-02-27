//
//  SetRemindersVC.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 12/16/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import FSCalendar
import TPKeyboardAvoiding

class SetRemindersVC: UIViewController,UIScrollViewDelegate,UITextFieldDelegate
{
    
    @IBOutlet weak var view_Calender_Ongoing: FSCalendar!
    @IBOutlet weak var view_SelectTimeBG: UIView!
    @IBOutlet weak var tf_recurringMsg: UITextField!
    @IBOutlet weak var tf_alertTime_recurring: UITextField!
    @IBOutlet weak var view_selectAlertTime_recurring: RoundShadowView!
    @IBOutlet weak var height_recurringView: NSLayoutConstraint!
    @IBOutlet weak var tf_recurringEndDate: UITextField!
    @IBOutlet weak var tf_recurringStartDate: UITextField!
    @IBOutlet weak var view_Dates: RoundShadowView!
    @IBOutlet weak var ivOngoing: UIImageView!
    @IBOutlet weak var btnOngoing: UIButton!
    //MARK: <<<-----OUTLETS----->>>
    @IBOutlet weak var MyCollectionView: UICollectionView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var tf_Desc: UITextField!
    @IBOutlet weak var view_Recurring: UIVisualEffectView!
    
    @IBOutlet weak var myTableView_Recurring: UITableView!
    @IBOutlet weak var tfSelectTime: UITextField!
    @IBOutlet weak var myScrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var view_Calender: FSCalendar!
    @IBOutlet weak var view_AddTextAndOther: UIView!
    @IBOutlet weak var height_tableView: NSLayoutConstraint!
    
    @IBOutlet weak var btnSwitch: UISwitch!
    @IBOutlet weak var height_CalenderView: NSLayoutConstraint!
    
    @IBOutlet weak var btn_AddMore: UIButton!
    @IBOutlet weak var btn_viewReminders: UIButton!
    
    //MARK: <<<-----VARIABLES----->>>
    let cellID = "CellClass_SetReminderTable"
    let cellID_Recurring = "CellClass_Recurring"
    
    
    let cellIDCollec = "CellClass_SetReminder_CollectionView"
    let dataSource = ["Daily","Weekly","Monthly","Recurring"]
    var myCurrentIndex = 0
    var selectedApproach = "Daily"
    let datePicker = UIDatePicker()
    var selectedDates = [Date]()
    var tableID = ""
    var recurring_index = -1
    var recurring_startDate_selected = false
    var alertTime_recurring:Date?
    var recurring_alert_type:String?
    
    var last_date_not_ongoing: Date?
    var firstDate: Date?
    var lastDate: Date?
    var datesRange = [Date]()
    var arr_recurring = ["Repeat Every Day","Repeat Every Sunday","Repeat Every Monday","Repeat Every Tuesday","Repeat Every Wednesday","Repeat Every Thursday","Repeat Every Friday","Repeat Every Saturday"]
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        KQNotification.shared.notificationCenter.delegate = self
        self.view_Calender.layer.cornerRadius = 5
        self.view_Calender.layer.borderWidth = 1
        self.view_Calender.layer.borderColor = UIColor.gray.cgColor
        self.view_Calender.layer.masksToBounds = true
        
        self.view_Calender_Ongoing.layer.cornerRadius = 5
        self.view_Calender_Ongoing.layer.borderWidth = 1
        self.view_Calender_Ongoing.layer.borderColor = UIColor.gray.cgColor
        self.view_Calender_Ongoing.layer.masksToBounds = true
        
        self.btnSkip.layer.cornerRadius = 10
        self.btnSkip.layer.masksToBounds = true
        
        self.view_Recurring.layer.cornerRadius = 10
        self.view_Recurring.layer.masksToBounds = true
        
        self.tf_recurringStartDate.layer.cornerRadius = 10
        self.tf_recurringStartDate.layer.masksToBounds = true
        
        self.tf_recurringMsg.layer.cornerRadius = 10
        self.tf_recurringMsg.layer.masksToBounds = true
        
        self.tf_alertTime_recurring.layer.cornerRadius = 10
        self.tf_alertTime_recurring.layer.masksToBounds = true
        
        self.myTableView_Recurring.layer.cornerRadius = 10
        self.myTableView_Recurring.layer.borderColor = UIColor.white.cgColor
        self.myTableView_Recurring.layer.borderWidth = 1
        self.myTableView_Recurring.layer.masksToBounds = true
        
        self.tf_recurringEndDate.layer.cornerRadius = 10
        self.tf_recurringEndDate.layer.masksToBounds = true
        
        self.btn_viewReminders.layer.borderColor = UIColor.gray.cgColor
        self.btn_viewReminders.layer.borderWidth = 1
        self.btn_viewReminders.layer.cornerRadius = 5
        self.btn_viewReminders.layer.masksToBounds = true
        
        self.setup_calender()
        self.showDatePicker()
        
        if let vc = self.navigationController?.getPreviousViewController() {
            if vc is RemindersVC{
                self.btnSkip.isHidden = true
            }
        }
    }
    
    
    override func viewDidLayoutSubviews()
    {
        if (self.view_Recurring.isHidden == true)
        {
            self.myScrollView.contentSize = CGSize(self.view.bounds.width, self.view_AddTextAndOther.frame.origin.y+200)
        }
        else
        {
            self.myScrollView.contentSize = CGSize(self.view.bounds.width, self.view_AddTextAndOther.frame.origin.y+270)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.view_Recurring.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.setup_calender()
        self.showDatePicker()
    }
    
    
    //MARK: <<<-----BUTTON ACTIONS----->>>
    
    @IBAction func ACTION_MOVE_BACK(_ sender: Any)
    {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    @IBAction func ACTION_SKIP_CONTROLLER(_ sender: Any)
    {
        MeditationExplore.refrncPagerParent.skip()
    }
    
    
    
    //MARK: EXPAND VIEW ACCORDING TO TABLEVIEW CONTENT
    func expandView_according_tableView()
    {
        //        if (self.myTableView.contentSize.height < 240.0)
        //        {
        //            //dont expand view
        //            self.height_tableView.constant = 240.0
        //        }
        //        else
        //        {
        //            self.height_tableView.constant = self.myTableView.contentSize.height+20
        //            self.viewDidLayoutSubviews()
        //            self.view.layoutIfNeeded()
        //        }
        
        self.height_tableView.constant = 80.0
        
    }
    
    
    
    @IBAction func ACTION_VIEW_REMINDERS(_ sender: Any)
    {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(withIdentifier: "RemindersVC")as! RemindersVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func ACTION_SWITCH(_ sender: Any)
    {
        
    }
    
    @IBAction func ACTION_ADD(_ sender: Any)
    {
        if (self.datesRange.count == 0)
        {
            CommonVc.AllFunctions.showAlert(message: "In order to create a reminder, you must select the date, time and event", view: self,  title:Constants.Global.ConstantStrings.KAppname)
        }
        else
        {
            self.HANDLE_ADD_REMINDER_ACTION()
        }
        
    }
    
    func refresh_calender_data_for_new_approach()
    {
        self.datesRange.removeAll()
        lastDate = nil
        firstDate = nil
        self.tf_Desc.text = ""
        self.tfSelectTime.text = "Select Time"
        self.tf_recurringMsg.text = ""
        self.tf_alertTime_recurring.text = ""
        self.tf_recurringEndDate.text = ""
        self.tf_recurringStartDate.text = ""
        self.recurring_index = -1
        for d in self.view_Calender.selectedDates
        {
            self.view_Calender.deselect(d)
        }
        
        self.myTableView_Recurring.reloadData()
        self.view_Calender.reloadData()
    }
    
    
    //MARK: RECURRING SETTING
    @IBAction func ACTION_RECURRING_ONGOING(_ sender: Any)
    {
        self.view_Calender_Ongoing.isHidden = true
        
        if (btnOngoing.tag == 0)
        {
            self.selectedApproach = "Ongoing"
            btnOngoing.tag = 1
            self.ivOngoing.image = UIImage(named:"white_tick")
            self.view_Dates.isUserInteractionEnabled = false
            self.view_Dates.alpha = 0.5
           // self.show_recurring_tableview()
        }
        else if (btnOngoing.tag == 1)
        {
            self.selectedApproach = ""
            btnOngoing.tag = 0
            self.ivOngoing.image = UIImage(named:"white_untick")
            self.view_Dates.isUserInteractionEnabled = true
            self.view_Dates.alpha = 1.0
           // self.hide_recurring_tableview()
        }
    }
    
    @IBAction func ACTION_SELECT_START_DATE_RECURRING(_ sender: Any)
    {
        self.selectedApproach = "Ongoing"
        self.recurring_index = -1
        self.setup_ongoing_Calender()
        self.myTableView_Recurring.reloadData()
        lastDate = nil
        firstDate = nil
        
        if (self.view_Calender_Ongoing.isHidden == true)
        {
           self.view_Calender_Ongoing.isHidden = false
        }
        else
        {
           self.view_Calender_Ongoing.isHidden = true
        }
    }
    
    @IBAction func ACTION_SELECT_END_DATE_RECURRING(_ sender: Any)
    {
        if (self.tf_recurringStartDate.text == "")
        {
            CommonVc.AllFunctions.showAlert(message: "Please select start date first", view: self,  title:Constants.Global.ConstantStrings.KAppname)
        }
        else
        {
            self.selectedApproach = "Ongoing"
            self.recurring_index = -1
            self.view_Calender_Ongoing.reloadData()
            
            self.myTableView_Recurring.reloadData()
            if (self.view_Calender_Ongoing.isHidden == true)
            {
                self.view_Calender_Ongoing.isHidden = false
            }
            else
            {
                self.view_Calender_Ongoing.isHidden = true
            }
        }
        
    }
    
    
    //MARK: ADDING RECURRING REMINDER
    @IBAction func ACTION_ADD_RECURRING_REMINDER(_ sender: Any)
    {
        if (btnOngoing.tag == 0)// on going is not selected its a start date and Date
        {
            
            if (self.tf_recurringStartDate.text == "")
            {
                CommonVc.AllFunctions.showAlert(message: "Please select start date first", view: self,  title:Constants.Global.ConstantStrings.KAppname)
            }
            else if(self.tf_recurringEndDate.text == "")
            {
                CommonVc.AllFunctions.showAlert(message: "Please select end date", view: self,  title:Constants.Global.ConstantStrings.KAppname)
            }
            else if(self.tf_recurringMsg.text == "")
            {
                 CommonVc.AllFunctions.showAlert(message: "Please add some words to remind you on Alert.", view: self,  title:Constants.Global.ConstantStrings.KAppname)
            }
            else if(recurring_index == -1)
            {
                CommonVc.AllFunctions.showAlert(message: "In order to create a recurring reminder, you must have to select a repeat day.", view: self,  title:Constants.Global.ConstantStrings.KAppname)
            }
            else if (self.tf_alertTime_recurring.text?.count == 0)
            {
                CommonVc.AllFunctions.showAlert(message: "Please choose alert time for reminder.", view: self,  title:Constants.Global.ConstantStrings.KAppname)
            }
            else
            {
                self.CREATE_REMINDERS_RECURRING_with_START_END_DATE(recurringType: self.recurring_alert_type ?? "Repeat Every Day", dayCount: recurring_index, alertTime: alertTime_recurring!, prsnlMsg: self.tf_recurringMsg.text!, isOnGoing: false)
            }
            
        }
        else//ongoing selected
        {
            
            if (self.tf_recurringMsg.text == "")
            {
                CommonVc.AllFunctions.showAlert(message: "Please add some words to remind you on Alert.", view: self,  title:Constants.Global.ConstantStrings.KAppname)
            }
            else if (recurring_index == -1)
            {
                CommonVc.AllFunctions.showAlert(message: "In order to create a recurring reminder, you must have to select a repeat day.", view: self,  title:Constants.Global.ConstantStrings.KAppname)
            }
            else
            {
                //create a repeating reminder
                if (self.tf_alertTime_recurring.text?.count == 0)
                {
                    CommonVc.AllFunctions.showAlert(message: "Please choose alert time for Ongoing Reminders.", view: self,  title:Constants.Global.ConstantStrings.KAppname)
                }
                else
                {
                    self.CREATE_REMINDERS_RECURRING(recurringType: self.recurring_alert_type ?? "Repeat Every Day", dayCount: recurring_index, alertTime: alertTime_recurring ?? Date(), prsnlMsg: self.tf_recurringMsg.text!, isOnGoing: true)
                }
                
            }
        }
    }
    
}


extension SetRemindersVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arr_recurring.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID_Recurring) as! CellClass_Recurring
        
        cell.lblName.text = arr_recurring[indexPath.row]
        
        if (indexPath.row == self.recurring_index)
        {
            cell.ivSeleced.isHidden = false
        }
        else
        {
            cell.ivSeleced.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.recurring_index = indexPath.row
        self.recurring_alert_type = arr_recurring[indexPath.row]
        self.myTableView_Recurring.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0
    }
}

extension SetRemindersVC : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIDCollec, for: indexPath) as! CellClass_SetReminder_CollectionView
        
        cell.lblName.text = dataSource[indexPath.item]
        
        cell.view_BG.layer.cornerRadius = 20
        cell.view_BG.layer.masksToBounds = true
        
        if (indexPath.item == self.myCurrentIndex)
        {
            cell.ivSelected.image = UIImage(named:"addCareRecieverBlugBg")
            cell.lblName.textColor = UIColor.white
            cell.view_BG.layer.borderWidth = 0
        }
        else
        {
            cell.lblName.textColor = UIColor.black
            cell.ivSelected.image = UIImage(named:"")
            cell.view_BG.layer.borderColor = UIColor.black.cgColor
            cell.view_BG.layer.borderWidth = 1
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        
        if (indexPath.item == 0)
        {
            self.view_Calender.scope = .month
            self.handle_calenderView_Height(contnt: 270.0)
            self.selectedApproach = "Daily"
            self.hide_recurringView()
        }
        else if (indexPath.item == 1)
        {
            self.view_Calender.scope = .week
            self.handle_calenderView_Height(contnt: 120.0)
            self.selectedApproach = "Weekly"
            self.hide_recurringView()
        }
        else if (indexPath.item == 2)
        {
            self.view_Calender.scope = .month
            self.handle_calenderView_Height(contnt: 270.0)
            self.selectedApproach = "Monthly"
            self.hide_recurringView()
        }
        else if (indexPath.item == 3)
        {
            self.view_Calender.scope = .month
            self.handle_calenderView_Height(contnt: 200.0)
            self.selectedApproach = "Recurring"
            self.show_recurringView()
            self.btnOngoing.tag = 0
            self.ACTION_RECURRING_ONGOING(self.btnOngoing)
            //   self.showDatePicker_recurring_startDate(sourceView: self.tf_recurringStartDate)
            //   self.showDatePicker_recurring_endDate(sourceView: self.tf_recurringEndDate)
            self.showDatePicker_recurring_alertTime()
            
        }
        
        self.refresh_calender_data_for_new_approach()
        
        self.myCurrentIndex = indexPath.item
        self.MyCollectionView.reloadData()
        
        self.setup_calender()
        
        self.viewDidLayoutSubviews()
        self.view.endEditing(true)
        self.view.layoutIfNeeded()
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        // self.hide_recurringView()
    }
    
}

extension SetRemindersVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return  CGSize(width: 120, height: 50)
    }
}
