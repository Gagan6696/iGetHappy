//
//  CellClass_MyVentsPlayer.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import AVFoundation

class CellClass_MyVentsPlayer: UITableViewCell
{
    
    @IBOutlet weak var btnDropDownAudio: UIButton!
    
    
    @IBOutlet weak var bgViewAudio: CustomUIView!
    @IBOutlet weak var view_Player: CustomUIView!
    @IBOutlet weak var ivUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPrivacyText: UILabel!
    @IBOutlet weak var ivPrivacy: UIImageView!
    @IBOutlet weak var btnPlay: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var txtViewDesc: UILabel!
//    var urlSong:String?
//    var audioPlayer = AVPlayer()
//    var playing = false
//    let stopAudioObserver = NotificationCenter.default
//    var callRefreshTable:RefreshTableFromCell?
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code

        // stopAudioObserver.addObserver(self, selector: #selector(self.StopMusicVents), name: Notification.Name("StopMusicVents"), object: nil)
        self.view_Player.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//   private func setupAudioContent()
//    {
//        NotificationCenter.default.addObserver(self, selector: #selector(itemFailedToPlayToEndTime), name: .AVPlayerItemFailedToPlayToEndTime, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(itemNewErrorLogEntry), name: .AVPlayerItemNewErrorLogEntry, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(itemPlaybackStalled), name: .AVPlayerItemPlaybackStalled, object: nil)
//
//        NotificationCenter.default.addObserver(self,
//                                               selector:#selector(didEndPlayback),
//                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
//                                               object:nil)
//
//        let urlMusicString = urlSong?.trimmingCharacters(in: .whitespacesAndNewlines)
//       // guard let url = URL(string: urlMusicString ?? "") else { return complete(.unvalidURL) }
//        guard let url = URL(string: urlMusicString ?? "")
//            else { return }
//        let isValidUrl = AVAsset(url: url).isPlayable
//        print(url)
//
//        if isValidUrl{
//            audioPlayer = AVPlayer(url: url as URL)
//            print("1st ref when create ",audioPlayer)
//            self.btnPlay.setImage(UIImage.init(named: "community_audio_play"), for: .normal)
//            audioPlayer.play()
//
//        }else{
//            self.view_Player.makeToast("File is corrupted")
//        }
//
//
//    }
    
//    @objc func StopMusicVents()
//    {
//        activityIndicator.stopAnimating()
//        activityIndicator.hide()
//        btnPlay.isSelected = false
//        print("StopMusicVents called")
//        self.btnPlay.setImage(UIImage.init(named: "community_audio_play"), for: .normal)
//        print("ref when stope ",audioPlayer)
//        audioPlayer.pause()
//        Singleton.shared().selectedIndex = -1
//        // PostWithAudioCell.ref_community?.loadTable()
//        callRefreshTable?.refreshTable()
//        playing = false
//        //self.audioPlayer = AVPlayer()
//
//    }
    
//    @objc func didEndPlayback(note: NSNotification)
////    {
////        self.btnPlay.setImage(UIImage.init(named: "community_audio_play"), for: .normal)
////        //btnPlay.isSelected = false
////        print("didEndPlayback called")
////        Singleton.shared().selectedIndex = -1
////          callRefreshTable?.refreshTable()
////        playing = false
////    }
//    @objc func itemFailedToPlayToEndTime(note: NSNotification)
//    {
//        print("itemFailedToPlayToEndTime called")
//        self.btnPlay.setImage(UIImage.init(named: "community_audio_play"), for: .normal)
//        //btnPlay.isSelected = false
//    }
//    @objc func itemNewErrorLogEntry(note: NSNotification)
//    {
//         print("itemNewErrorLogEntry called")
//        self.btnPlay.setImage(UIImage.init(named: "community_audio_play"), for: .normal)
//       //btnPlay.isSelected = false
//    }
//    @objc func itemPlaybackStalled(note: NSNotification)
//    {
//         print("itemPlaybackStalled called")
//        self.btnPlay.setImage(UIImage.init(named: "community_audio_play"), for: .normal)
//        //btnPlay.isSelected = false
//    }
//
//
//    //MARK:- Button Actions
//    @IBAction func audioPlayPauseButtonAction(_ sender: UIButton)
//    {
//        print("audioPlayPauseButtonAction called")
//        if (playing == false)
//        {
//            playing = true
//           NotificationCenter.default.removeObserver(self)
//            setupAudioContent()
//             self.btnPlay.setImage(UIImage.init(named: "community_audio_pause"), for: .normal)
//            Singleton.shared().selectedIndex = sender.tag
//        }
//        else
//        {
//            playing = false
//            audioPlayer.pause()
//            self.btnPlay.setImage(UIImage.init(named: "community_audio_play"), for: .normal)
//            Singleton.shared().selectedIndex = -1
//        }
//        callRefreshTable?.refreshTable()
////        if (selectedIndex == -1){
////            //It means initial stage
////            selectedIndex = sender.tag
////            activityIndicator.startAnimating()
////            setupAudioContent()
////        }else{
////            if(selectedIndex == sender.tag){
////
////                sender.isSelected = !sender.isSelected
////                if sender.isSelected
////                {
////                    activityIndicator.startAnimating()
////                    selectedIndex = sender.tag
////                    setupAudioContent()
////                }
////                else
////                {
////                    activityIndicator.stopAnimating()
////                    activityIndicator.hide()
////                    audioPlayer?.pause()
////                }
////            }else{
////                selectedIndex = sender.tag
////                stopMusic()
////
////            }
////        }
//
//    }
//

}
