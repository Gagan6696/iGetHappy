//
//  HomeVC.swift
//  IGetHappy
//
//  Created by Gagan on 5/22/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout
import DropDown
import MediaPlayer
import AVFoundation
import CoreLocation

enum BJAutoScrollingCollectionViewScrollDirection: String
{
    case left = "left"
    case right = "right"
}
protocol HomeViewDelegate:class
{
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
}

final class HomeVC: BaseUIViewController
{
    
    
    @IBOutlet weak var imgSelectedMoodBar: UIImageView!
    
    @IBOutlet weak var lblCurrentSlideDesc: UILabel!
    @IBOutlet weak var lblCurrentSlideName: UILabel!
    var fileNAME = ""
    var audioPlayer : AVAudioPlayer?
    //   var selectedItemIndex = ViewConstants.startingCarouselItem
    let dropDown = DropDown()
    private var timer = Timer()
    var scrollInterval: Int = 4
    deinit { stopScrolling() }
    var begin = false
    var arrItems = NSMutableArray()
    var pastDate = String()
    
    
    @IBOutlet weak var datePickerView: UIView!
    
    @IBOutlet weak var datePickerNew: UIDatePicker!
    
    @IBOutlet weak var constraintPickerView: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var tableViewEmojis: UITableView!
    @IBOutlet weak var imageEmotion: UIImageView!
    @IBOutlet weak var lblWelcomeName: UILabel!
    @IBOutlet weak var lblEmotion: UILabel!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var view_for_gesture: UIView!
    @IBOutlet weak var tf_Date: UITextField!
    @IBOutlet weak var btn_chooseDate: UIButton!
    @IBOutlet weak var view_BG: UIView!
    @IBOutlet weak var selectMoreEmoji: UIButton!
    var location = CLLocationManager()
    var emojiArray = [CharacterC]()
    //   var selectedOBJ : ButtonCarouselModel!
    
    @IBOutlet weak var lblSetDayEmoji: UILabel!
    let datePicker = UIDatePicker()
    var diffrColorTxt = ""
    var audioPlaying = false
    var presenter:HomePresenter?
    //Static because shneario changed and i have to make it true in presenter after ai response
    var push_to_edit_mood = false
    
    //MARK: SWIPE MOOD CONFIGURATION
    //  fileprivate var items = [CharacterC]()
    fileprivate var currentPage: Int = 0
    {
        didSet
        {
            if (self.currentPage < self.emojiArray.count)
            {
                self.lblEmotion.isHidden = false
                self.imgSelectedMoodBar.isHidden = false
                let character = self.emojiArray[self.currentPage]
                diffrColorTxt = "\(character.title.capitalizingFirstLetter())"
                self.lblEmotion.text = "I'm Feeling \(diffrColorTxt)"
                self.lblEmotion = CommonFunctions.make_text_different_in_label(label: self.lblEmotion, textForColor: diffrColorTxt)
            }else if self.currentPage == 10{
                let character = self.emojiArray[3]
                diffrColorTxt = "\(character.title.capitalizingFirstLetter())"
                self.lblEmotion.isHidden = true
                 self.imgSelectedMoodBar.isHidden = true
                if Constants.pleaseTrackMood{
                    Constants.pleaseTrackMood = false
                    self.AlertMessageWithOkCancelAction(titleStr: Constants.Global.ConstantStrings.KAppname, messageStr: "Please Track your mood", Target: self) { (message) in
                        if message == "Yes"{
                            self.btnCaptureImage(self)
                        }
                    }
                }
                
               // self.lblEmotion.text = "I'm Feeling \(diffrColorTxt)"
                //self.lblEmotion = CommonFunctions.make_text_different_in_label(label: self.lblEmotion, textForColor: diffrColorTxt)
            }
            // self.detailLabel.text = character.description.uppercased()
        }
    }
    fileprivate var pageSize: CGSize
    {
        let layout = self.myCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal
        {
            pageSize.width += layout.minimumLineSpacing
        }
        else
        {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureDropDown()
        self.constraintPickerView.constant = 0
        self.selectMoreEmoji.layer.cornerRadius = 15
        self.selectMoreEmoji.layer.borderColor = UIColor.black.cgColor
        self.selectMoreEmoji.layer.borderWidth = 1
        if let firstName  = UserDefaults.standard.getFirstName(), let lastName = UserDefaults.standard.getLastName()
        {
            let name = firstName
            let myString = "Welcome back," + name
            let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.black]
            let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
            // set attributed text on a UILabel
            self.lblWelcomeName.attributedText = myAttrString
        }
        
        self.presenter = HomePresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        /**
         This function used for get mood from server when user comes to dashboard.
         */
        //        getmoodFromServer()
        //        let rewel = self.revealViewController()
        //        rewel?.frontViewController.view.isUserInteractionEnabled = true
        //        rewel?.stableDragOnOverdraw = true
        //
        //        rewel?.panGestureRecognizer()
        
        
        if self.revealViewController() != nil
        {
            //            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            //            self.view_for_gesture.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        else
        {
            print("There is no reveal view controller")
        }
        
        //showDatePicker()
        
        let layout = UPCarouselFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .horizontal
        myCollectionView.collectionViewLayout = layout
        self.setupLayout()
        self.emojiArray = self.createItems()
        self.currentPage = ExtensionModel.shared.Emoji_CurrentPage
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        push_to_edit_mood = false
        audioPlaying = false
        audioPlayer?.pause()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh_offline_array), name: NSNotification.Name(rawValue: "refreshArray"), object: nil)
        
        
        HappyMemoriesSlide()
        
