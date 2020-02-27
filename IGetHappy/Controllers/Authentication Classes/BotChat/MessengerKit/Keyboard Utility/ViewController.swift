//
//  ViewController.swift
//  DemoMessengerKit
//
//  Created by Gurleen Osahan on 2/11/20.
//  Copyright © 2020 Gurleen Osahan. All rights reserved.
//

import UIKit
import Foundation


class ViewController: MSGMessengerViewController {
    
    @IBOutlet var viewRed: UIView!
  
 
    let channels = ["ChanneA"]
   
    var msgs = [[String:Any]]()
  
    var i = 15
    var newMsgsCount = 0
    var scrollEnd = false
    var imagePicker = UIImagePickerController()
    var imageURL:URL?
 
    var senderName:String?
    var reciverName:String?
    var senderId:Int?
    var recieverId:Int?
    var channelName:String?
    var userProfileUrl:String?
    let dispatchGroup = DispatchGroup()
    
    var thumbURL:URL?
    var videoURL:URL?
    
    
    
    
    

    var id = 100
    
    override var style: MSGMessengerStyle {
        var style = MessengerKit.Styles.iMessage
        style.headerHeight = 0
        //        style.inputPlaceholder = "Message"
        style.alwaysDisplayTails = false
        style.outgoingBubbleColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
        style.outgoingTextColor = .white
        style.incomingBubbleColor = .white
        style.incomingTextColor = .black
        //        style.backgroundColor = .orange
        //        style.inputViewBackgroundColor = .purple
        return style
    }
    
    
    lazy var messages = [[MSGMessage]]()
    //  = {
    //            return [
    //                [
    //                    MSGMessage(id: 1, body: .emoji("🐙💦🔫"), user: tim, sentAt: Date()),
    //                ],
    //                [
    //                    MSGMessage(id: 2, body: .text("Yeah sure, gimme 5"), user: steve, sentAt: Date()),
    //                    MSGMessage(id: 3, body: .text("Okay ready when you are"), user: steve, sentAt: Date())
    //                ],
    //                [
    //                    MSGMessage(id: 4, body: .text("Awesome 😁"), user: tim, sentAt: Date()),
    //                ],
    //                [
    //                    MSGMessage(id: 5, body: .text("Ugh, gotta sit through these two…"), user: steve, sentAt: Date()),
    //                    MSGMessage(id: 6, body: .image(AppImages.NoPostsImage), user: steve, sentAt: Date()),
    //                ],
    //                [
    //                    MSGMessage(id: 7, body: .text("Every. Single. Time."), user: tim, sentAt: Date()),
    //                ],
    //                [
    //                    MSGMessage(id: 8, body: .emoji("🙄😭"), user: steve, sentAt: Date()),
    //                    MSGMessage(id: 9, body: .imageFromUrl(URL(string: "https://placeimg.com/640/480/any")!), user: steve, sentAt: Date()
    //                       // MSGMessage(id: 7, body: .custom(<#T##Any#>)
    //                    )
    //                ]
    //            ]
    //        }()
    
    func getCurrentTimeZone() -> String {
        let localTimeZoneAbbreviation: Int = TimeZone.current.secondsFromGMT()
        let items = (localTimeZoneAbbreviation / 3600)
        return "\(items)"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var timeZone : String = String()
        
        
        super.viewDidLoad()
        timeZone = getCurrentTimeZone()
        print(timeZone)
        SetUI()
    }
    
    func SetUI()
    {
        
      //  self.viewModel = ChatVCModel.init(Delegate: self, view: self)
        senderName = "gurlreen"
        senderId = 5
        recieverId = 1
//        if(senderId! > recieverId)
//        {
            channelName = "\(5)" + "Channel" + "\(1)"
//        }
//        else
//        {
//            channelName = "\(recieverId!)" + "Channel" + "\(senderId!)"
//        }
       // ChatSetup()
    }
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    
    func getDate(dateStr:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: dateStr) // replace Date String
    }
    
    func getString(date:Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.scrollToBottom(animated: false)
    }
    
