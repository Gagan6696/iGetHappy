
//  BreatheInhaleExhaleViewController.swift
//  IGetHappy
//  Created by Prabhjot Singh on 30/10/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import DropDown
import AVKit

class BreatheInhaleExhaleViewController: BaseUIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var txt: UITextField!
    @IBOutlet var currentProcessLabel: UILabel!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet var eclipseView: UIImageView!
    @IBOutlet var topButtonsBackgroundView: UIView!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var startStopButton: PSCustomButton!
    @IBOutlet var openMusicListButton: CustomButton!
    @IBOutlet var selectSoundButton: PSCustomButton!
    @IBOutlet var selectThemeButton: PSCustomButton!
    @IBOutlet var selectThemeBackgroundView: UIView!
    @IBOutlet var selectMusicBackgroundView: UIView!
    @IBOutlet var inhaleButton: PSCustomButton!
    @IBOutlet var exhaleButton: PSCustomButton!
    @IBOutlet var cycleButton: PSCustomButton!
    @IBOutlet var startEndBellSwitch: UISwitch!
    
    @IBOutlet weak var btnPauseResume: PSCustomButton!
    var audioPlayer: AVAudioPlayer?
    var audioPlayerBgMusic:AVAudioPlayer?
    let defaults = UserDefaults.standard
    var switchON : Bool = false
    /**
     isSelectedFromGallery is used to store information in this controller to reintialize player when timer completes
     */
    var isSelectedFromGallery = Bool()
    var currentMusicName = String()
    var arrCount: [String] = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30"]
    var isOn = false
    var timeUntilFire = TimeInterval()
    var finalTime = Int()
    var exhaleTime = String()
    let timeLeftShapeLayer = CAShapeLayer()
    let bgShapeLayer = CAShapeLayer()
    var timeLeft = TimeInterval()
    var endTime: Date?
    var timeLabel =  UILabel()
    var timer:Timer? = Timer()
    var timer_ping:Timer? = Timer()
    var timer_ping_update:Timer? = Timer()
    
    var myTotalPing = 0
    var myTotalCycle = 0
    var myFinalDuration = 0
    var myCycles = 1
    
    var finalInhaleTime = Int()
    var finalExhaleTime = Int()
    
    
    static var noOfCycles = 0
    // here you create your basic animation object to animate the strokeEnd
    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    
    func drawBgShape() {
        bgShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: timerView.frame.midX , y: timerView.frame.midY), radius:
            90, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        bgShapeLayer.strokeColor = UIColor.clear.cgColor
        bgShapeLayer.fillColor = UIColor.clear.cgColor
        bgShapeLayer.lineWidth = 15
        view.layer.addSublayer(bgShapeLayer)
        
        // timerView.layer.addSublayer(bgShapeLayer)
        // self.view.bringSubview(toFront: timerView)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        drawBgShape()
        addTimeLabel()
        
        if let lastMusic =  UserDefaults.standard.getLastBreatheMusic()
        {
            let lastSelected = UserDefaults.standard.getIsSelectedMusicFromGallery()
            isSelectedFromGallery = lastSelected ?? false
            currentMusicName = lastMusic
            createNewInstanceMusicPlayer(musicName: lastMusic, isFromGallery: isSelectedFromGallery)
        }
        else
        {
            createNewInstanceMusicPlayer(musicName: currentMusicName, isFromGallery: isSelectedFromGallery)
        }
        
        
        self.txt.isHidden = true
        selectSoundButton.layer.borderWidth = 1
        selectSoundButton.layer.borderColor = UIColor.white.cgColor
        
        selectThemeButton.layer.borderWidth = 1
        selectThemeButton.layer.borderColor = UIColor.white.cgColor
        
        //backgroundImageView.image = UIImage.init(named: "breatheBackground_1")
        if let lastImage = UserDefaults.standard.getLastBreatheImage(){
            self.backgroundImageView.image = UIImage.init(data: lastImage)
        }else{
            backgroundImageView.image = UIImage.init(named: "breatheBackground_1")
        }
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.isHidden = false
        startEndBellSwitch.isOn = false
        selectSoundButton.roundCorners([.topLeft, .bottomLeft], radius: 4)
        selectThemeButton.roundCorners([.topRight, .bottomRight], radius: 4)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
    }
    
    @IBAction func actionOpenCamera(_ sender: Any)
    {
        
        self.addImageOptions()
    }
    @IBAction func actionPauseResume(_ sender: Any)
    {
        
        print("CALLED---------")
        if (self.startStopButton.titleLabel?.text == "Start")
        {
           CommonVc.AllFunctions.showAlert(message: "In order to pause meditation, it should be started first!", view: self,  title:Constants.Global.ConstantStrings.KAppname)
        }
        else
        {
           self.PAUSE_TIMER()
        }
        
        
    }
    @IBAction func selectSoundButtonAction(_ sender: UIButton)
    {
        if((timer?.isValid ?? false))
        {
            self.view.makeToast("Please stop the timer to change music")
        }
        else
        {
            selectMusicBackgroundView.isHidden = false
        }
        
    }
    
    @IBAction func selectThemeButtonAction(_ sender: UIButton) {
        self.view.makeToast("Coming soon")
        //        if((timer?.isValid ?? false)){
        //            self.view.makeToast("Please Stop the timer to chnage theme")
        //        }else{
        //            selectThemeBackgroundView.isHidden = false
        //        }
        self.view.bringSubviewToFront(selectThemeBackgroundView)
        selectThemeBackgroundView.isHidden = false
    }
    
    @IBAction func inhaleExhaleCycleButtonAction(_ sender: UIButton) {
        
        let dropDown = DropDown()
        
        if sender.tag == 1 {
            dropDown.bottomOffset = CGPoint(x: inhaleButton.bounds.width, y: inhaleButton.bounds.height)
            dropDown.anchorView = inhaleButton
        }
        else if sender.tag == 2 {
            dropDown.bottomOffset = CGPoint(x: exhaleButton.bounds.width, y: exhaleButton.bounds.height)
            dropDown.anchorView = exhaleButton
        }
        else {
            dropDown.bottomOffset = CGPoint(x: cycleButton.bounds.width, y: cycleButton.bounds.height)
            dropDown.anchorView = cycleButton
        }
        dropDown.dataSource = arrCount
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            if sender.tag == 1 {
                self.inhaleButton.setTitle(item, for: .normal)
            }
            else if sender.tag == 2 {
                self.exhaleButton.setTitle(item, for: .normal)
            }
            else {
                self.txt.text = item
                self.cycleButton.setTitle(item, for: .normal)
                self.myCycles = Int(item) ?? 1
                self.left = self.myCycles
            }
            
            dropDown.hide()
        }
        dropDown.show()
        
    }
    
    @IBAction func crossButtonAction(_ sender: Any)
    {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    
    @IBAction func changeBackgroundButtonAction(_ sender: UIButton) {
        
        let buttonTag = sender.tag
        if buttonTag == buttonTag {
            
        }
        switch buttonTag {
        case 10:
            
            backgroundImageView.image = UIImage.init(named: "breatheBackground_1")
            let data  =  UIImage.init(named: "breatheBackground_1")?.pngData()
            UserDefaults.standard.setLastBreatheImage(value: data)
            break
        case 11:
            backgroundImageView.image = UIImage.init(named: "breatheBackground_2")
            let data  =  UIImage.init(named: "breatheBackground_2")?.pngData()
            UserDefaults.standard.setLastBreatheImage(value: data)
            break
        case 12:
            backgroundImageView.image = UIImage.init(named: "breatheBackground_3")
            let data  =  UIImage.init(named: "breatheBackground_3")?.pngData()
            UserDefaults.standard.setLastBreatheImage(value: data)
            break
        case 13:
            backgroundImageView.image = UIImage.init(named: "breatheBackground_4")
            let data  =  UIImage.init(named: "breatheBackground_4")?.pngData()
            UserDefaults.standard.setLastBreatheImage(value: data)
            break
        case 14:
            backgroundImageView.image = UIImage.init(named: "breatheBackground_5")
            let data  =  UIImage.init(named: "breatheBackground_5")?.pngData()
            UserDefaults.standard.setLastBreatheImage(value: data)
            break
        default: break
            
        }
        
    }
    
    @IBAction func hideMusicViewButtonAction(_ sender: Any) {
        
        selectMusicBackgroundView.isHidden = true
    }
    
    @IBAction func hideThemeOrSongViewButtonAction(_ sender: Any) {
        
        selectThemeBackgroundView.isHidden = true
    }
    @IBAction func openSongsListButtonAction(_ sender: Any) {
        
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "SelectMusicViewController")as? SelectMusicViewController else { return }
        popVC.modalPresentationStyle = .popover
        popVC.delegate = self
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = self.openMusicListButton
        popOverVC?.sourceRect = CGRect(x: self.openMusicListButton.bounds.midX , y: self.openMusicListButton.bounds.minY + openMusicListButton.frame.height - 5, width: 0, height: 0)
        //popVC.preferredContentSize = CGSize(width: 250, height: 350)
        popVC.preferredContentSize = CGSize(width: self.view.frame.width - 40, height: self.view.frame.height - 80)
        popVC.popoverPresentationController?.permittedArrowDirections = .up
        self.present(popVC, animated: true)
    }
    
    @IBAction func startStopTimer(_ sender: Any)
    {
        
        if  inhaleButton.titleLabel?.text == nil || inhaleButton.titleLabel?.text == "" {
            
            self.view.makeToast("Please enter inhale time")
            return
        }
        if  exhaleButton.titleLabel?.text == nil || exhaleButton.titleLabel?.text == "" {
            
            self.view.makeToast("Please enter exhale time")
            return
        }
        if  cycleButton.titleLabel?.text == nil || cycleButton.titleLabel?.text == "0" {
            
            self.view.makeToast("Please enter cycle time")
            return
        }
        
        if isOn == false
        {
            startStopButton.setTitle("Stop", for: .normal)
            isOn = true
            
            //timer.invalidate()
            //            inhaleButton.setTitle("", for: .normal)
            //            exhaleButton.setTitle("", for: .normal)
            //            cycleButton.setTitle("", for: .normal)
          //  strokeIt.fromValue = 0
            
            
            finalInhaleTime = Int(inhaleButton.titleLabel!.text!) ?? 0
            finalExhaleTime = Int(exhaleButton.titleLabel!.text!) ?? 0
            //finalInhaleTime = finalInhaleTime
           // finalExhaleTime = 7
            drawTimeLeftShape()
            finalTime = finalInhaleTime + finalExhaleTime
            self.timeLeftShapeLayer.strokeEnd = 1
            callTimerToStartBreathe(to: 1, from: 0, duration: finalInhaleTime, showExerciseText: "Inhale")
            BreatheInhaleExhaleViewController.noOfCycles = self.myCycles
           // self.myFinalDuration = Int(finalTime) ?? 0
           // self.myTotalCycle = Int(txt.text!)!
            
        }
        else
        {
            startStopButton.setTitle("Start", for: .normal)
            resetTimer()
            isOn = false
        }
        
    }
    
    
    @IBAction func backButtonAction(_ sender: Any)
    {
        resetTimer()
        // CommonFunctions.sharedInstance.popTocontroller(from: self)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func startEndBellSwitchAction(_ sender: Any) {
        
        if startEndBellSwitch.isOn
        {
            switchON = true
            //defaults.set(switchON, forKey: "switchON")
        }
        if startEndBellSwitch.isOn == false
        {
            switchON = false
            //defaults.set(switchON, forKey: "switchON")
        }
        
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func drawTimeLeftShape()
    {
        timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: timerView.frame.midX , y: timerView.frame.midY), radius:
            90, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        
        timeLeftShapeLayer.strokeColor = UIColor.white.cgColor
        timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
        timeLeftShapeLayer.lineWidth = 15
        //self.timeLeftShapeLayer.fillMode = CAMediaTimingFillMode.removed;
        //self.timeLeftShapeLayer.removeAllAnimations()
        view.layer.addSublayer(timeLeftShapeLayer)
        
    }
    
    func pause(_ layer: CALayer?)
    {
        let pausedTime: CFTimeInterval? = layer?.convertTime(CACurrentMediaTime(), from: nil)
        layer?.speed = 0.0
        layer?.timeOffset = pausedTime ?? 0
    }
    
    func resumeLayer(_ layer: CALayer?) {
        let pausedTime: CFTimeInterval? = layer?.timeOffset
        layer?.speed = 1.0
        layer?.timeOffset = 0.0
        layer?.beginTime = 0.0
        let timeSincePause: CFTimeInterval = (layer?.convertTime(CACurrentMediaTime(), from: nil) ?? 0) - (pausedTime ?? 0)
        layer?.beginTime = timeSincePause
    }
    
    func addTimeLabel()
    {
        
        timeLabel.frame.size.width = 80
        timeLabel.frame.size.height = 30
        //timeLabel.backgroundColor = .green
        timeLabel.center = eclipseView.center
        //timeLabel.textAlignment = .center
        timeLabel.text = timeLeft.time
        timeLabel.font = UIFont(name:"Roboto-Regular", size: 30.0)
        timeLabel.textColor = UIColor.white
        eclipseView.addSubview(timeLabel)
        self.view.bringSubviewToFront(timeLabel)
    }
    
    fileprivate func runTimer()
    {
        // self.myTotalPing = Int(finalTime) ?? 0
        
        timer?.invalidate()
        timer_ping?.invalidate()
        timer_ping_update?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        timer_ping = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(COUNT_PING), userInfo: nil, repeats: true)
        timer_ping_update = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(COUNT_PING_UPDATE), userInfo: nil, repeats: true)
        
    }
    
    var left = 0
    func callTimerToStartBreathe(to:Int,from:Int,duration:Int,showExerciseText:String)
    {
        self.currentProcessLabel.text = showExerciseText
        if switchON == true
        {
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf:  URL(fileURLWithPath: Bundle.main.path(forResource: "beep", ofType: "mp3")!))
                //8 - Prepare the song to be played
                audioPlayer!.prepareToPlay()
                
            } catch {
                //handle error
                print(error)
            }
            
            
            if((audioPlayer) != nil)
            {
                if(audioPlayer?.isPlaying ?? false)
                {
                    audioPlayer?.pause()
                }
                else
                {
                    audioPlayer?.play()
                    print("Play")
                }
            }
            else
            {
                self.audioPlayer?.play()
            }
            
            
        }
        
        if((audioPlayerBgMusic) != nil)
        {
            if(audioPlayerBgMusic?.isPlaying == false)
            {
                createNewInstanceMusicPlayer(musicName: currentMusicName, isFromGallery: isSelectedFromGallery)
               audioPlayerBgMusic?.play()
            }
            else
            {
                //createNewInstanceMusicPlayer(musicName: currentMusicName, isFromGallery: isSelectedFromGallery)
                //audioPlayerBgMusic?.play()
            }
                
//            if(audioPlayerBgMusic?.isPlaying ?? false)
//            {
//                //audioPlayerBgMusic!.pause()
//            }
//            else
//            {
//                audioPlayerBgMusic?.play()
//                print("Play")
//
//            }
        }
        else
        {
            createNewInstanceMusicPlayer(musicName: currentMusicName, isFromGallery: isSelectedFromGallery)
            audioPlayerBgMusic?.play()
        }
        
      //  drawTimeLeftShape()
       // print("In Start Count -----\(BreatheInhaleExhaleViewController.noOfCycles)")
        