        if let indexPath = self.collectionView.indexPathsForVisibleItems.first
        {
            let dic = self.arrItems.object(at: indexPath.row)as? NSDictionary
            let type = dic?.value(forKey: coreDataKeys_HappyMemories.type)as? String ?? ""
            
            if(type == "AUDIO")
            {
                let cell = self.collectionView.cellForItem(at: indexPath) as!  HappyMemoriesAudioCell
                if(audioPlayer?.rate == 0)
                {
                    //cell.play()
                    audioPlayer?.play()
                    cell.btnPlaySound.setBackgroundImage(UIImage(named: "pause"), for: UIControl.State.normal)
                    // cell.btnPlaySound.setTitle("pause", for: .normal)
                }
            }
            else if(type == "VIDEO")
            {
                let cell = self.collectionView.cellForItem(at: indexPath) as! HappyMemoriesVideoCell
                if(cell.player?.rate == 0)
                {
                    cell.playVideo()
                    cell.btnPlay.setBackgroundImage(UIImage(named: "pause"), for: .normal)
                    // cell.btnPlay.setImage(UIImage(named: "pause"), for: .normal)
                    //cell.btnPlay.setTitle("pause", for: .normal)
                }
            }
            else
            {
                startScrolling()
            }
        }
        
        self.GET_SAVED_EMOJIS()
        self.myCollectionView.reloadData()
        
        getCurrentLatLon(vc: self, obj: location)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if (checkInternetConnection() == true)
        {
            presenter?.get_emoji_offline()//on it
        }
        self.currentPage = ExtensionModel.shared.Emoji_CurrentPage
        self.myCollectionView.scrollToItem(at:IndexPath(item: self.currentPage, section: 0), at: .centeredHorizontally, animated: true)
        // let indx = self.currentPage
        // self.currentPage = indx
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        audioPlaying = false
        audioPlayer?.pause()
        
