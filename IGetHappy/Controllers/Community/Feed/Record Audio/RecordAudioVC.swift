//
//  RecordAudioVC.swift
//  IGetHappy
//
//  Created by Gagan on 7/22/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//
//


import UIKit
import AVFoundation
import CoreAudioKit
import Accelerate
import DropDown

enum RecorderState {
    case recording
    case stopped
    case denied
}

protocol RecorderViewControllerDelegate: class {
    func didStartRecording()
    func didFinishRecording()
}

let keyID = "key"

class RecordAudioVC: BaseUIViewController {
    
    var  delegatePassUrl  : AnyObject?
    @IBOutlet weak var txtfldStatus: UITextField!
    @IBOutlet weak var postSendView: UIView!
    
    
    @IBOutlet weak var forEditBgView: UIView!
    @IBOutlet weak var forEditCross: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var lblTapToPlay: UILabel!
    @IBOutlet weak var btnTapToPlay: UIButton!
    
    @IBOutlet weak var recordButton: RecordButton!
    @IBOutlet weak var audioView: AudioVisualizerView!
    @IBOutlet weak var progressLine: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    
    var selectedPostData: [Post]?
    var isEdit: Bool = false
    var countdownTimer: Timer!
    var player : AVPlayer! = nil
    var updater : CADisplayLink! = nil
    var totalTime = 10
    var path: URL?
    var flagForPlay:Int? = 0
    //MARK:- Properties
    var handleView = UIView()
    //var recordButton = RecordButton()
    //var timeLabel = UILabel()
     var sampleRate =  AVAudioSession.sharedInstance().sampleRate
    //var audioView = AudioVisualizerView()
    let audioEngine = AVAudioEngine()
    private var renderTs: Double = 0
    private var recordingTs: Double = 0
    private var silenceTs: Double = 0
    private var audioFile: AVAudioFile?
    weak var delegate: RecorderViewControllerDelegate?
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var lblPrivacy: UILabel!
    @IBOutlet weak var viewPlayMusic: UIView!
    let dropDown = DropDown()
    //    @IBOutlet weak var isAnonymous: UISwitch!
    var issAnonymous:String?
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var anonymusButton: UIButton!
    
    var parm = [String:Any]()
    //MARK:- Life Cycle
    var settings = [String:Any]()
    var currentTimeInterval:CMTime?
    var currentPlayerTime:Float?
    var playerItem:AVPlayerItem?
    var inputNode: AVAudioInputNode?
    var selectedPostVentsAudio : AllVentsModelDetail?
    var isEditVentsAudio  = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        inputNode = self.audioEngine.inputNode
        isEdit = selectedPostData?.first?.isEditingMode ?? false
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
            print("self.sampleRate",self.sampleRate)
            self.settings = [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMBitDepthKey: 16, AVLinearPCMIsFloatKey: true, AVNumberOfChannelsKey: 1, AVSampleRateKey :Float64(48000)] as [String : Any]
            
            self.btnPlay!.setImage(UIImage(named: "addVideoPlay"), for: .normal)
            self.setupHandelView()
            self.setupRecordingButton()
            self.setupTimeLabel()
            //setupAudioView()
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidPlayToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
            