//        //  let val = Int(self.cycleButton.titleLabel!.text!)!
//
//      //  left = left-1
//
//      //  BreatheInhaleExhaleViewController.noOfCycles = left
//        txt.text = "\(BreatheInhaleExhaleViewController.noOfCycles)"
//
//         BreatheInhaleExhaleViewController.noOfCycles = Int(txt.text!)!
       // let firstNumberConv :Int = Int(inhaleButton.titleLabel!.text!) ?? 0
       // let secondNumberConv :Int = Int(exhaleButton.titleLabel!.text!) ?? 0
       // guard firstNumberConv != nil && secondNumberConv != nil else {
       //     return
      //  }
      //let result = firstNumberConv! + secondNumberConv!
        
       // finalTime = String(duration)
       // print(finalTime)
        timeLeft = Double(duration)
        print("ind oiuble",timeLeft)
        view.backgroundColor = UIColor(white: 0.94, alpha: 1.0)
      // timeLeftShapeLayer.strokeEnd = 0
    
        //strokeIt.toValue = 0
        // here you define the fromValue, toValue and duration of your animation
        strokeIt.isRemovedOnCompletion = false
        strokeIt.fromValue = from
        strokeIt.toValue = to
        strokeIt.duration = Double(duration)
       
        // add the animation to your timeLeftShapeLayer
        timeLeftShapeLayer.add(strokeIt, forKey: nil)
        // define the future end time by adding the timeLeft to now Date()
        
        self.myTotalPing = Int(duration)
        //endTime = Date().addingTimeInterval(timeLeft)
        runTimer()
        
    }
    
   
    @objc func updateTime()
    {
        
        
        if finalTime >= 0{
            finalTime = finalTime - 1
           
             self.timeLabel.text = self.timeLeft.time
            print("timeLeft",timeLeft.time)
            print("finalTime",finalTime)
            if (timeLeft.time <= "00:00"){
                self.timeLeftShapeLayer.fillMode = CAMediaTimingFillMode.backwards;
                //self.timeLeftShapeLayer.removeAllAnimations()
                 self.timeLeftShapeLayer.strokeEnd = 0
                
                
               // self.strokeIt.fromValue = 1
                    //self.timeLeftShapeLayer.strokeEnd = 0
             self.callTimerToStartBreathe(to: 0, from: 1, duration: finalExhaleTime, showExerciseText:  "Exhale")
             
                 print("In lopp")
            }
//            if (finalTime <= finalExhaleTime){
//
//
//            }
            
        }else{
            print("In else case")
                if(BreatheInhaleExhaleViewController.noOfCycles != 0)
                {
                   // self.resetTimer()
                    finalTime = finalInhaleTime + finalExhaleTime
                    print("1")
                      print("Cycle Count -----\(BreatheInhaleExhaleViewController.noOfCycles)")
                      BreatheInhaleExhaleViewController.noOfCycles = BreatheInhaleExhaleViewController.noOfCycles - 1
                      print("Pending Count -----\(BreatheInhaleExhaleViewController.noOfCycles)")
                    let currentValue = BreatheInhaleExhaleViewController.noOfCycles
                    //cycleButton.titleLabel?.text = String(currentValue)
                    
                    self.txt.text = "\(currentValue)"
                    self.cycleButton.setTitle("\(currentValue)", for: .normal)
                    //print(cycleButton.titleLabel?.text)
                    //self.startStopTimer(self)
                    
                    
                    if BreatheInhaleExhaleViewController.noOfCycles <= 0
                    {
                         print("2")
                         self.audioPlayer?.play()
                        let currentValue = BreatheInhaleExhaleViewController.noOfCycles
                        //cycleButton.titleLabel?.text = String(currentValue)
                        self.timeLeftShapeLayer.strokeEnd = 1
                        self.resetTimer()
                        self.cycleButton.setTitle("\(currentValue)", for: .normal)
                        self.timeLabel.text = "00:00"
                        self.startStopButton.setTitle("Start", for: .normal)
                       //BreatheInhaleExhaleViewController.noOfCycles = Int(txt.text!)!
                        //self.drawBgShape()
                        self.currentProcessLabel.text = ""
                        self.cycleButton.setTitle("0", for: .normal)
                        return
                    }
                    else
                    {
                        print("3")
                        if(audioPlayerBgMusic == nil)
                        {
                            createNewInstanceMusicPlayer(musicName: currentMusicName, isFromGallery: isSelectedFromGallery)
                        }
                        //let secondNumberConv :Int = Int(exhaleButton.titleLabel!.text!) ?? 0
                        //self.callTimerToStartBreathe(to: 0, from: 1, duration: finalExhaleTime, showExerciseText:  "Exhale")
//                          let val = Int(self.cycleButton.titleLabel!.text!)!
//
//                          left = left-1
//
//                          BreatheInhaleExhaleViewController.noOfCycles = left
//                        txt.text = "\(BreatheInhaleExhaleViewController.noOfCycles)"
                        
                        //BreatheInhaleExhaleViewController.noOfCycles = Int(txt.text!)!
                      //  self.timeLeftShapeLayer.fillMode = CAMediaTimingFillMode.forwards;
                        
                       // self.timeLeftShapeLayer.removeAllAnimations()
                       // self.timeLeftShapeLayer.removeFromSuperlayer()
                      //  strokeIt.isRemovedOnCompletion = false
                        //strokeIt.fromValue = 0
                       // strokeIt.toValue = 0
                      //  self.drawTimeLeftShape()
                         //self.timeLeftShapeLayer.strokeEnd = 0
                          self.timeLeftShapeLayer.strokeEnd = 1
                        callTimerToStartBreathe(to: 1, from: 0, duration: finalInhaleTime, showExerciseText: "Inhale")
                       // self.startStopTimer(self)
                    }
                }
                else
                {
                    print("4")
                    let currentValue = BreatheInhaleExhaleViewController.noOfCycles
                    //cycleButton.titleLabel?.text = String(currentValue)
                  
                    self.cycleButton.setTitle("\(currentValue)", for: .normal)
                    self.resetTimer()
                }
        
        }
        
        
        
        
//        print("timeLeft",timeLeft)
//
//        if self.timeLeft > 0
//        {
////            if(Int(self.timeLeft) < Int(exhaleButton.titleLabel!.text!)!)
////            {
//             self.timeLabel.text = self.timeLeft.time
////            if(Int(self.timeLeft) < )
////            {
////
////                self.timeLeftShapeLayer.strokeColor = UIColor.white.cgColor
////                self.timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
////                //  self.timeLeft = self.endTime?.timeIntervalSinceNow ?? 0
////                self.timeLabel.text = self.timeLeft.time
////                //self.currentProcessLabel.text = "Exhale"
////                print("TIME LEFT \(self.timeLeft)")
////            }
////            else
////            {
////
////                self.timeLeftShapeLayer.strokeColor = UIColor.white.cgColor
////                self.timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
////                //  self.timeLeft = self.endTime?.timeIntervalSinceNow ?? 0
////                self.timeLabel.text = self.timeLeft.time
////              //  self.currentProcessLabel.text = "Inhale"
////                print("TIME LEFT \(self.timeLeft)")
////            }
//
//        }
//        else
//        {
//            if(BreatheInhaleExhaleViewController.noOfCycles != 0)
//            {
//
//                //  print("Cycle Count -----\(BreatheInhaleExhaleViewController.noOfCycles)")
//                //  BreatheInhaleExhaleViewController.noOfCycles = BreatheInhaleExhaleViewController.noOfCycles - 1
//                //  print("Pending Count -----\(BreatheInhaleExhaleViewController.noOfCycles)")
//                let currentValue = BreatheInhaleExhaleViewController.noOfCycles
//                //cycleButton.titleLabel?.text = String(currentValue)
//
//                self.txt.text = "\(currentValue)"
//                self.cycleButton.setTitle("\(currentValue)", for: .normal)
//                //print(cycleButton.titleLabel?.text)
//                //self.startStopTimer(self)
//
//
//                if BreatheInhaleExhaleViewController.noOfCycles <= 0
//                {
//                    let currentValue = BreatheInhaleExhaleViewController.noOfCycles
//                    //cycleButton.titleLabel?.text = String(currentValue)
//                    self.resetTimer()
//                    self.cycleButton.setTitle("\(currentValue)", for: .normal)
//                    self.timeLabel.text = "00:00"
//                    self.startStopButton.setTitle("Start", for: .normal)
//                    //self.drawBgShape()
//                    self.currentProcessLabel.text = ""
//                    self.cycleButton.setTitle("0", for: .normal)
//                    return
//                }
//                else
//                {
//                    if(audioPlayerBgMusic == nil)
//                    {
//                        createNewInstanceMusicPlayer(musicName: currentMusicName, isFromGallery: isSelectedFromGallery)
//                    }
//                    //let secondNumberConv :Int = Int(exhaleButton.titleLabel!.text!) ?? 0
//                    self.callTimerToStartBreathe(to: 0, from: 1, duration: finalExhaleTime, showExerciseText:  "Exhale")
//                }
//            }
//            else
//            {
//                let currentValue = BreatheInhaleExhaleViewController.noOfCycles
//                //cycleButton.titleLabel?.text = String(currentValue)
//
//                self.cycleButton.setTitle("\(currentValue)", for: .normal)
//                self.resetTimer()
//            }
//        }
//
    }
    
    
    func  createNewInstanceMusicPlayer(musicName:String,isFromGallery:Bool)
    {
        do
        {
            
            if(isFromGallery)
            {
                
                let outputURL = documentURL().appendingPathComponent("\(musicName).m4a")
                print("OutURL->\(outputURL)")
                
                audioPlayerBgMusic = try AVAudioPlayer(contentsOf: outputURL)
                //audioPlayerBgMusic = try AVAudioPlayer(contentsOf:  URL(musicName))
            }
            else
            {
                
                if musicName != ""{
                
                let checkExistence  = Bundle.main.path(forResource: musicName, ofType: "mp3")
                if(checkExistence == nil)
                {
                    audioPlayerBgMusic = try AVAudioPlayer(contentsOf:  URL(fileURLWithPath: Bundle.main.path(forResource: musicName, ofType: "aiff")!))
                }
                else
                {
                    audioPlayerBgMusic = try AVAudioPlayer(contentsOf:  URL(fileURLWithPath: Bundle.main.path(forResource: musicName, ofType: "mp3")!))
                }
                
                }
            }
            
            //8 - Prepare the song to be played
            audioPlayerBgMusic?.prepareToPlay()
            audioPlayerBgMusic?.numberOfLoops = -1
            
            
        }
        catch
        {
            //handle error
            print("createNew",error)
        }
    }
    
    func resetTimer()
    {
        DispatchQueue.main.async {
            self.btnPauseResume.setTitle("Pause", for: UIControl.State.normal)
            self.timeLabel.text = "00:00"
            //self.drawBgShape()
            self.timer?.invalidate()
            self.timer_ping?.invalidate()
            self.timer_ping_update?.invalidate()
            
            self.audioPlayerBgMusic?.stop()
         //   self.audioPlayerBgMusic? = AVAudioPlayer()
            //  self.audioPlayerBgMusic = nil
            self.isOn = false
            self.timer = nil
            self.timeLeftShapeLayer.fillMode = CAMediaTimingFillMode.removed;
            self.timeLeftShapeLayer.removeAllAnimations()
            self.currentProcessLabel.text = ""
            // self.cycleButton.setTitle("0", for: .normal)
            self.timeLeftShapeLayer.removeFromSuperlayer()
            BreatheInhaleExhaleViewController.noOfCycles = self.myCycles
            print("myCycles",self.myCycles)
            print("BreatheInhaleExhaleViewController.noOfCycles",BreatheInhaleExhaleViewController.noOfCycles)
            self.cycleButton.setTitle("\(self.myCycles)", for: .normal)
            self.startStopButton.setTitle("Start", for: .normal)
            self.left = self.myCycles
        }
        
    }
    
    func PAUSE_TIMER()
    {
        if btnPauseResume.tag == 0
        {
            btnPauseResume.tag = 1
            btnPauseResume.setTitle("Resume", for: UIControl.State.normal)
            self.timer?.invalidate()
            self.timer_ping?.invalidate()
             self.timer_ping_update?.invalidate()
            self.pause(timeLeftShapeLayer)
            self.audioPlayerBgMusic?.pause()
        }
        else if btnPauseResume.tag == 1
        {
            btnPauseResume.tag = 0
            btnPauseResume.setTitle("Pause", for: UIControl.State.normal)
            self.runTimer()
            self.resumeLayer(timeLeftShapeLayer)
            self.audioPlayerBgMusic?.play()
        }
    }
    
    @objc func COUNT_PING()
    {
        self.myTotalPing = self.myTotalPing-1
        print("MY TOTAL PING ----->>>>>\(self.myTotalPing)")
        
        timeLeft = Double(self.myTotalPing)
        
    }
    @objc func COUNT_PING_UPDATE()
    {
        
         self.timeLabel.text = self.timeLeft.time
      
        
    }
    
}

