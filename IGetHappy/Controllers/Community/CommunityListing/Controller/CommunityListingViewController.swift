//
//  ViewController.swift
//  SamplePostApp
//
//  Created by Akash Dhiman on 7/15/19.
//  Copyright © 2019 Akash Dhiman. All rights reserved.
//

import UIKit
import FTPopOverMenu_Swift
import AVFoundation
import MMPlayerView
import Foundation
import FSCalendar
class CommunityListingViewController: BaseUIViewController,UISearchBarDelegate,FSCalendarDataSource, FSCalendarDelegate
{
    let viewBg = UIView()
    var startDate: Date?
    var endDate:Date?
    var selectedDate : Date?
    
    @IBOutlet weak var btnStartDate: UIButton!
    @IBOutlet weak var btnEndDate: UIButton!
    @IBOutlet weak var calenderView: FSCalendar!
    @IBOutlet var showPopUpSelectDate: UIView!
    @IBOutlet weak var mySearchBar: UISearchBar!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var filterView: RoundShadowView!
    @IBOutlet weak var postCollectionView: UICollectionView!
    @IBOutlet weak var lblEndYear: UILabel!
    @IBOutlet weak var lblEndMonth: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblStartYear: UILabel!
    @IBOutlet weak var lblStartMonth: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var btnFrndList: UIButton!
    
    var searchActive = false
    var offsetObservation: NSKeyValueObservation?
    var postListingArray = [Post?]()
    var fullArray = [Post?]()
    var postListingArray_filter = [Post?]()
    var refresher:UIRefreshControl!
    var limit = 20
    var totalEnteries = 0
    
    @IBOutlet weak var filterViewheight: NSLayoutConstraint!
    lazy var mmPlayerLayer: MMPlayerLayer = {
        let playerLayer = MMPlayerLayer()
        playerLayer.cacheType = .memory(count: 0)
   
        playerLayer.coverFitType = .fitToPlayerView
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        playerLayer.replace(cover: CoverLayerView.instantiateFromNib())
        return playerLayer
    }()
    
