//
//  ChatBotVC.swift
//  IGetHappy
//
//  Created by Harpreet Singh on 7/23/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

protocol ChatBotViewDelegate:class {
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
}
class ChatBotVC: BaseUIViewController {
    var presenter:ChatBotPresenter?
    let bgView = UIView()
    var currentIndex = Int()
    var selectedUserName = String()
    @IBOutlet weak var tableViewCareRecievers: UITableView!
    var CareRecieverData:ChooseCareRecieverMapper?
    @IBOutlet var careReciversView: UIView!
    @IBOutlet weak var txtMessgaeBox: UITextField!
    @IBOutlet weak var lblNavBar: UILabel!
    @IBOutlet weak var lblChat: CustomUILabel!
    var passSelectedUsernameForChat = "Me"
    var name:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.presenter = ChatBotPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        getCareRecieverList()
        self.tableViewCareRecievers.separatorStyle = UITableViewCell.SeparatorStyle.none

        if selectedUserName != ""{
            name = selectedUserName
        }else{
            if let Name = UserDefaults.standard.getFirstName(){
                name = Name
            }else{
                name = "User"
            }
        }
        
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        bgView.addGestureRecognizer(tap)
        let myString = "Hi " + name! + " Welcome to I Get Happy"
        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.black]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        
        let myString2 = "Let's chat, " + name!
        let myAttribute2 = [ NSAttributedString.Key.foregroundColor: UIColor.white]
        let myAttrString2 = NSAttributedString(string: myString2, attributes: myAttribute2)
        
        // set attributed text on a UILabel
        lblNavBar.attributedText = myAttrString2
        