//     override func inputViewPrimaryActionTriggered(inputView: MSGInputView) {
//         id += 1
//
//        let body: MSGMessageBody = (inputView.message.com && inputView.message.count < 5) ? .emoji(inputView.message) : .text(inputView.message)
//
//         let message = MSGMessage(id: id, body: body, user: steve, sentAt: Date())
//         insert(message)
//     }
      override func insert(_ message: MSGMessage) {
                 
                 collectionView.performBatchUpdates({
     //                if let lastSection = self.messages.last, let lastMessage = lastSection.last, lastMessage.user.displayName == message.user.displayName {
     //                    self.messages[self.messages.count - 1].append(message)
     //
     //                    let sectionIndex = self.messages.count - 1
     //                    let itemIndex = self.messages[sectionIndex].count - 1
     //                    self.collectionView.insertItems(at: [IndexPath(item: itemIndex, section: sectionIndex)])
     //
     //                } else {
                         self.messages.append([message])
                         let sectionIndex = self.messages.count - 1
                         self.collectionView.insertSections([sectionIndex])
                     //  }
                 }, completion: { (_) in
                     self.collectionView.scrollToBottom(animated: true)
                     self.collectionView.layoutTypingLabelIfNeeded()
                 })
                 
             }
             
      override func inputViewPrimaryActionTriggered(inputView: MSGInputView) {
    
            
//        let tim = userDetails(displayName: "senderName", avatar: nil, avatarUrl: URL(string:"ss"), isSender: true)
//        let obj1 = MSGMessage(id: 7, body: .text(inputView.message), user: tim, sentAt: Date())
//        self.insert(obj1)
//
//            let obj =  ChatData(senderId: senderId, recieverId: recieverId, senderName: senderName, recieverName: reciverName,imageUrl:nil ,videoUrl:nil,text: inputView.message,senderProfileUrl:UserDefault.profileImageUrl ,time:getString(date: Date()), thumbUrl:nil )
//                    self.pubnub.publish(channel: channelName!, message:obj ,shouldStore: true) { result in
//                                  switch result {
//                                  case let .success(response):
                                    print("Handle successful Publish response")
//                                  case let .failure(error):
//                                    print("Handle response error: \(error.localizedDescription)")
//                                  }
      //     }
        }
     
    
}

// extension ViewController: MSGDelegate {
//
//     func linkTapped(url: URL) {
//         print("Link tapped:", url)
//     }
//
//     internal func avatarTapped(for user: MSGUser) {
//         print("Avatar tapped:", user)
//     }
//
//     func tapReceived(for message: MSGMessage) {
//         print("Tapped: ", message.body)
//
//         switch  message.body {
//         case .imageFromUrl(let imgUrl):
//            print(imgUrl)
////        let images = [
////              LightboxImage(imageURL: imgUrl)
//            //,
////              LightboxImage(
////                image: UIImage(named: "photo1")!,
////                text: "This is an example of a remote image loaded from URL"
////              ),
////              LightboxImage(
////                image: UIImage(named: "photo2")!,
////                text: "",
////                videoURL: URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
////              ),
////              LightboxImage(
////                image: UIImage(named: "photo3")!,
////                text: "This is an example of a local image."
////              )
//            //]
//
//            // Create an instance of LightboxController.
////            let controller = LightboxController(images: images)
////
////            // Set delegates.
////            controller.pageDelegate = self
////            controller.dismissalDelegate = self
////
////            // Use dynamic background.
////            controller.dynamicBackground = false
////          controller.modalPresentationStyle = .fullScreen
////
////            // Present your controller.
////            present(controller, animated: true, completion: nil)
////
//          //  let imageView = UIImageView()
//            //imageView.setupImageViewer(url: URL(string: "http://203.100.79.168:8083/GoodsDelivery/105/profileImage/Image_105_1578317953916.png")!)
////             playVideo(url: URL(string: "https://s3.amazonaws.com/archive.wesellrestaurants/community-posts-1565176749657.mp4")!)
//          //   print(imgUrl)
//         case .video(_,let videoUrl):
//          //  playVideo(url: videoUrl)
//             print(videoUrl)
//         default:
//             print("Blank")
//         }
//
//
//
//     }
////    func playVideo(url: URL) {
////            let player = AVPlayer(url: url)
////
////            let vc = AVPlayerViewController()
////            vc.player = player
////
////            self.present(vc, animated: true) { vc.player?.play() }
////        }
//
//     func longPressReceieved(for message: MSGMessage) {
//         print("Long press:", message)
//     }
//
//     func shouldDisplaySafari(for url: URL) -> Bool {
//         return true
//     }
//
//     func shouldOpen(url: URL) -> Bool {
//         return true
//     }
//
//
//
// }
//extension ViewController: MSGDataSource {
//
//    func numberOfSections() -> Int {
//        return messages.count
//    }
//
//    func numberOfMessages(in section: Int) -> Int {
//        return messages[section].count
//    }
//
//    func message(for indexPath: IndexPath) -> MSGMessage {
//        return messages[indexPath.section][indexPath.item]
//    }
//
//    func footerTitle(for section: Int) -> String? {
//        return timeAgoSinceDate(messages[section].first!.sentAt, currentDate: Date(), numericDates: true)
//    }
//
//    func headerTitle(for section: Int) -> String? {
//        return messages[section].first?.user.displayName
//    }
//
//}
//extension ViewController{
//    func ChatSetup(){
//          self.collectionView.delegate = self
//                  self.collectionView.reloadData()
//                  self.collectionView.layoutIfNeeded()
//        title = "iMessage"
//        dataSource = self
//        delegate = self
//
//        //  GetHistory()
//    }
//}