    override func viewDidLoad()
    {
       // showPopUpSelectDate.isHidden = true
        super.viewDidLoad()
        self.registerNib()
        self.initializeVideoPlayer()
        self.pullToRefresh()
        self.initializeAudioPlayer()
        self.filterView.isHidden = true
        self.filterViewheight.constant = 0
        self.calenderView.layer.cornerRadius = 10
        self.calenderView.layer.masksToBounds = true
        self.showPopUpSelectDate.layer.cornerRadius = 10
        self.showPopUpSelectDate.layer.masksToBounds = true
        PostWithAudioCell.ref_community = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        viewBg.addGestureRecognizer(tap)
        let audioSession = AVAudioSession.sharedInstance()
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
            try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch let error as NSError {
            print(error.localizedDescription)
            print("audioSession error: \(error.localizedDescription)")
            return
        }
    }
    
    
    @objc func appMovedToBackground() {
        print("App moved to background!")
      
        
        if mmPlayerLayer.playView != nil
        {
            mmPlayerLayer.player?.pause()
            mmPlayerLayer.invalidate()
            mmPlayerLayer.playView = nil
        }
        NotificationCenter.default.post(name: Notification.Name("StopMusic"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("StopMusicShare"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("stopMusicShareMoods"), object: nil)
        //NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil)
    {
        // handling code
        self.showPopUpSelectDate.removeFromSuperview()
        self.viewBg.removeFromSuperview()
        self.btnStartDate.tag = 0
     //   self.btnDate.tag = 0
        
        btnDate.tag = 0
        
        if (btnDate.tag == 0){
            startDate = nil
            endDate = nil
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
        self.btnDate.setImage(UIImage(named:"checkedEmpty"), for: UIControl.State.normal)
        self.calenderView.removeFromSuperview()
        
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        let audioSession = AVAudioSession.sharedInstance()
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
            try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch let error as NSError {
            print(error.localizedDescription)
            print("audioSession error: \(error.localizedDescription)")
            return
        }
        self.cancel_search()
        mySearchBar.placeholder = "Search by username"
        mySearchBar.setPlaceholderTextColorTo(color: .black)
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        getAllPost(startDateFilter: "", endDateFilter: "", searchWord: mySearchBar.text ?? "")
    }
    
    @IBAction func actnDoneSelectdates(_ sender: Any)
    {
        if (endDate == nil)
        {
           // self.viewBg.makeToast("Please select end date")
            CommonVc.AllFunctions.showAlert(message: "Make sure you have selected start/end date for filter process!", view: self, title: Constants.Global.ConstantStrings.KAppname)
        }
        else
        {
            self.showPopUpSelectDate.removeFromSuperview()
            self.viewBg.removeFromSuperview()
            self.btnStartDate.tag = 0
            
            if(startDate != nil && endDate != nil)
            {
                let startDateFilter = dateFormatTimeFilter(date: startDate!, format: "yyyy-MM-dd'T'00:00:00")
                let endDateFilter = dateFormatTimeFilter(date: endDate!, format: "yyyy-MM-dd'T'23:59:59")
                getAllPost(startDateFilter: startDateFilter, endDateFilter: endDateFilter, searchWord: mySearchBar.text ?? "")
                
            }
           
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
        self.lblEndDate.text = ""
        self.lblEndMonth.text = ""
        self.lblEndYear.text = ""
        calenderView.reloadData()
 
    }
    
    @IBAction func actnEndDate(_ sender: Any)
    {
        if (startDate == nil)
        {
            self.viewBg.makeToast("Please select start Date")
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
    // Calender Delegate
    func minimumDate(for calendar: FSCalendar) -> Date
    {
        
        if (btnStartDate.tag == 1){
            
            let isoDate = "1970-01-01"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale.current // set locale to reliable US_POSIX
            let date = dateFormatter.date(from:isoDate)!
            return date
            
        }else{
            
            return (startDate?.toGlobalTime())!
        }
        
        
        
    }
    
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//
//        if date == calenderView.today
//        {
//            return "Today"
//        }
//        else{
//            return nil
//        }
//    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        
       // if (btnStartDate.tag == 1){
            return Date()
       // }else{
         //   return Date()
       // }
        
    }

    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        Utility.dateFromISOStringForCreatedAt(string: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let convertedDate = formatter.string(from: date)
        formatter.timeZone = TimeZone.autoupdatingCurrent
        let finalDate = formatter.date(from: convertedDate)
        selectedDate = finalDate!.toLocalTime()
        //date.timeIntervalSinceNow =
        print(finalDate)
        
        if  btnStartDate.tag == 1{
            
            startDate =  selectedDate
            self.calenderView.removeFromSuperview()
            self.view.addSubview(showPopUpSelectDate)
            
            btnStartDate.tag = 0
            startDate = selectedDate
            var calendar = Calendar.current
            calendar.timeZone = TimeZone.current
            let day = calendar.component(.day, from: finalDate ?? date.toGlobalTime())
            let month = calendar.component(.month, from: finalDate ?? date.toGlobalTime())
            let year = calendar.component(.year, from: finalDate ?? date.toGlobalTime())
            
            self.lblStartDate.text = "\(day)"
            self.lblStartMonth.text = "\(month)"
            self.lblStartYear.text = "\(year)"
            
            
            //                    let day = selectedDate!.startOf(.day, date: selectedDate!)
            //                    self.lblStartDate.text = "\(day)"
            //                    self.lblStartMonth.text = "\(selectedDate!.startOf(.month, date: selectedDate!))"
            //                    self.lblStartYear.text = "\(selectedDate!.startOf(.year, date: selectedDate!))"
            
            
            
        }else{
            self.calenderView.removeFromSuperview()
            self.view.addSubview(showPopUpSelectDate)
            endDate = selectedDate
            let calendar = Calendar.current
            let day = calendar.component(.day, from: finalDate ?? date.toGlobalTime())
            let month = calendar.component(.month, from: finalDate ?? date.toGlobalTime())
            let year = calendar.component(.year, from: finalDate ?? date.toGlobalTime())
            
            self.lblEndDate.text = "\(day)"
            self.lblEndMonth.text = "\(month)"
            self.lblEndYear.text = "\(year)"
            
        }
        
        // if monthPosition == .previous {
        calendar.setCurrentPage(date, animated: true)
        //}
        calendar.reloadData()
        
    }
    
   
    func initializeAudioPlayer()
    {
        DispatchQueue.main.async {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                let session = AVAudioSession.sharedInstance()
                try session.setCategory(.playAndRecord, mode: .default)
                try session.setActive(true)
                try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            } catch let error as NSError {
                print(error.localizedDescription)
                print("audioSession error: \(error.localizedDescription)")
                return
            }
        }
    }
    
    @IBAction func ACTION_FRNDLIST(_ sender: Any)
    {
        
        CommonVc.AllFunctions.showAlert(message: "Coming soon", view: self,  title:Constants.Global.ConstantStrings.KAppname)
        
//        if (btnFrndList.tag == 0)
//        {
//            btnFrndList.tag = 1
//            self.btnFrndList.setImage(UIImage(named:"checkedTick"), for: UIControl.State.normal)
//        }
//        else if (btnFrndList.tag == 1)
//        {
//            btnFrndList.tag = 0
//            self.btnFrndList.setImage(UIImage(named:"checkedEmpty"), for: UIControl.State.normal)
//        }
    }
    
    
    @IBAction func ACTION_DATE(_ sender: Any)
    {
//        self.lblStartDate.text = ""
//        self.lblStartMonth.text = ""
//        self.lblStartYear.text = ""
//        self.lblEndDate.text = ""
//        self.lblEndMonth.text = ""
//        self.lblEndYear.text = ""
        
        if (btnDate.tag == 0)
        {
            
            self.lblStartDate.text = ""
            self.lblStartMonth.text = ""
            self.lblStartYear.text = ""
            self.lblEndDate.text = ""
            self.lblEndMonth.text = ""
            self.lblEndYear.text = ""

            
            btnDate.tag = 1
           
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
        }
        else if (btnDate.tag == 1)
        {
            btnDate.tag = 0
            self.btnDate.setImage(UIImage(named:"checkedEmpty"), for: UIControl.State.normal)
            self.startDate = nil
            self.endDate  = nil
            getAllPost(startDateFilter: "", endDateFilter: "", searchWord: mySearchBar.text ?? "")
        }
        
    }
    
    
    
    func pullToRefresh()
    {
        self.refresher = UIRefreshControl()
        self.postCollectionView!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor(red: 25/255, green: 165/255, blue: 253/255, alpha: 1)
        self.refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.postCollectionView!.addSubview(refresher)
    }
    
    @objc func loadData()
    {
        if(startDate != nil && endDate != nil)
        {
            let startDateFilter = dateFormatTimeFilter(date: startDate!, format: "yyyy-MM-dd'T'00:00:00")
            let endDateFilter = dateFormatTimeFilter(date: endDate!, format: "yyyy-MM-dd'T'23:59:59")
            getAllPost(startDateFilter: startDateFilter, endDateFilter: endDateFilter, searchWord: mySearchBar.text ?? "")
           
        }
        else
        {
            getAllPost(startDateFilter: "", endDateFilter: "", searchWord: mySearchBar.text ?? "")
        }
        
        
    }
    
    func stopRefresher()
    {
        self.refresher.endRefreshing()
    }
    
   
    
    func registerNib()
    {
        Utility.delegate = self
        
        let moodWithShareNibCell = UINib(nibName: ShareMoodPost.className, bundle: nil)
        postCollectionView.register(moodWithShareNibCell, forCellWithReuseIdentifier: ShareMoodPost.className)
        
        let moodWithVideoNibCell = UINib(nibName: MoodPostWithVideoCell.className, bundle: nil)
        postCollectionView.register(moodWithVideoNibCell, forCellWithReuseIdentifier: MoodPostWithVideoCell.className)
        
        let moodWithTextNibCell = UINib(nibName: MoodPostWithTextCell.className, bundle: nil)
        postCollectionView.register(moodWithTextNibCell, forCellWithReuseIdentifier: MoodPostWithTextCell.className)
        
        let moodWithAudioNibCell = UINib(nibName: MoodPostWithAudioCell.className, bundle: nil)
        postCollectionView.register(moodWithAudioNibCell, forCellWithReuseIdentifier: MoodPostWithAudioCell.className)
        
        let withOutImageNibCell = UINib(nibName: PostWithOutImageCell.className, bundle: nil)
        postCollectionView.register(withOutImageNibCell, forCellWithReuseIdentifier: PostWithOutImageCell.className)
        
        let withImageNibCell = UINib(nibName: PostWithImageCell.className, bundle: nil)
        postCollectionView.register(withImageNibCell, forCellWithReuseIdentifier: PostWithImageCell.className)
        
        let withAudioNibCell = UINib(nibName: PostWithAudioCell.className, bundle: nil)
        postCollectionView.register(withAudioNibCell, forCellWithReuseIdentifier: PostWithAudioCell.className)
        
        let withVideoNibCell = UINib(nibName: PostWithVideoCell.className, bundle: nil)
        postCollectionView.register(withVideoNibCell, forCellWithReuseIdentifier: PostWithVideoCell.className)
        
        let withSharedPostNibCell = UINib(nibName: MySharedPosts.className, bundle: nil)
        postCollectionView.register(withSharedPostNibCell, forCellWithReuseIdentifier: MySharedPosts.className)
    }
    
    @IBAction func filterButtonAction(_ sender: Any)
    {
        if filterViewheight.constant == 45
        {
            self.filterView.isHidden = true
            self.filterViewheight.constant = 0
            
            if (btnDate.tag == 0){
                self.btnDate.setImage(UIImage(named:"checkedEmpty"), for: UIControl.State.normal)
                self.btnFrndList.setImage(UIImage(named:"checkedEmpty"), for: UIControl.State.normal)
            }else{
                self.btnDate.setImage(UIImage(named:"checkedTick"), for: UIControl.State.normal)
                self.btnFrndList.setImage(UIImage(named:"checkedEmpty"), for: UIControl.State.normal)
                
            }
            
            
            //self.btnFrndList.tag = 0
//            self.btnDate.setImage(UIImage(named:"checkedEmpty"), for: UIControl.State.normal)
//            self.btnFrndList.setImage(UIImage(named:"checkedEmpty"), for: UIControl.State.normal)
        }
        else
        {
            self.filterView.isHidden = false
            self.filterViewheight.constant = 45
        }
        
        
        //self.view.makeToast(Constants.Global.MessagesStrings.ComingSoon)
        
        
        //self.filterView.isHidden = false
        // self.filterViewheight.constant = 45
        
        
    }
    
    @IBAction func searchButtonAction(_ sender: Any)
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
        }
        
    }
    
    @IBAction func ActionBack(_ sender: Any)
    {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    
    func getAllPost(startDateFilter:String,endDateFilter:String,searchWord:String)
    {
        let usrID = UserDefaults.standard.getUserId()
        var parameters = ["user_id":usrID]
        
       
        
        if(startDateFilter != "" && endDateFilter != "")
        {
            parameters["startDate"] = startDateFilter
            parameters["endDate"] = endDateFilter
        }
        if (searchWord != "")
        {
          //  parameters["search"] = searchWord
        }
      print("checkfinalparam",parameters)
        self.ShowLoaderCommon()
        CommunityViewModel.getAllPostService(params: parameters as [String : AnyObject], controller: self) { (success, responseArray, error) in
            
            if success
            {
               
                if(responseArray.count > 0)
                {
                    self.fullArray = responseArray
                    self.postListingArray = self.fullArray
//                    var index = 0
//                    while index < self.limit
//                    {
//                        self.postListingArray.append(responseArray[index])
//                        index = index + 1
//                    }
                    
 //                   self.totalEnteries = responseArray.count
//                    self.postCollectionView.reloadData()
                }else{
                    self.fullArray = responseArray
                    self.postListingArray = self.fullArray
                    self.postCollectionView.setEmptyMessage("No post found")
                    print(self.postListingArray.count)
                    //                    var index = 0
                    //                    while index < self.limit
                    //                    {
                    //                        self.postListingArray.append(responseArray[index])
                    //                        index = index + 1
                    //                    }
                    
                    //                   self.totalEnteries = responseArray.count
//                    self.postCollectionView.reloadData()

                }
            }
            self.stopRefresher()
            self.postCollectionView.reloadData()
            self.HideLoaderCommon()
        }
    }

    func initializeVideoPlayer()
    {
        offsetObservation = postCollectionView.observe(\.contentOffset, options: [.new]) { [weak self] (_, value) in
            guard let self = self, self.presentedViewController == nil else {return}
            self.updateByContentOffset()
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(self.startLoading), with: nil, afterDelay: 0.3)
        }
        postCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right:0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.updateByContentOffset()
            self?.startLoading()
        }
        
        mmPlayerLayer.getStatusBlock { [weak self] (status) in
            switch status {
           // case .failed(let err):
               // let alert = UIAlertController(title: Constants.Global.ConstantStrings.KAppname, message: err.description, preferredStyle: .alert)osho
              //  alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
              //  self?.present(alert, animated: true, completion: nil)
            case .ready:
                print("Ready to Play")
            case .playing:
                print("Playing")
            case .pause:
                print("Pause")
            case .end:
                print("End")
                if self?.mmPlayerLayer != nil
                {
                    self?.mmPlayerLayer.player?.seek(to: CMTime.zero)
                }
            default: break
            }
        }
    }
    
    func updateByContentOffset()
    {
        let point = CGPoint(x: postCollectionView.frame.width/2, y: postCollectionView.contentOffset.y + postCollectionView.frame.width/2)
        if let path = postCollectionView.indexPathForItem(at: point),
            self.presentedViewController == nil {
            
            let cell = postCollectionView.cellForItem(at: path)
            
            if (cell?.isKind(of: PostWithImageCell.self) ?? false){
                if let cell = postCollectionView.cellForItem(at: path) as? PostWithImageCell, let playURL = cell.item?.postfile
                {
                    if cell.item?.postType == "VIDEO"
                    {
                        self.startLoading()
                        //                    mmPlayerLayer.thumbImageView.image = UIImage(named: "")
                        mmPlayerLayer.playView = cell.postImageView
                        
                        //                    mmPlayerLayer.set(url: URL(string: "https://s3.amazonaws.com/archive.wesellrestaurants/community-posts-1565176749657.mp4"))
                        mmPlayerLayer.set(url: URL(string: playURL))
                    }
                    else
                    {
                        destroyMMPlayerInstance()
                    }
                }
            }else if (cell?.isKind(of: MoodPostWithVideoCell.self) ?? false){
                if let cell = postCollectionView.cellForItem(at: path) as? MoodPostWithVideoCell, let playURL = cell.item?.postfile
                {
                    if cell.item?.postType == "VIDEO"
                    {
                        self.startLoading()
                        //                    mmPlayerLayer.thumbImageView.image = UIImage(named: "")
                        mmPlayerLayer.playView = cell.postImageView
                        
                        //                    mmPlayerLayer.set(url: URL(string: "https://s3.amazonaws.com/archive.wesellrestaurants/community-posts-1565176749657.mp4"))
                        mmPlayerLayer.set(url: URL(string: playURL))
                    }
                    else
                    {
                        destroyMMPlayerInstance()
                    }
                }
            }else{
                 destroyMMPlayerInstance()
            }
            
//            if let cell = postCollectionView.cellForItem(at: path) as? PostWithImageCell, let playURL = cell.item?.postfile
//            {
//                if cell.item?.postType == "VIDEO"
//                {
//                    self.startLoading()
//                    //                    mmPlayerLayer.thumbImageView.image = UIImage(named: "")
//                    mmPlayerLayer.playView = cell.postImageView
//
//                    //                    mmPlayerLayer.set(url: URL(string: "https://s3.amazonaws.com/archive.wesellrestaurants/community-posts-1565176749657.mp4"))
//                    mmPlayerLayer.set(url: URL(string: playURL))
//                }
//                else
//                {
//                    destroyMMPlayerInstance()
//                }
//            }
//            if let cell = postCollectionView.cellForItem(at: path) as? MoodPostWithVideoCell, let playURL = cell.item?.postfile
//            {
//                if cell.item?.postType == "VIDEO"
//                {
//                    self.startLoading()
//                    //                    mmPlayerLayer.thumbImageView.image = UIImage(named: "")
//                    mmPlayerLayer.playView = cell.postImageView
//
//                    //                    mmPlayerLayer.set(url: URL(string: "https://s3.amazonaws.com/archive.wesellrestaurants/community-posts-1565176749657.mp4"))
//                    mmPlayerLayer.set(url: URL(string: playURL))
//                }
//                else
//                {
//                    destroyMMPlayerInstance()
//                }
//            }
//            else
//            {
//                destroyMMPlayerInstance()
//            }
        }
    }
    
    func updateCell(at indexPath: IndexPath) {
        if let cell = postCollectionView.cellForItem(at: indexPath) as? PostWithImageCell, let playURL = cell.item?.postfile {
            mmPlayerLayer.playView = cell.postImageView
            mmPlayerLayer.set(url: URL(string: playURL))
        }
    }
    
    func destroyMMPlayerInstance()
    {
        if mmPlayerLayer.playView != nil
        {
            mmPlayerLayer.player?.pause()
            
            mmPlayerLayer.playView = nil
        }
        NotificationCenter.default.post(name: Notification.Name("StopMusic"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("stopMusicShare"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("stopMusicShareMoods"), object: nil)
        
    }
    
    @objc func startLoading() {
        if self.presentedViewController != nil {
            return
        }
        mmPlayerLayer.autoPlay = false
        mmPlayerLayer.resume()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        btnDate.tag = 0
        self.btnDate.setImage(UIImage(named:"checkedEmpty"), for: UIControl.State.normal)
        self.filterViewheight.constant = 0
        NotificationCenter.default.removeObserver(self)
        destroyMMPlayerInstance()
    }
    
    deinit
    {
        offsetObservation?.invalidate()
        offsetObservation = nil
       // PostWithAudioCell.ref_community = nil
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
        self.postListingArray_filter.removeAll()
        self.postCollectionView.reloadData()
        
        searchBar.text = nil
        searchBar.resignFirstResponder()
        self.mySearchBar.showsCancelButton = false
        self.cancel_search()
        self.btnSearch.tag = 0
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchActive = true
        self.postListingArray_filter.removeAll()
        
        if (self.postListingArray.count > 0)
        {
            for obj in self.postListingArray
            {
                let str = obj?.userName ?? ""
                let search = self.mySearchBar.text ?? ""
                
                if (str.localizedCaseInsensitiveContains(search))
                {
                    self.postListingArray_filter.append(obj)
                }
                
//                if let _ = str.range(of: search, options: .caseInsensitive)
//                {
//                    self.postListingArray_filter.append(obj)
//                }
            }
            
            self.postCollectionView.reloadData()
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
    }
    
    
}