            let notificationName = AVAudioSession.interruptionNotification
            NotificationCenter.default.addObserver(self, selector: #selector(self.handleRecording(_:)), name: notificationName, object: nil)
            
            
            self.dropDown.anchorView = self.imgDropDown // UIView or UIBarButtonItem
            
            // The list of items to display. Can be changed dynamically
            self.dropDown.dataSource = ["PUBLIC","FRIENDS","ONLYME"]
            
            self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                
                if (index == 1)
                {
                    CommonVc.AllFunctions.showAlert(message: "Friends feature is coming soon!", view: self, title: Constants.Global.ConstantStrings.KAppname)
                    self.lblPrivacy.text = "PUBLIC"
                }else{
                    self.lblPrivacy.text = item
                }
                
            }
            DropDown.startListeningToKeyboard()
            
        }
        
        if(isEdit){
            self.timeLabel.isHidden = true
            self.audioView.isHidden = true
            self.recordButton.isHidden = true
            self.btnPlay.isHidden = false
            self.forEditCross.isHidden = false
            self.btnTapToPlay.isHidden = true
            self.lblTapToPlay.isHidden = true
            self.postSendView.isHidden = false
            self.txtfldStatus.isHidden = false
            issAnonymous = selectedPostData?.first?.isAnonymous
            if issAnonymous == "YES"{
                self.anonymusButton.isSelected = false
            }else{
                self.anonymusButton.isSelected = true
            }
            self.txtDescription.text = selectedPostData?.first?.postDescription
            self.path = URL.init(string: selectedPostData?.first?.postfile ?? "")
            self.lblPrivacy.text = selectedPostData?.first?.privacyOption
 
            //self.viewPlayMusic.isHidden = true
            //setupAudioView()
        }else if(isEditVentsAudio){
            self.timeLabel.isHidden = true
            self.audioView.isHidden = true
            self.recordButton.isHidden = true
            self.btnPlay.isHidden = false
            self.forEditCross.isHidden = false
            self.btnTapToPlay.isHidden = true
            self.lblTapToPlay.isHidden = true
            self.postSendView.isHidden = false
            self.txtfldStatus.isHidden = false
            self.lblPrivacy.text = selectedPostVentsAudio?.privacy_option
            issAnonymous = selectedPostVentsAudio?.is_anonymous
            if issAnonymous == "YES"{
                self.anonymusButton.isSelected = false
            }else{
                self.anonymusButton.isSelected = true
            }
            self.txtDescription.text = selectedPostVentsAudio?.desc
            self.lblPrivacy.text = selectedPostVentsAudio?.privacy_option
            //let isValidUrl = self.verifyUrl(urlString: selectedPostData?.first?.postfile)
           // if isValidUrl {
            self.path = URL.init(string: selectedPostVentsAudio?.post_upload_file ?? "")
           // }else{
           //     CommonFunctions.sharedInstance.popTocontroller(from: self)
           // }
            
        }else if(Constants.isFromHappyMemories){
            
            self.audioView.isHidden = true
            self.recordButton.isHidden = true
            self.btnPlay.isHidden = true
            self.forEditCross.isHidden = true
            self.forEditBgView.isHidden = true
            self.postSendView.isHidden = true
            self.txtfldStatus.isHidden = true
            issAnonymous = UserDefaults.standard.getAnonymous()
            if issAnonymous == "YES"{
                self.anonymusButton.isSelected = false
            }else{
                self.anonymusButton.isSelected = true
            }
            
        }
        else{
            //sampleRate = audioEngine.inputNode.inputFormat(forBus: 0).sampleRate
            self.postSendView.isHidden = false
            self.txtfldStatus.isHidden = false
            self.audioView.isHidden = true
            self.recordButton.isHidden = true
            self.btnPlay.isHidden = true
            self.forEditCross.isHidden = true
            self.forEditBgView.isHidden = true
            
            issAnonymous = UserDefaults.standard.getAnonymous()
            if issAnonymous == "YES"{
                self.anonymusButton.isSelected = false
            }else{
                self.anonymusButton.isSelected = true
            }
            
            //self.viewPlayMusic.isHidden = true
            
        }
        
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let notificationName = AVAudioSession.interruptionNotification
        NotificationCenter.default.addObserver(self, selector: #selector(handleRecording(_:)), name: notificationName, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(Constants.isFromHappyMemories){
            Constants.isFromHappyMemories = false
            print("delegate class obj refrence",delegatePassUrl)
            
            if let type = delegatePassUrl as? RecordAudioMemoriesVC{
                if(path != nil){
                      type.pass(data: path!)
                }
            }else {
                if(path != nil){
                    if let type  = delegatePassUrl as?  JournelThoughtsVC {
                        type.pass(data: path!)
                    }
                }
            }
  
        }
       
        if player != nil {
            player.pause()
            player = nil
        }
        self.selectedPostVentsAudio = nil
        self.isEditVentsAudio = false
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func btnDeleteAudio(_ sender: Any) {
        if countdownTimer != nil{
            self.countdownTimer.invalidate()
        }
        totalTime = 10
        self.audioEngine.stop()
        self.audioFile = nil
        self.audioEngine.inputNode.removeTap(onBus: 0)
        if player != nil {
            player.pause()
            player = nil
           
        }
        self.timeLabel.isHidden = true
        self.audioView.isHidden = true
        self.recordButton.isHidden = true
        self.btnPlay.isHidden = true
        btnPlay!.setImage(UIImage(named: "addVideoPlay"), for: .normal)
        btnPlay!.setTitle("Play", for: UIControl.State.normal)
        btnPlay.tag = 0
        self.forEditCross.isHidden = true
        self.forEditBgView.isHidden = true
        
        self.btnTapToPlay.isHidden = false
        self.lblTapToPlay.isHidden = false
        
        self.path = nil
    }
    
    @IBAction func actionBack(_ sender: Any) {
       // stopRecording()
         // self.audioEngine.stop()
        if countdownTimer != nil{
            countdownTimer.invalidate()
        }
        
        self.audioFile = nil
        self.audioEngine.inputNode.removeTap(onBus: 0)
        self.audioEngine.stop()
//        if(Constants.isFromHappyMemories){
//            
//            self.dismiss(animated: false, completion: nil)
//        }
                    do {
                        DispatchQueue.main.async {
                              self.audioEngine.stop()
                            self.updateUI(.stopped)
        
        
                        }
                        try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
                        try AVAudioSession.sharedInstance().setActive(false)
                    } catch  let error as NSError {
                        player.pause()
                        btnPlay!.setImage(UIImage(named: "addVideoPlay"), for: .normal)
                        print("Audio error")
        
                        print(error.localizedDescription)
                        return
                    }
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    
    @IBAction func anonymusButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            issAnonymous = "No"
        }else{
            issAnonymous = "Yes"
        }
    }
    
    @IBAction func ActionDropDown(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func btnPlayRecordedMusic(_ sender: Any) {
        if btnPlay.tag == 0{
            if(currentTimeInterval == nil){
                player = nil
                if path != nil{
                    let asset = AVURLAsset(url: path!)
                    let playerItem = AVPlayerItem(asset: asset)
                    player = AVPlayer(playerItem: playerItem)
                    player!.play()
                }
            }else{
                player?.play()
            }
            
            btnPlay!.setImage(UIImage(named: "addVideoPauseButton"), for: .normal)
            btnPlay!.setTitle("Pause", for: UIControl.State.normal)
            btnPlay.tag = 1
        } else {
            if player != nil{
                player!.pause()
                currentTimeInterval = player.currentTime()
                btnPlay!.setImage(UIImage(named: "addVideoPlay"), for: .normal)
                btnPlay!.setTitle("Play", for: UIControl.State.normal)
                btnPlay.tag = 0
            }
        }
        
        
    }
    
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    
    @objc func updateTime() {
       // startTime.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        
        self.countdownTimer.invalidate()
//        self.recordButton.isHidden = true
//        self.btnPlay.isHidden = false
//        //self.viewPlayMusic.isHidden = false
//        self.audioView.isHidden = true
//        self.forEditBgView.isHidden = false
//        self.forEditCross.isHidden = true
//
//       // self.isRecording = false
//countdownTimer.invalidate()
//        countdownTimer.invalidate()
//        self.audioFile = nil
//        self.audioEngine.inputNode.removeTap(onBus: 0)
//        self.audioEngine.stop()
//        delay(2) {
             // self.stopRecording()
//        }
     // recordButton.isRecording = false
       // self.stopRecording()
        //handleRecording(recordButton)
//        DispatchQueue.main.async {
//            if self.isRecording() {
//                self.stopRecording()
//            }
//        }
        //audioEngine.stop()
        //recognitionRequest?.endAudio()
        //audioEngine.inputNode.removeTap(onBus: 0)
       //  recordButton.isRecording = false
//        handleRecording(recordButton)
         self.stopRecording()
        // recordButton.sendActions(for: .touchUpInside)
        
        
    }
    
    @IBAction func btnPostAudio(_ sender: Any) {
        
        
        if(isRecording()){
            self.view.makeToast("Please stop your audio before post.")
        }else{
            
            if(isEdit){
                
                //            if(txtDescription.text == ""){
                //                self.view.makeToast("Please type description")
                //            }else
                
                if(path == nil) {
                    self.view.makeToast("Please Record Audio First")
                }else{
                    if(path != nil){
                        self.loadFileAsync(url: path!) { (fileUrl, error) in
                            if(error == nil){
                                self.path =  fileUrl
                                
                                if let userId = UserDefaults.standard.getUserId(){
                                    self.parm["user_id"] = userId
                                }
                                self.parm["user_id"] = UserDefaults.standard.getUserId()
                                self.parm["description"] = self.txtDescription.text
                                self.parm["privacy_option"] = self.lblPrivacy.text
                                self.parm["is_anonymous"] = self.issAnonymous
                                self.parm["post_upload_type"] = "AUDIO"
                                var postIDSend:String?
                                if let postID = self.selectedPostData?.first?.postId{
                                    postIDSend = postID
                                }
                                DispatchQueue.main.async {
                                    self.ShowLoaderCommon()
                                }
                                
                                FeedServices.sharedInstance.editAudioPatchService(url: UrlStrings.EditPost.textTypePost + postIDSend! , fileUrl: self.path!, postDict: self.parm as [String : AnyObject], completionResponse: { (message) in
                                    print(message)
                                    self.HideLoaderCommon()
                                    self.AlertWithNavigatonPurpose(message: message, navigationType: .pop, ViewController: .none, rootViewController: .none, Data: nil)
                                }, completionnilResponse: { (message) in
                                    self.HideLoaderCommon()
                                    self.view.makeToast(message)
                                    
                                }, completionError: { (error) in
                                    self.HideLoaderCommon()
                                    self.view.makeToast((error?.localizedDescription)!)
                                    print(error?.localizedDescription)
                                }) { (networkError) in
                                    self.HideLoaderCommon()
                                    print(networkError)
                                }
                            }
                        }
                        
                    }
                }
                
            }else if (isEditVentsAudio){
                
                //Reminder
                //Please make one function
                if(path == nil) {
                    self.view.makeToast("Please Record Audio First")
                }else{
                    if(path != nil){
                        self.loadFileAsync(url: path!) { (fileUrl, error) in
                            if(error == nil){
                                self.path =  fileUrl
                                
                                if let userId = UserDefaults.standard.getUserId(){
                                    self.parm["user_id"] = userId
                                }
                                self.parm["user_id"] = UserDefaults.standard.getUserId()
                                self.parm["description"] = self.txtDescription.text
                                self.parm["privacy_option"] = self.lblPrivacy.text
                                self.parm["is_anonymous"] = self.issAnonymous
                                self.parm["post_upload_type"] = "AUDIO"
                                var postIDSend:String?
                                if let postID = self.selectedPostVentsAudio?._id{
                                    postIDSend = postID
                                }
                                DispatchQueue.main.async {
                                    self.ShowLoaderCommon()
                                }
                            
                            FeedServices.sharedInstance.editAudioPatchService(url: UrlStrings.EditPost.textTypePost + postIDSend! , fileUrl: self.path!, postDict: self.parm as [String : AnyObject], completionResponse: { (message) in
                                    print(message)
                                    self.HideLoaderCommon()
                                    self.AlertWithNavigatonPurpose(message: message, navigationType: .pop, ViewController: .none, rootViewController: .none, Data: nil)
                                }, completionnilResponse: { (message) in
                                    self.HideLoaderCommon()
                                    self.view.makeToast(message)
                                    
                                }, completionError: { (error) in
                                    self.HideLoaderCommon()
                                    self.view.makeToast((error?.localizedDescription)!)
                                    print(error?.localizedDescription)
                                }) { (networkError) in
                                     self.HideLoaderCommon()
                                    print(networkError)
                                }
                            }
                        }
                        
                    }
                }
            }else{
                
                if(path == nil){
                    self.view.makeToast("Please Record Audio First")
                }
                    //            else if(txtDescription.text == ""){
                    //                self.view.makeToast("Please type description")
                    //            }
                else{
                    if let userId = UserDefaults.standard.getUserId(){
                        parm["user_id"] = userId
                    }
                    parm["user_id"] = UserDefaults.standard.getUserId()
                    parm["description"] = txtDescription.text
                    parm["privacy_option"] = lblPrivacy.text
                    parm["is_anonymous"] = issAnonymous
                    parm["post_upload_type"] = "AUDIO"
                    DispatchQueue.main.async {
                        self.ShowLoaderCommon()
                    }
                    FeedServices.sharedInstance.AddSoundPostService(urlMedia: path!, url: UrlStrings.UploadPost.AllTypePost, postDict: parm, completionResponse: { (message) in
                       // self.view.makeToast(message)
                        self.HideLoaderCommon()
                        self.AlertWithNavigatonPurpose(message: message, navigationType: .pop, ViewController: .none, rootViewController: .none, Data: nil)
                        
                        print(message)
                    }, completionnilResponse: { (message) in
                        self.HideLoaderCommon()
                        self.view.makeToast(message)
                        print(message)
                    }, completionError: { (error) in
                        self.HideLoaderCommon()
                        self.view.makeToast((error?.localizedDescription)!)
                        print(error)
                    }) { (networkerror) in
                        self.HideLoaderCommon()
                        print(networkerror)
                    }
                }
            }
        }
    }
    
    @IBAction func ActionRecord(_ sender: Any) {
        self.audioView.isHidden = false
        self.recordButton.isHidden = false
        self.btnPlay.isHidden = true
        recordButton.sendActions(for: .touchUpInside)
        btnTapToPlay.isHidden = true
        self.lblTapToPlay.isHidden  = true
    }
    
    //MARK:- Setup Methods
    fileprivate func setupHandelView() {
        handleView.layer.cornerRadius = 2.5
        // handleView.backgroundColor = UIColor(r: 208, g: 207, b: 205)
        handleView.backgroundColor = UIColor(r: 208, g: 207, b: 205)
        view.addSubview(handleView)
        handleView.translatesAutoresizingMaskIntoConstraints = false
        handleView.widthAnchor.constraint(equalToConstant: 37.5).isActive = true
        handleView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        handleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        handleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        handleView.alpha = 0
    }
    
    fileprivate func setupRecordingButton() {
        recordButton.isRecording = false
        recordButton.addTarget(self, action: #selector(handleRecording(_:)), for: .touchUpInside)
    }
    
    fileprivate func setupTimeLabel() {
        //        view.addSubview(timeLabel)
        //        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        //        timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //        timeLabel.bottomAnchor.constraint(equalTo: recordButton.topAnchor, constant: -16).isActive = true
        //        timeLabel.text = "00.00"
        //        timeLabel.textColor = .gray
        //        timeLabel.alpha = 0
    }
    
    fileprivate func setupAudioView() {
        //audioView.frame = CGRect(x: 0, y: 24, width: view.frame.width, height: 135)
        //view.addSubview(audioView)
        //TODO: Add autolayout constraints
        audioView.alpha = 0
        audioView.isHidden = true
    }
    
    //MARK:- Actions
    @objc func handleRecording(_ sender: RecordButton) {
        
        if recordButton.isRecording {
            
            audioView.isHidden = false
            
            self.checkPermissionAndRecord()
        } else {
            
            self.stopRecording()
        }
    }
    
    //MARK:- Update User Interface
    private func updateUI(_ recorderState: RecorderState) {
        switch recorderState {
        case .recording:
            UIApplication.shared.isIdleTimerDisabled = true
            self.audioView.isHidden = false
            self.timeLabel.isHidden = false
            break
        case .stopped:
            UIApplication.shared.isIdleTimerDisabled = false
            self.audioView.isHidden = true
            self.timeLabel.isHidden = true
            break
        case .denied:
            UIApplication.shared.isIdleTimerDisabled = false
            self.btnTapToPlay.isHidden = false
            self.lblTapToPlay.isHidden  = false
            self.recordButton.isHidden = true
            self.showDialogForPermissions()
            self.audioView.isHidden = true
            self.timeLabel.isHidden = true
            break
        }
    }
    
    
    func showDialogForPermissions() {
        let alert = UIAlertController(title: Constants.Global.ConstantStrings.KAppname, message: Constants.Global.ConstantStrings.KMsgCameraPermission, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: Constants.Global.ConstantStrings.kOpenSettings, style: .default, handler: { (_) in
            DispatchQueue.main.async {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: { (success) in
                        print(success)
                    })
                }
            }
        }))
        alert.addAction(UIAlertAction(title: Constants.Global.ConstantStrings.KCancel, style: .cancel, handler: { (_) in
            CommonFunctions.sharedInstance.popTocontroller(from: self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func startRecording() {
         startTimer()
        if let d = self.delegate {
            d.didStartRecording()
        }
        
        self.recordingTs = NSDate().timeIntervalSince1970
        self.silenceTs = 0
        
//        do {
//            let session = AVAudioSession.sharedInstance()
//            try session.setCategory(.playAndRecord, mode: .default)
//            try session.setActive(true)
//        } catch let error as NSError {
//            print(error.localizedDescription)
//            return
//        }
//
       
        guard let format = self.format() else {
            return
        }
        
        inputNode?.installTap(onBus: 0, bufferSize: 1024, format: format) { (buffer, time) in
            let level: Float = -50
            let length: UInt32 = 1024
            buffer.frameLength = length
            let channels = UnsafeBufferPointer(start: buffer.floatChannelData, count: Int(buffer.format.channelCount))
            var value: Float = 0
            vDSP_meamgv(channels[0], 1, &value, vDSP_Length(length))
            var average: Float = ((value == 0) ? -100 : 20.0 * log10f(value))
            if average > 0 {
                average = 0
            } else if average < -100 {
                average = -100
            }
            let silent = average < level
            let ts = NSDate().timeIntervalSince1970
            if ts - self.renderTs > 0.1 {
                let floats = UnsafeBufferPointer(start: channels[0], count: Int(buffer.frameLength))
                let frame = floats.map({ (f) -> Int in
                    return Int(f * Float(Int16.max))
                })
                DispatchQueue.main.async {
                    let seconds = (ts - self.recordingTs)
                    self.timeLabel.text = seconds.toTimeString
                    self.renderTs = ts
                    let len = self.audioView.waveforms.count
                    for i in 0 ..< len {
                        let idx = ((frame.count - 1) * i) / len
                        let f: Float = sqrt(1.5 * abs(Float(frame[idx])) / Float(Int16.max))
                        self.audioView.waveforms[i] = min(49, Int(f * 50))
                    }
                    self.audioView.active = !silent
                    self.audioView.setNeedsDisplay()
                }
            }
            
            var write = false
            if silent {
                if ts - self.silenceTs < 0.25 && self.silenceTs > 0 {
                    write = true
                } else {
                    self.audioFile = nil
                    if let d = self.delegate {
                       // d.didAddRecording()
                    }
                }
            } else {
                write = true
                self.silenceTs = ts
            }
            if write {
                if self.audioFile == nil {
                    self.audioFile = self.createAudioRecordFile()
                }
                if let f = self.audioFile {
                    do {
                        try f.write(from: buffer)
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        do {
            self.audioEngine.prepare()
            try self.audioEngine.start()
        } catch let error as NSError {
            print(error.localizedDescription)
            return
        }
        self.updateUI(.recording)
    }

//    // MARK:- Recording
//    private func startRecording() {
//        startTimer()
////        if let d = self.delegate {
////            d.didStartRecording()
////        }
//
//        self.recordingTs = NSDate().timeIntervalSince1970
//        self.silenceTs = 0
//
//        do {
//            let session = AVAudioSession.sharedInstance()
//            try session.setCategory(.playAndRecord, mode: .default)
//            try session.setActive(true)
//        } catch let error as NSError {
//            print(error.localizedDescription)
//            return
//        }
//
//        let engine = AVAudioEngine()
//        let input = engine.inputNode
//        let bus = 0
//        let inputFormat = input.outputFormat(forBus: 0)
//        let inputNode = self.audioEngine.inputNode
//
//        inputNode.installTap(onBus: bus, bufferSize: 1024, format: inputFormat) { (buffer, time) in
//            let level: Float = -50
//            let length: UInt32 = 1024
//            buffer.frameLength = length
//            let channels = UnsafeBufferPointer(start: buffer.floatChannelData, count: Int(buffer.format.channelCount))
//            var value: Float = 0
//            vDSP_meamgv(channels[0], 1, &value, vDSP_Length(length))
//            var average: Float = ((value == 0) ? -100 : 20.0 * log10f(value))
//            if average > 0 {
//                average = 0
//            } else if average < -100 {
//                average = -100
//            }
//            let silent = average < level
//            let ts = NSDate().timeIntervalSince1970
//            if ts - self.renderTs > 0.1 {
//                let floats = UnsafeBufferPointer(start: channels[0], count: Int(buffer.frameLength))
//                let frame = floats.map({ (f) -> Int in
//                    return Int(f * Float(Int16.max))
//                })
//                DispatchQueue.main.async {
//                    let seconds = (ts - self.recordingTs)
//                    self.timeLabel.text = seconds.toTimeString
//                    self.renderTs = ts
//                    let len = self.audioView.waveforms.count
//                    for i in 0 ..< len {
//                        let idx = ((frame.count - 1) * i) / len
//                        let f: Float = sqrt(1.5 * abs(Float(frame[idx])) / Float(Int16.max))
//                        self.audioView.waveforms[i] = min(49, Int(f * 50))
//                    }
//                    self.audioView.active = !silent
//                    self.audioView.setNeedsDisplay()
//                }
//            }
//            if self.audioFile == nil {
//                self.audioFile = self.createAudioRecordFile()
//            }
//
//            if let f = self.audioFile {
//                do {
//                    try f.write(from: buffer)
//                } catch let error as NSError {
//                    print(error.localizedDescription)
//                }
//
//            }
//        }
//
//
//        do {
//            self.audioEngine.prepare()
//            try self.audioEngine.start()
//        } catch let error as NSError {
//            print(error.localizedDescription)
//            return
//        }
//        self.updateUI(.recording)
//    }
    
    
    func fileSize(forURL url: Any) -> Double {
        var fileURL: URL?
        var fileSize: Double = 0.0
        if (url is URL) || (url is String)
        {
            if (url is URL) {
                fileURL = url as? URL
            }
            else {
                fileURL = URL(fileURLWithPath: url as! String)
            }
            var fileSizeValue = 0.0
            try? fileSizeValue = (fileURL?.resourceValues(forKeys: [URLResourceKey.fileSizeKey]).allValues.first?.value as! Double?)!
            if fileSizeValue > 0.0 {
                print("fileSizeValue",fileSizeValue)
                fileSize = (Double(fileSizeValue) / (1024 * 1024))
            }
        }
        return fileSize
    }
    private func stopRecording() {
        self.recordButton.isHidden = true
        self.btnPlay.isHidden = false
        //self.viewPlayMusic.isHidden = false
        self.audioView.isHidden = true
        self.forEditBgView.isHidden = false
       // self.forEditCross.isHidden = true
        
        if isEdit || isEditVentsAudio{
               self.forEditCross.isHidden = false
        }else{
               self.forEditCross.isHidden = true
        }
        
//        if let d = self.delegate {
//            self.recordButton.isHidden = true
//            d.didFinishRecording()
//        }
        self.audioEngine.stop()
        self.audioFile = nil
        self.audioEngine.inputNode.removeTap(onBus: 0)
       // DispatchQueue.main.async {
 
        //}
         self.updateUI(.stopped)
//            do {
//                DispatchQueue.main.async {
//                      self.audioEngine.stop()
//                    self.updateUI(.stopped)
//                    
//                    
//                }
//                try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
//                try AVAudioSession.sharedInstance().setActive(false)
//            } catch  let error as NSError {
//                player.pause()
//                btnPlay!.setImage(UIImage(named: "addVideoPlay"), for: .normal)
//                print("Audio error")
//                
//                print(error.localizedDescription)
//                return
//            }

       
      
    }
    
    private func checkPermissionAndRecord() {
        let permission = AVAudioSession.sharedInstance().recordPermission
        switch permission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (result) in
                DispatchQueue.main.async {
                    if result {
                        self.startRecording()
                    }
                    else {
                        self.updateUI(.denied)
                    }
                }
            })
            break
        case .granted:
            self.startRecording()
            break
        case .denied:
            self.updateUI(.denied)
            break
        }
    }
    
    private func isRecording() -> Bool {
        if self.audioEngine.isRunning {
            return true
        }
        return false
    }
    
    private func format() -> AVAudioFormat? {
        let format = AVAudioFormat(settings: self.settings)
        return format
    }
    
    
    // MARK:- Paths and files
    private func createAudioRecordPath() -> URL? {
        let format = DateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss-SSS"
        let currentFileName = "recording-\(format.string(from: Date()))" + ".wav"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documentsDirectory.appendingPathComponent(currentFileName)
        path = url
       
        return url
    }
    
    private func createAudioRecordFile() -> AVAudioFile? {
        guard let path = self.createAudioRecordPath() else {
            return nil
        }
        do {
            let file = try AVAudioFile(forWriting: path, settings: self.settings, commonFormat: .pcmFormatFloat32, interleaved: true)
            return file
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    // MARK:- Handle interruption
    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let key = userInfo[AVAudioSessionInterruptionTypeKey] as? NSNumber
            else { return }
        if key.intValue == 1 {
            DispatchQueue.main.async {
                if self.isRecording() {
                    self.stopRecording()
                }
            }
        }
    }
    
}

extension RecordAudioVC {
    @objc func playerItemDidPlayToEndTime() {
        // load next video or something
        btnPlay!.setImage(UIImage(named: "addVideoPlay"), for: .normal)
        btnPlay!.setTitle("Play", for: UIControl.State.normal)
        btnPlay.tag = 0
        currentTimeInterval = nil
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
}

public extension UIColor {
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension Int {
    var degreesToRadians: CGFloat {
        return CGFloat(self) * .pi / 180.0
    }
}

extension Double {
    var toTimeString: String {
        let seconds: Int = Int(self.truncatingRemainder(dividingBy: 60.0))
        let minutes: Int = Int(self / 60.0)
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
