//
//  ChatVC.swift
//  IGetHappy
//
//  Created by Gurleen Osahan on 2/12/20.
//  Copyright © 2020 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import Foundation



class ChatVC: MSGMessengerViewController{
    
    //MARK:- Variables
    var presenter:ChatBotPresenter?
    lazy var messages = [[MSGMessage]]()
    var careRecieverName:String = ""
    var boolCaregiver = false
    
    @IBOutlet weak var navitem: UINavigationItem!
    override var style: MSGMessengerStyle {
        let style = MessengerKit.Styles.iMessage
        return style
    }
      //MARK:- View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = ChatBotPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        self.ChatSetup()
        
        //self.navigationController?.setBackgroundImage(UIImage(named:"globalBackground")!)
      
//
    }
    override func viewWillAppear(_ animated: Bool) {
        self.UnHideNavigationBar(navigationController: self.navigationController!)
         var myString2 = "Let's chat, "
        if careRecieverName == "Me" {
            guard let name = UserDefaults.standard.getFirstName() else{ return
            }
          myString2 += name
        }else{
           myString2 += self.careRecieverName
        }
       
//        let myAttribute2 = [ NSAttributedString.Key.foregroundColor: UIColor.white]
//        let myAttrString2 = NSAttributedString(string: myString2, attributes: myAttribute2)
        self.navigationController?.navigationItem.title = myString2
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "globalBackground")?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        self.HideNavigationBar(navigationController: self.navigationController!)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage().resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         collectionView.scrollToBottom(animated: false)
    }
   
    override func insert(_ message: MSGMessage) {
        
        collectionView.performBatchUpdates({
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
        
        let trimmedstr = inputView.message.trim()
        if trimmedstr.isEmpty{
          return
        }
        let tim = userDetails(displayName: UserDefaults.standard.getFirstName() ?? "User" , avatar: #imageLiteral(resourceName: "messageIcon"), avatarUrl: nil, isSender: true)
        let obj1 = MSGMessage(id: 7, body: .text(inputView.message), user: tim, sentAt: Date())
        self.insert(obj1)
        
        let infoData = info.init(user_name: UserDefaults.standard.getFirstName() ?? "User", first_use: false, active_context: [], last_context: [], care_giver: self.boolCaregiver, charge: self.careRecieverName, mobile_command: "", dominant_emotion: "", num_missed_meditation: 0, missed_apt: "", cause: "", emotion: "", normalized: 0, location: "", relationship: "", last_requested: "")
        let chatData = ChatData.init(info: infoData, text: inputView.message)
        
        
        if self.checkInternetConnection(){
            self.presenter?.hitMessageSend(dict:chatData.dictionary , userId: UserDefaults.standard.getUserId() ?? "", completion: { (response) in
                if let message = response.response?.reply{
                    let sender = userDetails(displayName: response.response?.info?.user_name ?? "User", avatar: #imageLiteral(resourceName: "messageIcon"), avatarUrl: nil, isSender: false)
                    let obj1 = MSGMessage(id: 7, body: .text(message), user: sender, sentAt: Date())
                    self.insert(obj1)
                    
                }else{
                    let sender = userDetails(displayName: response.response?.info?.user_name ?? "User", avatar: #imageLiteral(resourceName: "messageIcon"), avatarUrl: nil, isSender: false)
                    let obj1 = MSGMessage(id: 7, body: .text("Chatbot is unable to process"), user: sender, sentAt: Date())
                    self.insert(obj1)
                }
            })
            
        }
        else
        {
            self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
        }
       
        
     
    
    }
    
      //MARK:- Actions
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ActionLetsChat(_ sender: Any) {
    }
    
    @IBAction func ActionSkip(_ sender: Any) {
    CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Home, Data: nil)
      }
}

  //MARK:- MSGDelegate
extension ChatVC: MSGDelegate {
    
    func linkTapped(url: URL) {
        print("Link tapped:", url)
    }
    
    internal func avatarTapped(for user: MSGUser) {
        print("Avatar tapped:", user)
    }
    
    func tapReceived(for message: MSGMessage) {
        print("Tapped: ", message.body)
        
        switch  message.body {
        case .imageFromUrl(let imgUrl):
            print(imgUrl)
            //        let images = [
            //              LightboxImage(imageURL: imgUrl)
            //,
            //              LightboxImage(
            //                image: UIImage(named: "photo1")!,
            //                text: "This is an example of a remote image loaded from URL"
            //              ),
            //              LightboxImage(
            //                image: UIImage(named: "photo2")!,
            //                text: "",
            //                videoURL: URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
            //              ),
            //              LightboxImage(
            //                image: UIImage(named: "photo3")!,
            //                text: "This is an example of a local image."
            //              )
            //]
            
            // Create an instance of LightboxController.
            //            let controller = LightboxController(images: images)
            //
            //            // Set delegates.
            //            controller.pageDelegate = self
            //            controller.dismissalDelegate = self
            //
            //            // Use dynamic background.
            //            controller.dynamicBackground = false
            //          controller.modalPresentationStyle = .fullScreen
            //
            //            // Present your controller.
            //            present(controller, animated: true, completion: nil)
            //
            //  let imageView = UIImageView()
            //imageView.setupImageViewer(url: URL(string: "http://203.100.79.168:8083/GoodsDelivery/105/profileImage/Image_105_1578317953916.png")!)
            //             playVideo(url: URL(string: "https://s3.amazonaws.com/archive.wesellrestaurants/community-posts-1565176749657.mp4")!)
        //   print(imgUrl)
        case .video(_,let videoUrl):
            //  playVideo(url: videoUrl)
            print(videoUrl)
        default:
            print("Blank")
        }
        
        
        
    }
    //    func playVideo(url: URL) {
    //            let player = AVPlayer(url: url)
    //
    //            let vc = AVPlayerViewController()
    //            vc.player = player
    //
    //            self.present(vc, animated: true) { vc.player?.play() }
    //        }
    
    func longPressReceieved(for message: MSGMessage) {
        print("Long press:", message)
    }
    
    func shouldDisplaySafari(for url: URL) -> Bool {
        return true
    }
    
    func shouldOpen(url: URL) -> Bool {
        return true
    }
}
  //MARK:- MSGDelegate
extension ChatVC: MSGDataSource {
    
    func numberOfSections() -> Int {
        return messages.count
    }
    
    func numberOfMessages(in section: Int) -> Int {
        return messages[section].count
    }
    
    func message(for indexPath: IndexPath) -> MSGMessage {
        return messages[indexPath.section][indexPath.item]
    }
    
    func footerTitle(for section: Int) -> String? {
        return ""
        //return timeAgoSinceDate(messages[section].first!.sentAt, currentDate: Date(), numericDates: true)
    }
    
    func headerTitle(for section: Int) -> String? {
        return messages[section].first?.user.displayName
    }
    
}
extension ChatVC{
    func ChatSetup(){
        self.collectionView.delegate = self
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
        title = "Lets Chat"
        dataSource = self
        delegate = self
        
        if self.careRecieverName == "Me"{
           self.boolCaregiver = false
        }else{
          self.boolCaregiver = true
        }
        let infoData = info.init(user_name: UserDefaults.standard.getFirstName() ?? "User", first_use: true, active_context: [], last_context: [], care_giver: self.boolCaregiver, charge: self.careRecieverName, mobile_command: "", dominant_emotion: "", num_missed_meditation: 0, missed_apt: "", cause: "", emotion: "", normalized: 0, location: "", relationship: "", last_requested: "")
        let chatData = ChatDataFirst.init(info: infoData)
        
        if self.checkInternetConnection(){
            self.presenter?.hitMessageSend(dict:chatData.dictionary , userId: UserDefaults.standard.getUserId() ?? "", completion: { (response) in
                
                if let message =  response.response?.reply{
                    let tim = userDetails(displayName: "Steve", avatar: #imageLiteral(resourceName: "messageIcon"), avatarUrl: nil, isSender: false)
                    let obj1 = MSGMessage(id: 7, body: .text(message), user: tim, sentAt: Date())
                    self.insert(obj1)
                    
                }else{
                    let sender = userDetails(displayName: response.response?.info?.user_name ?? "User", avatar: #imageLiteral(resourceName: "messageIcon"), avatarUrl: nil, isSender: false)
                    let obj1 = MSGMessage(id: 7, body: .text("Chatbot is unable to process"), user: sender, sentAt: Date())
                    self.insert(obj1)
                }
            })
        }
        else
        {
            self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
        }
        
     
        
        
        //  GetHistory()
    }
}
extension ChatVC:ChatBotDelegate{
    func ChatBotDidSucceeed(data: ChooseCareRecieverMapper?) {
    }
    
    func ChatBotDidFailed(message:String?) {
         self.showAlert(alertMessage: message ?? "")
    }
}

extension ChatVC:ChatBotViewDelegate{
    func showAlert(alertMessage: String) {
       self.showAlert(Message: alertMessage)
    }
    
    func showLoader() {
        ShowLoaderCommon()
    }
    
    func hideLoader() {
      HideLoaderCommon()
    }
    
    
}
extension UINavigationController {
    func setBackgroundImage(_ image: UIImage) {
        //        navigationBar.isTranslucent = true
        //        navigationBar.barStyle = .blackTranslucent
        //
        let logoImageView = UIImageView(image: image)
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.clipsToBounds = true
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.insertSubview(logoImageView, belowSubview: navigationBar)
        NSLayoutConstraint.activate([
            logoImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            logoImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor)
            ])
}
}
