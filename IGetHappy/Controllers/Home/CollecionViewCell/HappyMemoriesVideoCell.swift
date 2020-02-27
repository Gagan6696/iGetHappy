//
//  HappyMemoriesVideoCell.swift
//  IGetHappy
//
//  Created by Gagan on 9/24/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class HappyMemoriesVideoCell: UICollectionViewCell {
    
    
    @IBOutlet weak var viewForVideo: UIView!
    
    @IBOutlet weak var btnPlay: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    var player: AVPlayer?
    
    override func awakeFromNib() {
        
    }
    
    func addVideoLayer(playUrl:String)
    {
        
        if (playUrl.count > 0)
        {
            let fm = FileManager.default
            let docsurl = try! fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let path = docsurl.appendingPathComponent(playUrl)
            let videoURL = NSURL(string: path.absoluteString)
            
            player = AVPlayer(url: videoURL! as URL)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.contentView.frame
            // playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            playerLayer.backgroundColor = UIColor.black.cgColor
            btnPlay.setBackgroundImage(UIImage(named: "pause"), for: .normal)
            viewForVideo.layer.addSublayer(playerLayer)
            //viewForVideo.layer.addSublayer(playerLayer)
            
        }
        else
        {
           // CommonVc.AllFunctions.showAlert(message: "Sorry this video path is not correct!", view: self, title: Constants.Global.ConstantStrings.KAppname)
        }
    }
    
    func playVideo(){
        
        if(player != nil){
            print("player not nil")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        print(player?.status)
        player?.play()
    }
    func pauseVideo(){
        print(player?.status)
        player?.pause()
        
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Video Finished")
       // NotificationCenter.removeObserver(self, forKeyPath: "playerDidFinishPlaying")
       // NotificationCenter.default.removeObserver(self)
        player!.seek(to: CMTime.zero)
        self.btnPlay.setBackgroundImage(UIImage.init(named: "play"), for: .normal)
       // btnPlay.setTitle("play", for: .normal)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startScroll"), object: nil)
    }
   
}