        //self.collectionView.scrollToItem(at: 1, at: .centeredHorizontally, animated: true)
        self.stopScrolling()
        if let indexPath = self.collectionView.indexPathsForVisibleItems.first
        {
            let dic = self.arrItems.object(at: indexPath.row) as? NSDictionary
            let type = dic?.value(forKey: coreDataKeys_HappyMemories.type) as? String ?? ""
            
            if(type == "AUDIO")
            {
                let cell = self.collectionView.cellForItem(at: indexPath) as!  HappyMemoriesAudioCell
                if(audioPlayer?.rate != 0)
                {
                    //cell.pause()
                    print("player pause")
                    
                    audioPlayer?.stop()
                    
                    //audioPlayer?.pause()
                    cell.btnPlaySound.setBackgroundImage(UIImage(named: "play"), for: UIControl.State.normal)
                    // cell.btnPlaySound.setTitle("play", for: .normal)
                }
                
            }
            else if(type == "VIDEO")
            {
                let cell = self.collectionView.cellForItem(at: indexPath) as! HappyMemoriesVideoCell
                if(cell.player?.rate != 0)
                {
                    cell.pauseVideo()
                    cell.btnPlay.setBackgroundImage(UIImage(named: "play"), for: .normal)
                    // cell.btnPlay.setImage(UIImage(named: "play"), for: .normal)
                    //cell.btnPlay.setTitle("play", for: .normal)
                }
            }
            
        }
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "refreshArray"), object: nil)
    }
    
    //    @objc func playerDidFinishPlaying(note: NSNotification)
    //    {
    //        print("Audio Finished")
    //        //NotificationCenter.default.removeObserver(self)
    //        //audioPlayer?.seek(to: CMTime.zero)
    //        audioPlayer?.stop()
    //        //btnPlaySound.setTitle("play", for: .normal)
    //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startScroll"), object: nil)
    //    }
    //    func playerDidFinishPlaying(note: NSNotification) {
    //        print("Audio Finished")
    //        NotificationCenter.default.removeObserver(self)
    //        //audioPlayer?.seek(to: CMTime.zero)
    //        audioPlayer?.stop()
    //        //btnPlaySound.setTitle("play", for: .normal)
    //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startScroll"), object: nil)
    //    }
    
    @IBAction func actionDatePickerCancel(_ sender: Any) {
        lblSetDayEmoji.text = "Today"
        self.constraintPickerView.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func actionDatePickerDone(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        // formatter.dateFormat = "yy-MM-dd"
        //lblSetDayEmoji.text = formatter.string(from: datePicker.date)
        lblSetDayEmoji.text = "Past"
        
        pastDate = formatter.string(from: datePickerNew.date)
        self.constraintPickerView.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: GET MOOD FROM SERVER AND SET
    func getmoodFromServer(){
        self.presenter?.getMoodFromServer()
    }
    
    private func configureDropDown(){
        DispatchQueue.main.async {
            self.dropDown.anchorView = self.lblSetDayEmoji
            // The list of items to display. Can be changed dynamically
            self.dropDown.dataSource = ["Today","Past"]
            self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                if(index == 1){
                    //     self.btn_chooseDate.inputView = datePicker
                    self.showDatePicker()
                }
                self.lblSetDayEmoji.text = "\(item)"
            }
            DropDown.startListeningToKeyboard()
        }
    }
    
    //MARK: GET SAVED EMOJIS
    func GET_SAVED_EMOJIS()
    {
        
        self.emojiArray = self.createItems()
        let arr : NSArray = ExtensionModel.shared.stored_emoji_array
        if(arr.count > 0)
        {
            for obj in arr
            {
                let dic = obj as? NSDictionary
                let imageName : String = dic?.value(forKey: "image") as? String ?? ""
                let imageText : String = dic?.value(forKey: "name") as? String ?? ""
                
                let obj = CharacterC(imageName: imageName, title: imageText, description: imageName)
                
                //  let obj = ButtonCarouselModel(selectedImage: UIImage(named: imageName)!,
                //  unselectedImage: UIImage(named: imageName)!,
                //  text: imageText)
                
                emojiArray.append(obj)
            }
        }
        
        
    }
    
    
    /** Happy memories Slide Work Start*/
    private  func HappyMemoriesSlide()
    {
        
        //NotificationCenter.default.addObserver(self, selector: Selector(("playerDidFinishPlaying:")), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.startScroll(notif:)), name: NSNotification.Name(rawValue: "startScroll"), object: nil)
        
        //        arrItems = [["name" : "demo1",
        //                     "url":"https://seasiabucket.s3.amazonaws.com/community-posts-1568962024220.png",
        //                     "type":"Image"],
        //                    ["name" : "demo1",
        //                     "url":"http://np.seasiafinishingschool.com:9054/uploads/community_posts/post_upload_file-1567585894274.mp4",
        //                     "type":"Video"],
        //                    ["name" : "demo1",
        //                     "url":"http://np.seasiafinishingschool.com:9054/uploads/community_posts/post_upload_file-1567585894274.mp4",
        //                     "type":"Video"],
        //                    ["name" : "demo1",
        //                     "url":"http://np.seasiafinishingschool.com:9054/uploads/community_posts/post_upload_file-1567590912634.wav",
        //                     "type":"Audio"],
        //                    ["name" : "demo1",
        //                     "url":"https://seasiabucket.s3.amazonaws.com/community-posts-1568962024220.png",
        //                     "type":"Image"],
        //                    ["name" : "demo1",
        //                     "url":"http://np.seasiafinishingschool.com:9054/uploads/community_posts/post_upload_file-1567590912634.wav",
        //                     "type":"Audio"]]
        
        
        
        CoreData_Model.get_offline_saved_memories(success: { (arr) in
            
            self.arrItems = NSMutableArray(array: arr)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        })
        { (error) in
            print(error)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        
    }
    
    @IBAction func actnDateEmoji(_ sender: Any)
    {
        
        
        dropDown.show()
        
    }
    @IBAction func actnMoreEmoji(_ sender: Any)
    {
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .ChooseMood, Data: "0")
        
        //   CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .AddActivityWithMood, Data: nil)
        // CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .CommentViewController, Data: nil)
        
        //  CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .ReminderVC, Data: nil)
        //  CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .MyVentsVC, Data: nil)
        
        
    }
    @IBAction func happyMemoriesPlayPauseMusic(_ sender: UIButton)
    {
        if let indexPath = collectionView.indexPathsForVisibleItems.first
        {
            
            let dic = self.arrItems.object(at: indexPath.row) as? NSDictionary
            let Url = dic?.value(forKey: coreDataKeys_HappyMemories.url) as? String ?? ""
            let cell = collectionView.cellForItem(at: indexPath) as!  HappyMemoriesAudioCell
            
            play_sliding_audio(fileName: Url, sender: sender)
            
            //            if (cell.btnPlaySound.backgroundImage(for: UIControl.State.normal) == UIImage(named:"play"))
            //            {
            //                audioPlayer?.pause()
            //                cell.btnPlaySound.setBackgroundImage(UIImage(named: "pause"), for: UIControl.State.normal)
            //            }
            //            else
            //            {
            //                audioPlayer?.play()
            //                cell.btnPlaySound.setBackgroundImage(UIImage(named: "play"), for: UIControl.State.normal)
            //            }
            
            
            //            if(cell.player?.rate != 0)
            //            {
            //               // cell.pause()
            //                audioPlayer?.pause()
            //              //  play_sliding_audio(fileName: Url, sender: sender)
            //                cell.btnPlaySound.setBackgroundImage(UIImage(named: "play"), for: UIControl.State.normal)
            //                //cell.btnPlaySound.setTitle("play", for: .normal)
            //            }
            //            else
            //            {
            //                //cell.play()
            //                play_sliding_audio(fileName: Url, sender: sender)
            //                cell.btnPlaySound.setBackgroundImage(UIImage(named: "pause"), for: UIControl.State.normal)
            //                //cell.btnPlaySound.setTitle("pause", for: .normal)
            //            }
            
        }
        
    }
    @IBAction func happyMemoriesPlayPauseVideo(_ sender: Any)
    {
        if let indexPath = collectionView.indexPathsForVisibleItems.first
        {
            
            let dic = self.arrItems.object(at: indexPath.row) as? NSDictionary
            
            let Url = dic?.value(forKey: coreDataKeys_HappyMemories.url) as? String ?? ""
            let cell = collectionView.cellForItem(at: indexPath) as! HappyMemoriesVideoCell
            if(cell.player?.rate != 0)
            {
                cell.pauseVideo()
                cell.btnPlay.setBackgroundImage(UIImage(named: "play"), for: .normal)
                // cell.btnPlay.setImage(UIImage(named: "play"), for: .normal)
                //cell.btnPlay.setTitle("play", for: .normal)
            }
            else
            {
                cell.playVideo()
                cell.btnPlay.setBackgroundImage(UIImage(named: "pause"), for: .normal)
                //cell.btnPlay.setImage(UIImage(named: "pause"), for: .normal)
                // cell.btnPlay.setTitle("pause", for: .normal)
            }
            
            
            
        }
    }
    /* func configureSideMenu() {
     if revealViewController() != nil {
     let panGest = self.revealViewController().panGestureRecognizer()
     let tapGest = self.revealViewController().tapGestureRecognizer()
     panGest?.cancelsTouchesInView = false
     tapGest?.cancelsTouchesInView = false
     
     if let panGest = panGest{
     view.addGestureRecognizer(panGest)
     }
     if let tapGest = tapGest{
     view.addGestureRecognizer(tapGest)
     }
     
     }
     }*/

    //MARK:- IBActions
    @IBAction func ActionSideMenu(_ sender: Any)
    {
        self.view.makeToast(Constants.Global.MessagesStrings.ComingSoon)
    }
    @IBAction func ActionNotification(_ sender: Any) {
        self.view.makeToast(Constants.Global.MessagesStrings.ComingSoon)
    }
    
    @IBAction func open_Bar(_ sender: Any)
    {
        self.revealViewController().revealToggle(sender)
    }
    
    
    @IBAction func actnHappyMemories(_ sender: Any)
    {
        audioPlaying = false
        audioPlayer?.pause()
        self.timer.invalidate()
        let storybaord = UIStoryboard.init(name:"HappyMemories", bundle: nil)
        if let presentedViewController = storybaord.instantiateViewController(withIdentifier: "AddHappyMemoriesNav") as? UIViewController
        {
            presentedViewController.providesPresentationContextTransitionStyle = true
            presentedViewController.definesPresentationContext = true
            presentedViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
            presentedViewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            self.present(presentedViewController, animated: false) {
                self.stopScrolling()
                if let indexPath = self.collectionView.indexPathsForVisibleItems.first
                {
                    let dic = self.arrItems.object(at: indexPath.row) as? NSDictionary
                    let type = dic?.value(forKey: coreDataKeys_HappyMemories.type)as? String ?? ""
                    
                    if(type == "AUDIO")
                    {
                        let cell = self.collectionView.cellForItem(at: indexPath) as!  HappyMemoriesAudioCell
                        if(self.audioPlayer?.rate != 0)
                        {
                            //cell.pause()
                            self.audioPlayer?.pause()
                            cell.btnPlaySound.setBackgroundImage(UIImage(named: "play"), for: UIControl.State.normal)
                            //cell.btnPlaySound.setTitle("play", for: .normal)
                        }
                    }
                    else if(type == "VIDEO")
                    {
                        let cell = self.collectionView.cellForItem(at: indexPath) as! HappyMemoriesVideoCell
                        if(cell.player?.rate != 0)
                        {
                            cell.pauseVideo()
                            cell.btnPlay.setBackgroundImage(UIImage(named: "play"), for: .normal)
                            //cell.btnPlay.setImage(UIImage(named: "play"), for: .normal)
                            //cell.btnPlay.setTitle("play", for: .normal)
                        }
                    }
                    
                }
            }
            
        }
    }
    
    @IBAction func btnCaptureImage(_ sender: Any)
    {
        //        self.takeNewPhotoFromCamera()
        self.addImageOptions()
    }
    
    @IBAction func ActionMeditation(_ sender: Any)
    {
        self.timer.invalidate()
        //self.view.makeToast(Constants.Global.MessagesStrings.ComingSoon)
        //  CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .MediationWelcome, Data: nil)
        
        let story = UIStoryboard.init(name: "Meditation", bundle: nil)
        
        let controller = story.instantiateViewController(withIdentifier: "MeditationPagerVC")as! MeditationPagerVC
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func ActionProfessionals(_ sender: Any) {
        self.timer.invalidate()
        self.view.makeToast(Constants.Global.MessagesStrings.ComingSoon)
    }
    @IBAction func open_SideBar(_ sender: Any) {
        
        self.revealViewController().revealToggle(sender)
    }
    private func setImage(type:String?)
    {
        
        if(type == "Happy"){
            self.imageEmotion.image = UIImage.init(named: "homeLaughed")
        }else if(type == "Sad"){
            self.imageEmotion.image = UIImage.init(named: "homeSad")
        }
        //        else if(type == "Angry")
        //        {
        //            self.imageEmotion.image = UIImage.init(named: "homeAngry")
        //        }else if(type == "fear"){
        //            self.imageEmotion.image = UIImage.init(named: "homeAngry")
        //        }else if(type == "disgust"){
        //            self.imageEmotion.image = UIImage.init(named: "homeAngry")
        //        }else if(type == "neutral"){
        //            self.imageEmotion.image = UIImage.init(named: "homeWink")
        //        }else if(type == "surprise"){
        //            self.imageEmotion.image = UIImage.init(named: "homeWow")
        //        }else{
        //            self.imageEmotion.image = UIImage.init(named: "homeAngry")
        //        }
    }
    
    
    func showDatePicker()
    {
        //Formate Date
        datePicker.datePickerMode = .date
        //        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        //        var components = DateComponents()
        //        components.calendar = calendar
        //        components.year = -19
        //        components.month = 12
        //        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        //        components.year = -70
        //        let minDate = calendar.date(byAdding: components, to: currentDate)!
        //        datePicker.minimumDate = minDate
        //        datePicker.maximumDate = maxDate
        
        let calendar = Calendar(identifier: .gregorian)
        var comps = DateComponents()
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        datePickerNew.maximumDate = currentDate
        datePickerNew.minimumDate = yesterdayDate
        
        
        //yourPicker.maximumDate = yesterdayDate
        
        
        //        UIView.animate(withDuration: 0.5, animations: <#T##() -> Void#>)
        self.constraintPickerView.constant = 260
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        //        datePicker.date = Date()
        //        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())
        //        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())
        
        
        
        //ToolBar
        //        let toolbar = UIToolbar();
        //        toolbar.barStyle = UIBarStyle.default
        //        toolbar.isTranslucent = true
        //        toolbar.tintColor = UIColor.black
        //        toolbar.sizeToFit()
        //        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        //        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        //        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        //
        //        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        //        //self.btn_chooseDate.inputAccessoryView = toolbar
        //        //self.btn_chooseDate.inputView = datePicker
        //       // self.tf_Date.inputAccessoryView = toolbar
        //        //self.tf_Date.inputView = datePicker
        //
        //        bgViewDatePicker.frame = self.view.frame
        //        bgViewDatePicker.backgroundColor = .white
        //        bgViewDatePicker.alpha = 0.2
        //        self.view.addSubview(bgViewDatePicker)
        //        self.datePicker.frame = CGRect(x: 0, y: 400, width:self.view.frame.size.width, height: 200)
        //        bgViewDatePicker.addSubview(datePicker)
    }
    
    @objc func donedatePicker()
    {
        //  let formatter = DateFormatter()
        //  formatter.dateFormat = "dd-MM-yy"
        // formatter.dateFormat = "yy-MM-dd"
        lblSetDayEmoji.text = "Past"
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker()
    {
        lblSetDayEmoji.text = "Today"
        self.view.endEditing(true)
    }
    
    func play_sliding_audio(fileName:String,sender:UIButton)
    {
        self.fileNAME = fileName
        let outputURL = documentURL().appendingPathComponent(fileName)
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: outputURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.delegate = self
        }
        catch
        {
            print(error)
            self.fileNAME = ""
        }
        
        if((audioPlayer) != nil)
        {
            
            if (audioPlaying == false)
            {
                audioPlaying = true
                audioPlayer?.play()
                sender.setBackgroundImage(UIImage(named: "pause"), for: UIControl.State.normal)
            }
            else if (audioPlaying == true)
            {
                audioPlaying = false
                audioPlayer?.pause()
                sender.setBackgroundImage(UIImage(named: "play"), for: UIControl.State.normal)
            }
            
            
            //            if(audioPlayer!.isPlaying)
            //            {
            //                audioPlayer!.pause()
            //            }
            //            else
            //            {
            //                audioPlayer!.play()
            //            }
        }
        
    }
    
}
extension HomeVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            // choose a name for your image
            let fileName = "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
            // create the destination file url to save your image
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            // get your UIImage jpeg data representation and check if the destination file url already exists
            if let data = pickedImage.jpegData(compressionQuality: 1.0),
                !FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    // writes the image data to disk
                    try data.write(to: fileURL)
                    
                    if(pickedImage != nil)
                    {
                        self.presenter?.getFaceEmotion(image: pickedImage)
                    }
                    //print("file saved")
                } catch {
                    //print("error saving file:", error)
                }
            }
        }else{
            
        }
        dismiss(animated: true)
    }
}
extension HomeVC:HomeDelegate{
    func HomeDidSucceeed(message:String?)
    {
        hideLoader()
//        if (message == "Mood tracked successfully!")
//        {
//           // self.showAlert(alertMessage: message ?? "")
//            /**
//             Gagan
// Scenario changed Now after ai result go to next screen
// */
//            let currrentEmojiDetail = self.emojiArray[ExtensionModel.shared.Emoji_CurrentPage]
//            let date = self.dateFromISOStringForMoodlogs(string: "\(Date())") ?? ""
//
//            self.presenter?.setMoodFromServer(moodType: currrentEmojiDetail.title, dateTime: date, iconName: currrentEmojiDetail.description)
//
//
//              // self.presenter?.setMoodFromServer(moodType: character.title, dateTime: dateToSend, iconName: character.description)
//
//            //self.viewDidAppear(true)
//        }
//        else
//        {
//          //  self.showAlert(alertMessage: "Mood Updated successfully!")
//        }
        
        
        if (push_to_edit_mood == true)
        {
           // if (message == "Mood tracked successfully!")
           // {
           self.showAlert(alertMessage: message ?? "Mood Updated successfully!")
            //self.view.makeToast(message ?? "Mood tracked successfully!")
                
           // }
            CommonFunctions.sharedInstance.PushToContrller(from:self, ToController: .AddActivityWithMood, Data: nil)
        }
    }
    
