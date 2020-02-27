//
//  MyVentsTabVC.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import FSCalendar
class MyVentsTabVC: BaseUIViewController,UISearchBarDelegate
{
    
    //MARK: <-OUTLETS ->
    @IBOutlet var showPopUpMenu: UIView!
    @IBOutlet weak var btnStartDate: UIButton!
    @IBOutlet weak var btnEndDate: UIButton!
    @IBOutlet weak var calenderView: FSCalendar!
    @IBOutlet var showPopUpSelectDate: UIView!
    @IBOutlet weak var lblEndYear: UILabel!
    @IBOutlet weak var lblEndMonth: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblStartYear: UILabel!
    @IBOutlet weak var lblStartMonth: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var mySegmentControl: UISegmentedControl!
    @IBOutlet weak var myContanerView: UIView!
    @IBOutlet weak var view_filter: UIView!
    @IBOutlet weak var mySearchBar: UISearchBar!
    @IBOutlet weak var heightConstaraint_FilterView: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnFrndList: UIButton!
    @IBOutlet weak var btnDate: UIButton!
    static var refNew = MyAllVentsTabVC()
    static var refNewPrivate = MyPrivateVentTabVC()
    //MARK: <- VARIABLES->
    let viewBg = UIView()
    var startDate: Date?
    var endDate:Date?
    var selectedDate : Date?
    var myAllVentsTab = MyAllVentsTabVC()
    var myPrivateVentTab = MyPrivateVentTabVC()
    var searchActive = false
    var currentController = UIViewController()
    let storybrd = UIStoryboard.init(name: "Main", bundle: nil)
    
    
    var strtDATE = ""
    var endDATE = ""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.All_Vents_Selected()
        self.mySegmentControl.layer.cornerRadius = 10
        self.mySegmentControl.layer.masksToBounds = true
        self.mySegmentControl.layer.borderColor = UIColor.gray.cgColor
        self.mySegmentControl.layer.borderWidth = 1
        
