//
//  MeditationHowItWorksVC.swift
//  IGetHappy
//  Created by Gagan on 9/26/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import AVKit
class MeditationHowItWorksVC: BaseUIViewController
{
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var videoView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.videoView.addSubview(btnPlay)
        guard let path = Bundle.main.path(forResource: "ForBiggerFun", ofType:"mp4") else
        {
            debugPrint("video.m4v not found")
            return
        }
        self.previewImageView.image  = generateThumbnail(path: URL.init(fileURLWithPath: path))
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
        
    }
   
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer)
    {
        //        if (sender.direction == .left)
        //        {
        //             CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .MeditationExploree, Data: nil)
        //
        //        }
        //
        //        if (sender.direction == .right)
        //        {
        //            CommonFunctions.sharedInstance.popTocontroller(from: self)
        //        }
    }
    
    @IBAction func backAction(_ sender: Any)
    {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
        
    }
    
    @IBAction func playVideo(_ sender: Any) {
        
        playVideo()
    }
    @IBAction func goToNext(_ sender: Any) {
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .MeditationExploree, Data: nil)
        
    }
    
    private func playVideo()
    {
        guard let path = Bundle.main.path(forResource: "ForBiggerFun", ofType:"mp4") else
        {
            debugPrint("video.m4v not found")
            return
        }
        
        
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        Singleton.shared().isPlayerDismissed = true
        
        self.present(playerController, animated: true, completion: nil)
        player.play()
        
//        present(playerController, animated: true)
//        {
//            player.play()
//        }
        
    }
}
