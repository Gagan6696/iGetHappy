//
//  MoodLogMusicCell.swift
//  IGetHappy
//
//  Created by Gagan on 12/10/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import AVFoundation
class MoodLogMusicCell: UITableViewCell {
    
    @IBOutlet weak var view_Player: CustomUIView!
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var imgViewCuurentMood: UIImageView!
    @IBOutlet weak var lblMoodDetailDesc: UILabel!
    @IBOutlet weak var lblMoodDesc: UILabel!
    @IBOutlet weak var imgViewPrivacyIcon: UIImageView!
    @IBOutlet weak var lblMoodpostDate: UILabel!
    @IBOutlet weak var lblPrivacy: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    var urlSong:String?
    var audioPlayer = AVPlayer()
    let stopAudioObserver = NotificationCenter.default
    var selectedIndex = Int()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stopAudioObserver.addObserver(self, selector: #selector(self.stopMusic), name: Notification.Name("StopMusic"), object: nil)
        self.view_Player.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupAudioContent()
    {
        guard let url = URL(string: urlSong ?? "")
            else { return }
        
        print(url)
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(didEndPlayback),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object:nil)
        audioPlayer = AVPlayer(url: url as URL)
        audioPlayer.play()
    }
    
    @objc func stopMusic()
    {
        
        btnPlay.isSelected = false
        self.audioPlayer.pause()
    }
    
    @objc func didEndPlayback(note: NSNotification)
    {
        btnPlay.isSelected = false
    }
    
    //MARK:- Button Actions
    @IBAction func audioPlayPauseButtonAction(_ sender: UIButton)
    {
        
        if(selectedIndex == sender.tag){
            sender.isSelected = !sender.isSelected
            if sender.isSelected
            {
                setupAudioContent()
            }
            else
            {
               
                audioPlayer.pause()
            }
        }else{
            selectedIndex = sender.tag
            stopMusic()
            
        }
       
    }

}
