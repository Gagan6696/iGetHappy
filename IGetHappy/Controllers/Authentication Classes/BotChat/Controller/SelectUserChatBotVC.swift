//
//  SelectUserChatBotVC.swift
//  IGetHappy
//
//  Created by Gagan on 11/1/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class SelectUserChatBotVC: BaseUIViewController {
    var presenter:ChatBotPresenter?
    var CareRecieverData:ChooseCareRecieverMapper?
    var selectedIndex = Int()
    var selectedCareReciever:String = "Me"
    @IBOutlet weak var tableViewCareRecivers: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = ChatBotPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        getCareRecieverList()
       
    }
    private func getCareRecieverList(){
        if self.checkInternetConnection(){
            self.presenter?.GetAllListCareReciever()
            //CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Home, Data: nil)
        }else{
            self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
        }
    }
    @IBAction func actionContinue(_ sender: Any) {
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .ChatBot, Data: selectedCareReciever)
    }
    
    @IBAction func actionSkip(_ sender: Any) {
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Home, Data: nil)
       // CareRecieverData?.data?.append(ChooseCareRecieverDetail)
    }
    
}
extension SelectUserChatBotVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if CareRecieverData?.data?.count ?? 0 > 0{
//            self.tableViewCareRecivers.backgroundView = nil
//            return CareRecieverData?.data?.count ?? 0
//        }else{
//            self.tableViewCareRecivers.setEmptyMessage("No careReciever found")
//            return 0
//        }
//
        
        
        if CareRecieverData?.data?.count ?? 1 > 0{
            self.tableViewCareRecivers.backgroundView = nil
            
            let careRcvrCount = CareRecieverData?.data?.count ?? 0
            
            return careRcvrCount + 1
            
            //return CareRecieverData?.data?.count ?? 0
        }else{
            self.tableViewCareRecivers.setEmptyMessage("No careReciever found")
            return 0
        }
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewCareRecivers.dequeueReusableCell(withIdentifier: SelectUserChatbotCell.className, for: indexPath) as! SelectUserChatbotCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        
        if(indexPath.row == 0){
            cell.lblCareRecieverName.text = "Me"
            selectedCareReciever = "Me"
            if(selectedIndex == indexPath.row){
                cell.btnSelectedUser.setImage(UIImage.init(named: "ChatBotCheck"), for: .normal)
            }else{
                cell.btnSelectedUser.setImage(UIImage.init(named: "ChatBotUncheck"), for: .normal)
            }
            
        }else{
            cell.lblCareRecieverName.text = CareRecieverData?.data?[indexPath.row - 1].first_name
            selectedCareReciever = CareRecieverData?.data?[indexPath.row - 1].first_name ?? ""
            if(selectedIndex == indexPath.row){
                cell.btnSelectedUser.setImage(UIImage.init(named: "ChatBotCheck"), for: .normal)
                
            }else{
                //cell.btnSelectCareReciever.imageView?.image = nil
                cell.btnSelectedUser.setImage(UIImage.init(named: "ChatBotUncheck"), for: .normal)
                //cell.btnSelectCareReciever.setImage(UIImage.init(named: "ActivityCheck"), for: .normal)
            }
        }
        
        
        
//        if(indexPath.row == 0){
//            //cell.lblCareRecieverName.text = UserDefaults.standard.getFirstName()
//            // selectedCareReciever = ""
//            if(selectedIndex == indexPath.row){
//                cell.btnSelectedUser.setImage(UIImage.init(named: "ActivityChecked"), for: .normal)
//                cell.lblCareRecieverName.text  = "Me"
//                passSelectedUsernameForChat = "Me"
//                //cell.btnSelectCareReciever.setImage.setImage(UIImage.init(named: "ActivityChecked"), for: .normal)
//            }else{
//                cell.btnSelectCareReciever.setImage(UIImage.init(named: "ChatBotUncheck"), for: .normal)
//                cell.lblCareRecieverName.text  = "Me"
//                passSelectedUsernameForChat = "Me"
//                //cell.btnSelectCareReciever.setImage.setImage(UIImage.init(named: "ChatBotUncheck"), for: .normal)
//            }
//
//        }else{
//            cell.lblCareRecieverName.text = CareRecieverData?.data?[indexPath.row - 1].first_name
//            // selectedCareReciever = CareRecieverData?.data?[indexPath.row - 1].first_name ?? ""
//            if(currentIndex == indexPath.row){
//                passSelectedUsernameForChat = CareRecieverData?.data?[indexPath.row].first_name ?? ""
//                cell.btnSelectCareReciever.setImage(UIImage.init(named: "ActivityChecked"), for: .normal)
//                // cell.btnSelectedUser.setImage(UIImage.init(named: "ActivityChecked"), for: .normal)
//
//            }else{
//                //cell.btnSelectCareReciever.imageView?.image = nil
//                cell.btnSelectCareReciever.setImage(UIImage.init(named: "ChatBotUncheck"), for: .normal)
//                // cell.btnSelectedUser.setImage(UIImage.init(named: "ChatBotUncheck"), for: .normal)
//                //cell.btnSelectCareReciever.setImage(UIImage.init(named: "ActivityCheck"), for: .normal)
//            }
//
//
//
//
        
//        if  indexPath.row == 0{
//
//
//
//
//
//        }else{
//            if(selectedIndex == indexPath.row){
//                selectedCareReciever = CareRecieverData?.data?[indexPath.row].first_name ?? ""
//                cell.btnSelectedUser.setImage(UIImage.init(named: "ActivityChecked"), for: .normal)
//
//
//            }else{
//                cell.btnSelectedUser.setImage(UIImage.init(named: "ChatBotUncheck"), for: .normal)
//                //cell.btnSelectedUser.setImage(UIImage.init(named: "ChatBotUncheck"), for: .normal)
//            }
//        }

      //  cell.lblCareRecieverName.text  = CareRecieverData?.data?[indexPath.row].first_name
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.tableViewCareRecivers.reloadData()
    }
    
}
extension SelectUserChatBotVC:ChatBotDelegate{
    func ChatBotDidSucceeed(data: ChooseCareRecieverMapper?) {
        CareRecieverData = data
        print(UserDefaults.standard.getUserId())
        print("data CareRecieverData ",CareRecieverData)
        self.tableViewCareRecivers.reloadData()
    }
    
    func ChatBotDidFailed(message:String?) {
        self.showAlert(Message: message ?? "")
    }
}

extension SelectUserChatBotVC:ChatBotViewDelegate{
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