    func AIDidSucceeed(message:String?){
        
        self.hideLoader()
        
        let currrentEmojiDetail = self.emojiArray[ExtensionModel.shared.Emoji_CurrentPage]
        //let date = self.dateFromISOStringForMoodlogs(string: "\(Date())") ?? ""
        var dateToSend = String()
        
        var setDateForSort = String()
        
        if (self.lblSetDayEmoji.text == "Today")
        {
            
            dateToSend = self.dateFromISOStringForMoodlogs(string: "\(Date())") ?? ""
            setDateForSort = self.dateFromISOStringToSort(string: "\(Date())") ?? ""
            Singleton.shared().currentDate_for_offline_emojy = dateToSend
            Singleton.shared().currentDate_for_offline_emojy_sorting = setDateForSort
        }
        else
        {
            
            dateToSend = self.dateFromISOStringPastMoodLog(string: pastDate ) ?? ""
            setDateForSort = self.dateFromISOStringToSort(string: pastDate) ?? ""
            Singleton.shared().currentDate_for_offline_emojy = dateToSend
            Singleton.shared().currentDate_for_offline_emojy_sorting = setDateForSort
        }
        
        
        self.presenter?.setMoodFromServer(moodType: currrentEmojiDetail.title, dateTime: dateToSend, iconName: currrentEmojiDetail.description)
        if (checkInternetConnection() == true)
        {
            presenter?.get_emoji_offline()//on it
        }
        self.currentPage = ExtensionModel.shared.Emoji_CurrentPage
        push_to_edit_mood = true
        
    }
    
    
    func HomeDidFailed(message:String?)
    {
        hideLoader()
      //  self.showAlert(alertMessage: message ?? "Error occurred!")
        
        if (push_to_edit_mood == true)
        {
            CommonFunctions.sharedInstance.PushToContrller(from:self, ToController: .AddActivityWithMood, Data: nil)
        }
    }
    