extension UIView
{
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat)
    {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}

extension TimeInterval {
    var time: String {
        return String(format:"%02d:%02d", Int(self/60),  Int(ceil(truncatingRemainder(dividingBy: 60))) )
    }
}
//extension Int {
//    var degreesToRadians : CGFloat {
//        return CGFloat(self) * .pi / 180
//    }
//}
extension BreatheInhaleExhaleViewController:SendDataFromSelectMusic{
    
    func sendMusicData(musicName: String?,isFromLibrary:Bool)
    {
        print("musicName",musicName!)
        
        UserDefaults.standard.setLastBreatheAudio(value: musicName)
        UserDefaults.standard.setIsSelectedMusicFromGallery(value: isFromLibrary)
        isSelectedFromGallery = isFromLibrary
        currentMusicName = musicName ?? ""
        DispatchQueue.main.async {
            self.selectMusicBackgroundView.isHidden = true
        }
        self.openMusicListButton.setTitle(musicName, for: .normal)
        //Create new instance for play music in background
        createNewInstanceMusicPlayer(musicName: musicName!, isFromGallery: isFromLibrary)
    }
    
}

extension BreatheInhaleExhaleViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
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
                    UserDefaults.standard.setLastBreatheImage(value: data)
                    self.backgroundImageView.image = pickedImage
                    
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