//        let myString1 = "Hi" + name! + "Welcome to I Get Happy"
//        let myAttribute1 = [ NSAttributedString.Key.foregroundColor: UIColor.black]
//        let myAttrString1 = NSAttributedString(string: myString, attributes: myAttribute)
        // set attributed text on a UILabel
        lblChat.attributedText = myAttrString
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil)
    {
        // handling code
        self.bgView.removeFromSuperview()
        self.careReciversView.removeFromSuperview()
    }
    
    private func initializeFrame(){
        careReciversView.layer.cornerRadius  = 12
        bgView.alpha = 0.5
        bgView.backgroundColor = .black
        //bgView.layer.cornerRadius = 15
        bgView.frame = self.view.frame
        self.view.addSubview(bgView)
        careReciversView.frame = CGRect.init(view.frame.size.width  / 2, view.frame.size.height / 2, view.frame.size.width - 20, view.frame.size.height / 2)
      // careReciversView.frame = CGSize.init(view.frame.size.width - 20, view.frame.size.height / 2)
        
        careReciversView.center = CGPoint(x: view.frame.size.width  / 2,
                                     y: view.frame.size.height / 2)
        self.view.addSubview(careReciversView)
    }
    private func getCareRecieverList(){
        if self.checkInternetConnection(){
            self.presenter?.GetAllListCareReciever()
            //CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Home, Data: nil)
        }else{
            self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
        }
    }
    
    @IBAction func showPopupCareRecivers(_ sender: Any) {
      //  dismissKeyboardBeforeAction()
       // initializeFrame()
    }
    
    @IBAction func startChat(_ sender: Any) {
         dismissKeyboardBeforeAction()
        self.bgView.removeFromSuperview()
        self.careReciversView.removeFromSuperview()
    }
    
    @IBAction func doChat(_ sender: Any) {
         dismissKeyboardBeforeAction()
        let story = UIStoryboard.init(name: "Auth", bundle: nil)
        let controller = story.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        passSelectedUsernameForChat = name ?? "Me"
        controller.careRecieverName = passSelectedUsernameForChat
        self.navigationController?.pushViewController(controller, animated: false)
 
      //  self.performSegue(withIdentifier identifier: "ChatBotToChat",
                          //sender: self)
       // self.view.makeToast(Constants.Global.MessagesStrings.ComingSoon)
    }
    
    @IBAction func Skip(_ sender: Any) {
         dismissKeyboardBeforeAction()
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Home, Data: nil)
    }
    
    @IBAction func Send(_ sender: Any) {
         dismissKeyboardBeforeAction()
        self.view.makeToast(Constants.Global.MessagesStrings.ComingSoon)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let ss = segue.destination as? ChatVC{
//        ss.careRecieverName = passSelectedUsernameForChat
//            print(ss.careRecieverName)
//        }
    }
}
extension ChatBotVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      
        
        
        if CareRecieverData?.data?.count ?? 1 > 0{
            self.tableViewCareRecievers.backgroundView = nil
            
            let careRcvrCount = CareRecieverData?.data?.count ?? 0
            
            return careRcvrCount + 1
            
            //return CareRecieverData?.data?.count ?? 0
        }else{
            self.tableViewCareRecievers.setEmptyMessage("No careReciever found")
            return 0
        }
        
        
        //return CareRecieverData?.data?.count ?? 0
    }
    
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewCareRecievers.dequeueReusableCell(withIdentifier: ChatBotCareReciversCell.className, for: indexPath) as! ChatBotCareReciversCell
        
        //        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        //        if(currentIndex == indexPath.row){
        //            cell.btnSelectCareReciever.setImage(UIImage.init(named: "ActivityChecked"), for: .normal)
        //        }else{
        //            cell.btnSelectCareReciever.setImage(UIImage.init(named: "ChatBotUncheck"), for: .normal)
        //
        //        }
        //        cell.lblCareRecieverName.text  = CareRecieverData?.data?[indexPath.row].first_name
        //        return cell
        
        
        
        if(indexPath.row == 0){
            //cell.lblCareRecieverName.text = UserDefaults.standard.getFirstName()
            // selectedCareReciever = ""
            if(currentIndex == indexPath.row){
                cell.btnSelectCareReciever.setImage(UIImage.init(named: "ActivityChecked"), for: .normal)
                cell.lblCareRecieverName.text  = "Me"
                passSelectedUsernameForChat = "Me"
                //cell.btnSelectCareReciever.setImage.setImage(UIImage.init(named: "ActivityChecked"), for: .normal)
            }else{
                cell.btnSelectCareReciever.setImage(UIImage.init(named: "ChatBotUncheck"), for: .normal)
                cell.lblCareRecieverName.text  = "Me"
                passSelectedUsernameForChat = "Me"
                //cell.btnSelectCareReciever.setImage.setImage(UIImage.init(named: "ChatBotUncheck"), for: .normal)
            }
            
        }else{
            cell.lblCareRecieverName.text = CareRecieverData?.data?[indexPath.row - 1].first_name
            // selectedCareReciever = CareRecieverData?.data?[indexPath.row - 1].first_name ?? ""
            if(currentIndex == indexPath.row){
                passSelectedUsernameForChat = CareRecieverData?.data?[indexPath.row].first_name ?? ""
                cell.btnSelectCareReciever.setImage(UIImage.init(named: "ActivityChecked"), for: .normal)
                // cell.btnSelectedUser.setImage(UIImage.init(named: "ActivityChecked"), for: .normal)
                
            }else{
                //cell.btnSelectCareReciever.imageView?.image = nil
                cell.btnSelectCareReciever.setImage(UIImage.init(named: "ChatBotUncheck"), for: .normal)
                // cell.btnSelectedUser.setImage(UIImage.init(named: "ChatBotUncheck"), for: .normal)
                //cell.btnSelectCareReciever.setImage(UIImage.init(named: "ActivityCheck"), for: .normal)
            }
        }
        
        return cell
        
    }
    
}
extension ChatBotVC:ChatBotDelegate{
    func ChatBotDidSucceeed(data: ChooseCareRecieverMapper?) {
        CareRecieverData = data
        print(UserDefaults.standard.getUserId())
        print("data CareRecieverData ",CareRecieverData)
        self.tableViewCareRecievers.reloadData()
    }
    
    func ChatBotDidFailed(message:String?) {
        self.showAlert(Message: message ?? "")
    }
}

extension ChatBotVC:ChatBotViewDelegate{
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
