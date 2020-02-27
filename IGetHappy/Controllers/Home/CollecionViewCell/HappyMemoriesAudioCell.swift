//
//  HappyMemoriesAudioCell.swift
//  IGetHappy
//
//  Created by Gagan on 9/24/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class HappyMemoriesAudioCell: UICollectionViewCell {
    @IBOutlet weak var btnPlaySound: UIButton!
    var player: AVPlayer?
    @IBOutlet weak var soundView: UIView!
    @IBOutlet weak var ivAudio: UIImageView!
    var audioPlayer : AVAudioPlayer?
    
    func playAudio(url :String)
    {
        
         NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        let outputURL = documentURL().appendingPathComponent(url)
        do
        {
            guard let urlNew = URL.init(string: outputURL.absoluteString) else { return }
            let playerItem = AVPlayerItem.init(url: urlNew)
            player = AVPlayer.init(playerItem: playerItem)
            //Reminder
           // playAudioBackground()
            self.play()
        }
        catch
        {
            print(error)
        }
        
    }
    
    func playAudioBackground()
    {
        do
        {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        }
        catch
        {
            print(error)
        }
    }
    
    func pause()
    {
       // player!.pause()
    }
    
    func play()
    {
      //  player!.play()
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification)
    {
        print("Audio Finished")
        NotificationCenter.default.removeObserver(self)
        player!.seek(to: CMTime.zero)
        //btnPlaySound.setTitle("play", for: .normal)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startScroll"), object: nil)
    }
    
}