    func stringToAttribute(stringToAppend: String, label:UILabel) {
        let myMutableString1 = NSMutableAttributedString(string: "I'm Feeling ",
                                                         attributes: [NSAttributedString.Key.foregroundColor:UIColor.black])
        
        let myMutableString2 = NSMutableAttributedString(string:stringToAppend,
                                                         attributes: [NSAttributedString.Key.foregroundColor:UIColor.blue])
        let combination = NSMutableAttributedString()
        combination.append(myMutableString1)
        combination.append(myMutableString2)
        label.attributedText = combination
    }
    
}

extension HomeVC:HomeViewDelegate
{
    func showAlert(alertMessage: String)
    {
        self.showAlert(Message: alertMessage)
    }
    
    func showLoader() {
        ShowLoaderCommon()
    }
    
    func hideLoader() {
        HideLoaderCommon()
    }
    
    
}

/** Extesnion for Happpy memories Slide Functionality */
extension HomeVC{
    fileprivate func setTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(scrollInterval), target: self, selector: #selector(self.autoScrollImageSlider), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer, forMode: RunLoop.Mode.common)
    }
    /**
     * Starts scrolling the collection view if there is at least one item in the datsource.
     */
    @objc func startScroll(notif: NSNotification){
        let firstIndex = 0
        let lastIndex = self.collectionView.numberOfItems(inSection: 0) - 1
        let visibleCellsIndexes = self.collectionView.indexPathsForVisibleItems.sorted()
        if !visibleCellsIndexes.isEmpty {
            let nextIndex = visibleCellsIndexes[0].row + 1
            let nextIndexPath: IndexPath = IndexPath.init(item: nextIndex, section: 0)
            let firstIndexPath: IndexPath = IndexPath.init(item: firstIndex, section: 0)
            (nextIndex > lastIndex) ? (self.scrollToIndex(IndexPath: firstIndexPath)) : (self.scrollToIndex(IndexPath: nextIndexPath))
        }
    }
    
    func startScrolling() {
        if !timer.isValid {
            if arrItems.count != 0 {
                stopScrolling()
                setTimer()
            }
        }
    }
    
    func stopScrolling()
    {
        self.timer.invalidate()
    }
    
    @objc fileprivate func autoScrollImageSlider() {
        DispatchQueue.main.async {
            let firstIndex = 0
            let lastIndex = self.collectionView.numberOfItems(inSection: 0) - 1
            let visibleCellsIndexes = self.collectionView.indexPathsForVisibleItems.sorted()
            if !visibleCellsIndexes.isEmpty {
                let nextIndex = visibleCellsIndexes[0].row + 1
                let nextIndexPath: IndexPath = IndexPath.init(item: nextIndex, section: 0)
                let firstIndexPath: IndexPath = IndexPath.init(item: firstIndex, section: 0)
                
                (nextIndex > lastIndex) ? (self.scrollToIndex(IndexPath: firstIndexPath)) : (self.scrollToIndex(IndexPath: nextIndexPath))
            }
        }
    }
    
    func scrollToPreviousOrNextCell(direction: BJAutoScrollingCollectionViewScrollDirection) {
        DispatchQueue.main.async {
            let firstIndex = 0
            let lastIndex = self.collectionView.numberOfItems(inSection: 0) - 1
            let visibleCellsIndexes = self.collectionView.indexPathsForVisibleItems.sorted()
            if !visibleCellsIndexes.isEmpty {
                let nextIndex = visibleCellsIndexes[0].row + 1
                let previousIndex = visibleCellsIndexes[0].row - 1
                let nextIndexPath: IndexPath = IndexPath.init(item: nextIndex, section: 0)
                let previousIndexPath: IndexPath = IndexPath.init(item: previousIndex, section: 0)
                
                switch direction {
                case .left:
                    (previousIndex < firstIndex) ? self.doNothing() : self.scrollToIndex(IndexPath: previousIndexPath)
                    break
                case .right:
                    (nextIndex > lastIndex) ? self.doNothing() : self.scrollToIndex(IndexPath: previousIndexPath)
                    break
                }
            }
        }
    }
    
    private func doNothing() { }
    
    func scrollToIndex(IndexPath:IndexPath)
    {
        if(IndexPath.row == arrItems.count - 1)
        {
            stopScrolling()
        }
        self.collectionView.scrollToItem(at: IndexPath, at: .centeredHorizontally, animated: true)
    }
}

