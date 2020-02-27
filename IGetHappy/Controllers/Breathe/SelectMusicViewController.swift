//
//  SelectMusicViewController.swift
//  IGetHappy
//
//  Created by Prabhjot Singh on 05/11/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import MediaPlayer
protocol SendDataFromSelectMusic:class{
    func sendMusicData(musicName:String?,isFromLibrary:Bool)
}
class SelectMusicViewController: BaseUIViewController {
    let arrMusic = ["file_example_MP3_5MG"]
    @IBOutlet var selectMusicTableView: UITableView!
    var myMediaPlayer = MPMusicPlayerController.systemMusicPlayer
    var currentIndex:Int?
    var delegate : BreatheInhaleExhaleViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func openPhoneMusicListButtonAction(_ sender: Any) {
        checkForMusicLibraryAccess {
        let mediaPicker = MPMediaPickerController(mediaTypes: .music)
        mediaPicker.delegate = self
        mediaPicker.allowsPickingMultipleItems = false
        self.present(mediaPicker, animated: true, completion: {})
        }
        
    }
   
}

extension SelectMusicViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
      return arrMusic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = self.selectMusicTableView.dequeueReusableCell(withIdentifier: SelectMusicTableViewCell.className, for: indexPath) as! SelectMusicTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.musicNameLabel.text = arrMusic[indexPath.row]
        
        if(currentIndex == indexPath.row){
            cell.musicSelectionButton.setImage(UIImage.init(named: "music_selected"), for: .normal)
        }else{
            cell.musicSelectionButton.setImage(UIImage.init(named: "music_normal"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        currentIndex = indexPath.row
        self.selectMusicTableView.reloadData()
        self.dismiss(animated: true) {
            self.delegate?.sendMusicData(musicName: self.arrMusic[indexPath.row], isFromLibrary: false)
        }
     
    }
    
    
}

//Let other classes know ViewController is a MPMediaPickerControllerDelegate
extension SelectMusicViewController: MPMediaPickerControllerDelegate {
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
//self.view.showBlurLoader()
            DispatchQueue.main.async {
                self.ShowLoaderCommon()
            }
            
            for tempItem in mediaItemCollection.items {
                
                var dict = [String:Any]()
                let item: MPMediaItem = tempItem
                let pathURL: URL? = item.value(forProperty: MPMediaItemPropertyAssetURL) as? URL
                if pathURL == nil {
                    print("Picking Error")
                    return
                }
                let songAsset = AVURLAsset(url: pathURL!, options: nil)
                let tracks = songAsset.tracks(withMediaType: .audio)
                if(tracks.count > 0){
                    let track = tracks[0]
                    if(track.formatDescriptions.count > 0){
                        let desc = track.formatDescriptions[0]
                        let audioDesc = CMAudioFormatDescriptionGetStreamBasicDescription(desc as! CMAudioFormatDescription)
                        let formatID = audioDesc?.pointee.mFormatID
                        
                        var fileType:NSString?
                        var ex:String?
                        
                        switch formatID {
                        case kAudioFormatLinearPCM:
                            print("wav or aif")
                            let flags = audioDesc?.pointee.mFormatFlags
                            if( (flags != nil) && flags == kAudioFormatFlagIsBigEndian ){
                                fileType = "public.aiff-audio"
                                ex = "aif"
                            }else{
                                fileType = "com.microsoft.waveform-audio"
                                ex = "wav"
                            }
                            
                        case kAudioFormatMPEGLayer3:
                            print("mp3")
                            fileType = "com.apple.quicktime-movie"
                            ex = "mp3"
                            break;
                            
                        case kAudioFormatMPEG4AAC:
                            print("m4a")
                            fileType = "com.apple.m4a-audio"
                            ex = "m4a"
                            break;
                            
                        case kAudioFormatAppleLossless:
                            print("m4a")
                            fileType = "com.apple.m4a-audio"
                            ex = "m4a"
                            break;
                            
                        default:
                            break;
                        }
                        let exportSession = AVAssetExportSession(asset: AVAsset(url: pathURL!), presetName: AVAssetExportPresetAppleM4A)
                        exportSession?.shouldOptimizeForNetworkUse = true
                        print(exportSession)
                        exportSession?.outputFileType = AVFileType.m4a ;
                        var fileName = item.value(forProperty: MPMediaItemPropertyTitle) as? String ?? ""
                        var fileNameArr = NSArray()
                        fileNameArr = fileName.components(separatedBy: " ") as NSArray
                        fileName = fileNameArr.componentsJoined(by: "")
                        fileName = fileName.replacingOccurrences(of: ".", with: "")
                        fileName = fileName.replacingOccurrences(of: ")", with: "")
                        fileName = fileName.replacingOccurrences(of: "(", with: "")
                        
                        print("fileName -> \(fileName)")
                        let outputURL = documentURL().appendingPathComponent("\(fileName).m4a")
                        print("OutURL->\(outputURL)")
                       
                        print("fileSizeString->\(item.fileSizeString)")
                        print("fileSize->\(item.fileSize)")//
                        do {
                            try FileManager.default.removeItem(at: outputURL)
                        } catch let error as NSError {
                            print(error.debugDescription)
                        }
                        exportSession?.outputURL = outputURL
                        exportSession?.exportAsynchronously(completionHandler: { () -> Void in
                            
                            if exportSession!.status == AVAssetExportSession.Status.completed  {
                                
                                print("Export Successfull")
                                print("outputURL => \(outputURL)")
                                DispatchQueue.main.async {
                                    self.HideLoaderCommon()
                                    self.dismiss(animated: true) {
                                         self.delegate?.sendMusicData(musicName: "\(fileName)", isFromLibrary: true)
                                    }

                                }
                                
                            } else {
                                
                                print("Export failed")
                                print(exportSession!.error as Any)
                            }
                        })
                    }
                }
                
                
            }
            
            mediaPicker.dismiss(animated:false)
     
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
    //func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        print("User selected Cancel tell me what to do")
        mediaPicker.dismiss(animated: true, completion:nil)
    }

}
