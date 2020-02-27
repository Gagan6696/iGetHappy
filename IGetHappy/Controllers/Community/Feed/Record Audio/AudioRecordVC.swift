//
//  AudioRecordVC.swift
//  IGetHappy
//
//  Created by Gagan on 5/31/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import SpeechRecognizerButton
class AudioRecordVC: BaseUIViewController {
    
    var countdownTimer: Timer!
    var totalTime = 10
    
    var toPass: URL?
    
    @IBOutlet weak var waveFormView: SFWaveformView!
    @IBOutlet weak var btn_PlayPause: UIButton!
    @IBOutlet weak var startTime: UILabel!
    
    
    @IBOutlet weak var btn_TapToPlay: SFButton!
    @IBOutlet weak var lbl_TapToStart: UILabel!
    
    @IBOutlet weak var progressLine: UISlider!
    var player : AVAudioPlayer! = nil
    @IBOutlet weak var btn_StopAndSave: UIButton!
    var updater : CADisplayLink! = nil
    @IBOutlet weak var view_PlayMusic: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view_PlayMusic.isHidden = true
        self.btn_StopAndSave.isHidden = true
        self.btn_TapToPlay.isHidden = false
       
        self.btn_TapToPlay.pushToTalk = false
        
        self.btn_TapToPlay.locale = .current
        self.waveFormView.isHidden = true
        self.btn_TapToPlay.waveformView(show: true, animationDuration: 30)
        self.HideNavigationBar(navigationController: self.navigationController!)
        btn_TapToPlay.errorHandler = {
            ///self.label.text = $0?.localizedDescription
            print("g",$0?.localizedDescription)
        }
        btn_TapToPlay.resultHandler = { recordURL, speechRecognitionResult in
            // TODO: Your code here!
           self.HideLoaderCommon()
            print(speechRecognitionResult)
            print(recordURL)
            self.btn_StopAndSave.isHidden = true
            self.view_PlayMusic.isHidden = false
            self.waveFormView.isHidden = true
            self.toPass = recordURL
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actnCancl(_ sender: Any) {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
        
    }
    @IBAction func Actn_TapToPlay(_ sender: Any) {
        self.waveFormView.isHidden = false
       self.lbl_TapToStart.isHidden = true
        btn_TapToPlay.isHidden = true
     
        self.btn_StopAndSave.isHidden = false
        
        startTimer()
    }
    @IBAction func seek_Audio(_ sender: Any) {
        //self.player.pause()
    
        // let normalizedTime = Float(player.currentTime * 100.0 / player.duration)
       let dur =  Float(player.duration)
           //print("progressLine.value",normalizedTime)
        let time = Float(progressLine.value * dur/100)
        print(time)
        self.player.currentTime = TimeInterval(time)
        
        ///self.player.play()
         self.player.play(atTime: TimeInterval.init(exactly: time)!)
    }
    
    @IBAction func Actn_StopAndSave(_ sender: Any) {
        self.ShowLoaderCommon()
        self.waveFormView.isHidden = true
        self.btn_TapToPlay.endRecord()
        btn_StopAndSave.isHidden = true
        self.view_PlayMusic.isHidden = false
        endTimer()
    }
    
    @IBAction func Actn_PlayMusic(_ sender: Any) {
        
        if btn_TapToPlay.isSelected {
           updater = CADisplayLink.init(target: self, selector: #selector(AudioRecordVC.trackAudio))
            
            ///updater = CADisplayLink(target: self, selector: Selector(("trackAudio")))
            updater.frameInterval = 1
            updater.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
            let fileURL = toPass
            do{
                try
                    self.player = AVAudioPlayer(contentsOf: fileURL!)
                
            }catch{
                
            }
           
            //player.numberOfLoops = 0 // play indefinitely
            player.prepareToPlay()
            
            player.delegate = self as? AVAudioPlayerDelegate
            player.play()
            
          
            progressLine.maximumValue = 100 // Percentage
        } else {
            player.stop()
        }
       
    }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    
    @objc func updateTime() {
        startTime.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        self.ShowLoaderCommon()
        self.waveFormView.isHidden = true
        self.btn_TapToPlay.endRecord()
        btn_StopAndSave.isHidden = true
        self.view_PlayMusic.isHidden = false
        countdownTimer.invalidate()
    }
    
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }

    @objc func trackAudio() {
        let normalizedTime = Float(player.currentTime * 100.0 / player.duration)
        progressLine.value = normalizedTime
        let time = Int(player.currentTime)
        startTime.text = "\(timeFormatted(time))"
       
    }
    
    
   
}