extension HomeVC: UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == self.myCollectionView
        {
            return 1000
        }
        return arrItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var cell  =  UICollectionViewCell()
        
        if collectionView == self.myCollectionView
        {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as! CarouselCollectionViewCell
            let character = self.emojiArray[(indexPath as NSIndexPath).row % self.emojiArray.count]
            cell2.image.image = UIImage(named: character.imageName)
            cell = cell2
            
        }
        else
        {
            cell  =  collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! HappyMemoriesVideoCell
            let dic = arrItems.object(at: indexPath.row)as? NSDictionary
            let type = dic?.value(forKey: coreDataKeys_HappyMemories.type)as? String ?? ""
            let Url = dic?.value(forKey: coreDataKeys_HappyMemories.url)as? String ?? ""
            
            if(type == "VIDEO")
            {
                let cell  =  collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! HappyMemoriesVideoCell
                cell.addVideoLayer(playUrl: Url)
                cell.playVideo()
                return cell
            }
            else if(type == "IMAGE")
            {
                let cell  =  collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! HappyMemoriesImageCell
                
                let asset = dic?.value(forKey: coreDataKeys_HappyMemories.asset)as? String ?? ""
                let imag = self.decodeImage(base64: asset)
                cell.ImgView.image = imag
                
                return cell
            }
            else
            {
                let cell  =  collectionView.dequeueReusableCell(withReuseIdentifier: "SoundCell", for: indexPath) as!  HappyMemoriesAudioCell
                print("AudioUrl",Url)
                //cell.playAudio(url: Url)
                audioPlaying = false
                self.play_sliding_audio(fileName: Url, sender: cell.btnPlaySound)
                cell.ivAudio.image = UIImage(named:"audioBG")
                return cell
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        
        if collectionView == self.collectionView
        {
            let dic = arrItems.object(at: indexPath.row)as? NSDictionary
            let type = dic?.value(forKey: coreDataKeys_HappyMemories.type)as? String ?? ""
            
            self.lblCurrentSlideName.text = dic?.value(forKey: coreDataKeys_HappyMemories.location)as? String ?? ""
            self.lblCurrentSlideDesc.text = dic?.value(forKey: coreDataKeys_HappyMemories.name)as? String ?? ""
            
            
            let controller = CommonVc.AllFunctions.get_top_controller()
            print(controller.restorationIdentifier as Any)
            
            if (controller == HomeVC())
            {
                if(type == "VIDEO")
                {
                    // let Url = dic?.value(forKey: coreDataKeys_HappyMemories.url)as? String ?? ""
                    self.stopScrolling()
                    if let cell = cell as? HappyMemoriesVideoCell
                    {
                        
                        // cell.btnPlay.setImage(UIImage(named: "pause"), for: .normal)
                        // cell.btnPlay.setBackgroundImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControl.State#>)
                        cell.btnPlay.setBackgroundImage(UIImage(named: "pause"), for: .normal)
                        //cell.btnPlay.setTitle("pause", for: .normal)
                        cell.playVideo()
                    }
                    
                    audioPlaying = false
                    audioPlayer?.pause()
                }
                else if(type == "IMAGE")
                {
                    //                let Url = dic?.value(forKey: coreDataKeys_HappyMemories.url)as? String ?? ""
                    //                if let cell = cell as? HappyMemoriesImageCell
                    //                {
                    //
                    //                }
                    audioPlaying = false
                    audioPlayer?.pause()
                    self.startScrolling()
                }
                else
                {
                    let Url = dic?.value(forKey: coreDataKeys_HappyMemories.url)as? String ?? ""
                    if let cell = cell as?  HappyMemoriesAudioCell
                    {
                        self.stopScrolling()
                        //  cell.playAudio(url: Url)
                        //  cell.btnPlaySound.setBackgroundImage(UIImage(named: "play"), for: UIControl.State.normal)
                        audioPlaying = false
                        play_sliding_audio(fileName: Url, sender: cell.btnPlaySound)
                        
                        
                        //                    if let cell = cell as? HappyMemoriesVideoCell
                        //                    {
                        //                        cell.playVideo()
                        //                    }
                    }
                }
                
                audioPlaying = false
                audioPlayer?.pause()
            }else if(type == "VIDEO"){
                self.stopScrolling()
                if let cell = cell as? HappyMemoriesVideoCell
                {
                    
                    // cell.btnPlay.setImage(UIImage(named: "pause"), for: .normal)
                    // cell.btnPlay.setBackgroundImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControl.State#>)
                    cell.btnPlay.setBackgroundImage(UIImage(named: "pause"), for: .normal)
                    //cell.btnPlay.setTitle("pause", for: .normal)
                    cell.playVideo()
                }
                
                audioPlaying = false
                audioPlayer?.pause()
            }
            else if(type == "IMAGE")
            {
                //                let Url = dic?.value(forKey: coreDataKeys_HappyMemories.url)as? String ?? ""
                //                if let cell = cell as? HappyMemoriesImageCell
                //                {
                //
                //                }
                audioPlaying = false
                audioPlayer?.pause()
                self.startScrolling()
            }
            else
            {
                let Url = dic?.value(forKey: coreDataKeys_HappyMemories.url)as? String ?? ""
                if let cell = cell as?  HappyMemoriesAudioCell
                {
                    self.stopScrolling()
                    //  cell.playAudio(url: Url)
                    //  cell.btnPlaySound.setBackgroundImage(UIImage(named: "play"), for: UIControl.State.normal)
                    //NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
                    audioPlaying = false
                    play_sliding_audio(fileName: Url, sender: cell.btnPlaySound)
                    
                    
                    //                    if let cell = cell as? HappyMemoriesVideoCell
                    //                    {
                    //                        cell.playVideo()
                    //                    }
                }
            }
        }
        
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        
        if collectionView == self.collectionView
        {
            if (cell.isKind(of: HappyMemoriesVideoCell.self))
            {
                let cell   = cell as? HappyMemoriesVideoCell
                // cell?.removeObservers()
                cell?.pauseVideo()
                
            }
            else if(cell.isKind(of: HappyMemoriesAudioCell.self)){
                let cell   = cell as? HappyMemoriesAudioCell
                audioPlayer?.stop()
                cell?.pause()
            }
            else
            {
                
            }
        }
        else
        {
            //
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if (collectionView == self.myCollectionView)
        {
            let character = self.emojiArray[(indexPath as NSIndexPath).row % self.emojiArray.count]
            
            if self.imgSelectedMoodBar.isHidden == true{
               
                self.currentPage = 3
                ExtensionModel.shared.Emoji_CurrentPage = self.currentPage
            }
           
            var dateToSend = String()
            
            var setDateForSort = String()
            
            if (self.lblSetDayEmoji.text == "Today")
            {
                
                dateToSend = self.dateFromISOStringForMoodlogs(string: "\(Date())") ?? ""
                
                setDateForSort = self.dateFromISOStringToSort(string: "\(Date())") ?? ""
                Singleton.shared().currentDate_for_offline_emojy = dateToSend
                Singleton.shared().currentDate_for_offline_emojy_sorting = setDateForSort
            }
            else
            {
                
                dateToSend = self.dateFromISOStringPastMoodLog(string: pastDate ) ?? ""
                setDateForSort = self.dateFromISOStringToSort(string: pastDate) ?? ""
                Singleton.shared().currentDate_for_offline_emojy = dateToSend
                Singleton.shared().currentDate_for_offline_emojy_sorting = setDateForSort
            }
            
           
            
            
            print("dateToSend",dateToSend)
            
            self.showLoader()
            push_to_edit_mood = true
            self.presenter?.setMoodFromServer(moodType: character.title, dateTime: dateToSend, iconName: character.description)
            
        }
    }
    
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if scrollView == self.myCollectionView
        {
            //            let layout = self.myCollectionView.collectionViewLayout as! UPCarouselFlowLayout
            //            let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
            //            let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
            //            let cp = Int(floor((offset - pageSide / 2) / pageSide) + 1)
            //
            
            let visibleRect = CGRect(origin: myCollectionView.contentOffset, size: myCollectionView.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            let visibleIndexPath = myCollectionView.indexPathForItem(at: visiblePoint)
            let cp = (visibleIndexPath?.row)!
            self.currentPage = cp % self.emojiArray.count
            print(currentPage)
            ExtensionModel.shared.Emoji_CurrentPage = self.currentPage
            
            if (checkInternetConnection() == false)
            {
                
                var dateToSend = String()
                var setDateForSort = String()
                
                if (self.lblSetDayEmoji.text == "Today")
                {
                    
                    dateToSend = self.dateFromISOStringForMoodlogs(string: "\(Date())") ?? ""
                    
                    setDateForSort = self.dateFromISOStringToSort(string: "\(Date())") ?? ""
                    Singleton.shared().currentDate_for_offline_emojy = dateToSend
                    Singleton.shared().currentDate_for_offline_emojy_sorting = setDateForSort
                    
                    
                }
                else
                {
                    
                    dateToSend = self.dateFromISOStringPastMoodLog(string: pastDate ) ?? ""
                    setDateForSort = self.dateFromISOStringToSort(string: pastDate) ?? ""
                    Singleton.shared().currentDate_for_offline_emojy = dateToSend
                    Singleton.shared().currentDate_for_offline_emojy_sorting = setDateForSort
                }
                
                let character = self.emojiArray[self.currentPage]
                presenter?.update_emoji_offline(imageName: character.imageName, feel: diffrColorTxt, indx: self.currentPage, iconName: character.description)
            }
            
        }
        
    }
    
    
    fileprivate func setupLayout()
    {
        let layout = self.myCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: self.view.frame.size.width/3 - 20)
    }
    
    fileprivate func createItems() -> [CharacterC]
    {
        let characters = CommonVc.AllFunctions.createEmojy_forMood()
        return characters
        
    }
    
    func decodeImage(base64:String) -> UIImage
    {
        let dataDecoded:NSData = NSData(base64Encoded: base64, options: NSData.Base64DecodingOptions(rawValue: 0))!
        if (dataDecoded.length == 0)
        {
            let image = UIImage()
            return image
        }
        else
        {
            let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
            return decodedimage
        }
    }
    
    
    @objc func refresh_offline_array()
    {
        self.self.arrItems = NSMutableArray()
        self.HappyMemoriesSlide()
    }
    
    
    
    //MARk: <- GETTING CURRENT LOCATION ->
    
    
}

extension HomeVC: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        if collectionView == self.collectionView
        {
            let itemWidth = collectionView.frame.size.width
            let itemHeight = collectionView.frame.size.height
            return CGSize(width: itemWidth, height: itemHeight)
        }
        
        
        return  CGSize(width: self.view.frame.size.height/10, height: self.view.frame.size.height/10)
    }
}

extension HomeVC:CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        location.stopUpdatingLocation()
        //let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        // print("locations = \(locValue.latitude) \(locValue.longitude)")
        fetchCityAndCountry(from: locations[0]) { (city, Country, error) in
            if(city?.count ?? 0 > 0)
            {
                // print("currentLocation",city)
                // print("currentLocation",Country)
                UserDefaults.standard.setLocation(value: city)
            }
        }
        
    }
}
extension HomeVC:AVAudioPlayerDelegate{
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("finished")//It is working now! printed "finished"!
        
        // NotificationCenter.default.removeObserver(self)
        //audioPlayer?.seek(to: CMTime.zero)
        audioPlayer?.stop()
        //btnPlaySound.setTitle("play", for: .normal)
        //self.startScroll(notif: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startScroll"), object: nil)
    }
    
}