        mySearchBar.placeholder = "Search by description"
        mySearchBar.setPlaceholderTextColorTo(color: .black)
        self.calenderView.layer.cornerRadius = 10
        self.calenderView.layer.masksToBounds = true
        
        
        hideFilterView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        viewBg.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil)
    {
        // handling code
        self.showPopUpSelectDate.removeFromSuperview()
        self.viewBg.removeFromSuperview()
        
        if (btnDate.tag == 0){
            self.btnDate.setImage(UIImage(named:"checkedEmpty"), for: UIControl.State.normal)
            self.btnFrndList.setImage(UIImage(named:"checkedEmpty"), for: UIControl.State.normal)
        }else{
            
            if (lblStartDate.text?.isEmpty ?? false){
                self.btnDate.setImage(UIImage(named:"checkedEmpty"), for: UIControl.State.normal)
                self.btnFrndList.setImage(UIImage(named:"checkedEmpty"), for: UIControl.State.normal)
            }else{
                self.btnDate.setImage(UIImage(named:"checkedTick"), for: UIControl.State.normal)
                self.btnFrndList.setImage(UIImage(named:"checkedEmpty"), for: UIControl.State.normal)
            }
 
        }
        
        self.btnStartDate.tag = 0
       // self.btnDate.tag = 0
        //self.btnDate.setImage(UIImage(named:"checkedEmpty"), for: UIControl.State.normal)
        self.calenderView.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.cancel_search()
    }
    
    @IBAction func actnDoneSelectdates(_ sender: Any)
    {
        if (startDate == nil)
        {
            CommonVc.AllFunctions.showAlert(message: "Please select start Date", view: self, title: Constants.Global.ConstantStrings.KAppname)
        }
        else if (endDate == nil)
        {
            CommonVc.AllFunctions.showAlert(message: "Please select end Date", view: self,  title:Constants.Global.ConstantStrings.KAppname)
        }
        else
        {
            self.showPopUpSelectDate.removeFromSuperview()
            self.viewBg.removeFromSuperview()
            self.btnStartDate.tag = 0
            
            self.strtDATE = self.dateFormatTimeFilter(date: startDate ?? Date(), format: "yyyy-MM-dd'T'00:00:00")
            self.endDATE = self.dateFormatTimeFilter(date: endDate ?? Date(), format: "yyyy-MM-dd'T'23:59:59")
            
            if (btnFrndList.tag == 1)
            {
                MyVentsTabVC.refNew.call_api_filter_approach(frndlist: true, date: true, strtDate: strtDATE, endDate: endDATE)
            }
            else
            {
                MyVentsTabVC.refNew.call_api_filter_approach(frndlist: false, date: true, strtDate: strtDATE, endDate: endDATE)
            }
            
            
            
            //call api for filter
        }
 
    }
    @IBAction func actnStartDate(_ sender: Any)
    {
        
        calenderView.center = CGPoint(x: view.frame.size.width  / 2,
                                      y: view.frame.size.height / 2)
        // self.showPopUpSelectDate.isHidden = true
        self.showPopUpSelectDate.removeFromSuperview()
        self.view.addSubview(calenderView)
        self.view.bringSubviewToFront(calenderView)
        self.btnStartDate.tag = 1
        calenderView.dataSource = self
        calenderView.delegate = self
        self.endDate = nil
        self.lblStartDate.text = ""
        self.lblStartMonth.text = ""
        self.lblStartYear.text = ""
        calenderView.reloadData()
    }
    
    @IBAction func actnEndDate(_ sender: Any)
    {
        if (startDate == nil)
        {
           // self.viewBg.makeToast("Please select start Date")
            CommonVc.AllFunctions.showAlert(message: "Please select start Date", view: self,  title:Constants.Global.ConstantStrings.KAppname)
        }
        else
        {
            self.showPopUpSelectDate.removeFromSuperview()
            calenderView.center = CGPoint(x: view.frame.size.width  / 2,
                                          y: view.frame.size.height / 2)
            self.view.addSubview(calenderView)
            self.view.bringSubviewToFront(calenderView)
            self.calenderView.reloadData()
        }
    }
    
    @IBAction func ACTION_MOVE_BACK(_ sender: Any)
    {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    
    @IBAction func ACTION_FILTER(_ sender: Any)
    {
        if btnFilter.tag == 0
        {
            btnFilter.tag = 1
            
            if (btnDate.tag == 0){
                self.btnDate.setImage(UIImage(named:"checkedEmpty"), for: UIControl.State.normal)
                self.btnFrndList.setImage(UIImage(named:"checkedEmpty"), for: UIControl.State.normal)
            }else{
                self.btnDate.setImage(UIImage(named:"checkedEmpty"), for: UIControl.State.normal)
                self.btnFrndList.setImage(UIImage(named:"checkedEmpty"), for: UIControl.State.normal)
            }
            
            showFilterView()
        }
        else if btnFilter.tag == 1
        {
            btnFilter.tag = 0
            hideFilterView()

          //  self.btnDate.tag = 0
            self.btnFrndList.tag = 0
            //self.btnDate.setImage(UIImage(named:"checkedEmpty"), for: UIControl.State.normal)
           // self.btnFrndList.setImage(UIImage(named:"checkedEmpty"), for: UIControl.State.normal)
            MyVentsTabVC.refNew.call_api_filter_approach(frndlist: false, date: false, strtDate: "", endDate: "")
        }
    }
    
    @IBAction func ACTION_SEARCH(_ sender: Any)
    {
        if (self.btnSearch.tag == 0)
        {
            self.btnSearch.tag = 1
            search_button_tapped()
            self.mySearchBar.becomeFirstResponder()
        }
        else if (self.btnSearch.tag == 1)
        {
            self.btnSearch.tag = 0
            cancel_search()
            self.mySearchBar.resignFirstResponder()
            
            if (self.mySegmentControl.selectedSegmentIndex == 0)
            {
                MyVentsTabVC.refNew.search_dismiss()
            }
            else
            {
               // MyVentsTabVC.refNewPrivate.search_dismiss()
                MyVentsTabVC.refNew.search_dismiss()
            }
        }
    }
    
    @IBAction func ACTION_TABS_HANDLING(_ sender: Any)
    {
        cancel_search()
        if (self.mySegmentControl.selectedSegmentIndex == 0)
        {
            self.All_Vents_Selected()
        }
        else
        {
            self.Private_Vent_Selected()
            MyVentsTabVC.refNew.configureData_private()
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
//        self.currentController = (self.storyboard?.instantiateViewController(withIdentifier: "MyPrivateVentTabVC") as? MyPrivateVentTabVC)!
//        self.activeViewController = self.currentController
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchActive = false;
        searchBar.text = nil
        searchBar.resignFirstResponder()
        self.mySearchBar.showsCancelButton = false
        self.cancel_search()
        self.btnSearch.tag = 0
        if (self.mySegmentControl.selectedSegmentIndex == 0)
        {
            MyVentsTabVC.refNew.search_dismiss()
        }
        else
        {
            MyVentsTabVC.refNew.search_dismiss()
           // MyVentsTabVC.refNewPrivate.search_dismiss()
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchActive = true
        if (self.mySegmentControl.selectedSegmentIndex == 0)
        {
            
            MyVentsTabVC.refNew.callToApi(searchKeyWord: searchBar.text ?? "")
            //MyVentsTabVC.refNew.filterArray(searchText: searchBar.text ?? "")
        }
        else
        {
            MyVentsTabVC.refNew.callToApi(searchKeyWord: searchBar.text ?? "")
           // MyVentsTabVC.refNewPrivate.filterArray(searchText: searchBar.text ?? "")
        }
        
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
        return true
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.searchActive = true;
        self.mySearchBar.showsCancelButton = true
    }
    
    
    
    func search_button_tapped()
    {
        self.searchActive = true
        
        self.mySearchBar.isHidden = false
        self.btnBack.isHidden = true
        self.btnFilter.isHidden = true
        self.lblTitle.isHidden = true
        
    }
    
    func cancel_search()
    {
        self.searchActive = false
        
        self.mySearchBar.isHidden = true
        self.btnBack.isHidden = false
        self.btnFilter.isHidden = false
        self.lblTitle.isHidden = false
        MyVentsTabVC.refNew.callToApi(searchKeyWord: "")
    }
    
    @IBAction func ACTION_FILTER_BY_FRNDLIST(_ sender: Any)
    {
        
        CommonVc.AllFunctions.showAlert(message: "Coming soon", view: self,  title:Constants.Global.ConstantStrings.KAppname)
//        if (btnFrndList.tag == 0)
//        {
//             btnFrndList.tag = 1
//             self.btnFrndList.setImage(UIImage(named:"checkedTick"), for: UIControl.State.normal)
//
//            if (btnDate.tag == 1)
//            {
//                 MyVentsTabVC.refNew.call_api_filter_approach(frndlist: true, date: true, strtDate: "", endDate: "")
//            }
//            else
//            {
//                 MyVentsTabVC.refNew.call_api_filter_approach(frndlist: true, date: false, strtDate: "", endDate: "")
//            }
//        }
//        else if (btnFrndList.tag == 1)
//        {
//             btnFrndList.tag = 0
//             self.btnFrndList.setImage(UIImage(named:"checkedEmpty"), for: UIControl.State.normal)
//        }
    }
    
    @IBAction func ACTION_FILTER_BY_DATE(_ sender: Any)
    {
        
        if (btnDate.tag == 0)
        {
            btnDate.tag = 1
            self.lblStartDate.text = ""
            self.lblStartMonth.text = ""
            self.lblStartYear.text = ""
            self.lblEndDate.text = ""
            self.lblEndMonth.text = ""
            self.lblEndYear.text = ""

            self.btnDate.setImage(UIImage(named:"checkedTick"), for: UIControl.State.normal)
            viewBg.frame = self.view.frame
            viewBg.backgroundColor = .black
            viewBg.alpha = 0.5
            self.view.addSubview(viewBg)
            // showPopUpSelectDate.isHidden = false
            
            showPopUpSelectDate.center = CGPoint(x: view.frame.size.width  / 2,
                                                 y: view.frame.size.height / 2)
            self.view.addSubview(showPopUpSelectDate)
            self.view.bringSubviewToFront(showPopUpSelectDate)
            self.make_popupMenu_round()
        }
        else if (btnDate.tag == 1)
        {
            btnDate.tag = 0
            self.btnDate.setImage(UIImage(named:"checkedEmpty"), for: UIControl.State.normal)
            MyVentsTabVC.refNew.call_api_filter_approach(frndlist: false, date: false, strtDate: "", endDate: "")
            
        }
        
        
        
        //self.btnDate.setImage(UIImage(named:"checkedTick"), for: UIControl.State.normal)
       // self.btnFrndList.setImage(UIImage(named:"checkedEmpty"), for: UIControl.State.normal)

    }
    
    
    func showFilterView()
    {
        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            
            self.heightConstaraint_FilterView.constant = 45
            self.view_filter.isHidden = false
            
        }) { _ in
            
        }
    }
    func hideFilterView()
    {
        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            
            self.heightConstaraint_FilterView.constant = 0
            self.view_filter.isHidden = true
            
        }) { _ in
            
        }
    }
    
    func make_popupMenu_round()
    {
        self.showPopUpSelectDate.layer.cornerRadius = 10
        self.showPopUpSelectDate.layer.masksToBounds = true
    }
}
extension MyVentsTabVC: FSCalendarDataSource, FSCalendarDelegate{
    // Calender Delegate
    func minimumDate(for calendar: FSCalendar) -> Date {
        
        if (btnStartDate.tag == 1){
            
            let isoDate = "1970-01-01"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale.current // set locale to reliable US_POSIX
            let date = dateFormatter.date(from:isoDate)!
            return date
            
        }else{
            
            return startDate!
        }
        
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        
        // if (btnStartDate.tag == 1){
        return Date()
        // }else{
        //   return Date()
        // }
        
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date.toLocalTime()
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let convertedDate = formatter.string(from: date)
        formatter.timeZone = TimeZone.autoupdatingCurrent
        let finalDate = formatter.date(from: convertedDate)
        selectedDate = finalDate!.toLocalTime()
        //date.timeIntervalSinceNow =
        print(finalDate)
        
        
        
        
        
        //date.timeIntervalSinceNow =
        print(selectedDate)
        
        if  btnStartDate.tag == 1
        {
            
            startDate =  selectedDate
            self.calenderView.removeFromSuperview()
            self.view.addSubview(showPopUpSelectDate)
            
            btnStartDate.tag = 0
            startDate = selectedDate
            let calendar = Calendar.current
            
            let day = calendar.component(.day, from: startDate!)
            let month = calendar.component(.month, from: startDate!)
            let year = calendar.component(.year, from: startDate!)
            
            self.lblStartDate.text = "\(day)"
            self.lblStartMonth.text = "\(month)"
            self.lblStartYear.text = "\(year)"
            
            
            //                    let day = selectedDate!.startOf(.day, date: selectedDate!)
            //                    self.lblStartDate.text = "\(day)"
            //                    self.lblStartMonth.text = "\(selectedDate!.startOf(.month, date: selectedDate!))"
            //                    self.lblStartYear.text = "\(selectedDate!.startOf(.year, date: selectedDate!))"
            
            
            
        }
        else
        {
            self.calenderView.removeFromSuperview()
            self.view.addSubview(showPopUpSelectDate)
            endDate = selectedDate
            let calendar = Calendar.current
            let day = calendar.component(.day, from: endDate!)
            let month = calendar.component(.month, from: endDate!)
            let year = calendar.component(.year, from: endDate!)
            
            self.lblEndDate.text = "\(day)"
            self.lblEndMonth.text = "\(month)"
            self.lblEndYear.text = "\(year)"
            
        }
        
        // if monthPosition == .previous {
        calendar.setCurrentPage(date, animated: true)
        //}
        
    }
}
