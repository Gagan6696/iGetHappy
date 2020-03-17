//
//  ChooseCareRecieverVC.swift
//  IGetHappy
//
//  Created by Gagan on 10/23/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//gagan new
import UIKit
protocol ChooseCareRecieverViewDelegate:class {
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
    
}
class ChooseCareRecieverVC: BaseUIViewController {

    @IBOutlet weak var tableView: UITableView!
    var presenter:ChooseCareRecieverPresenter?
    var selectedIndex = Int()
    var CareRecieverData:ChooseCareRecieverMapper?
    var delegateRefrence:AddActivityWithMoodVC?
    static var  trackingFor = String()
    static var  trackingForImage = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = ChooseCareRecieverPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        getCareRecieverList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegateRefrence?.setTrackingDetails()
    }
    
    
    @IBAction func actnAddCareReceiver(_ sender: Any) {
       dismiss(animated: true, completion: nil)
        delegateRefrence?.PopToController()
        //  CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .AddCareReciever, Data: nil)
    }
    private func getCareRecieverList(){
        if self.checkInternetConnection(){
            self.presenter?.GetAllListCareReciever()
            //CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Home, Data: nil)
        }else{
        
            self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
        }
    }

    @IBAction func dropdown(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ChooseCareRecieverVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CareRecieverData?.data?.count ?? 1 > 0{
            self.tableView.backgroundView = nil
            
            let careRcvrCount = CareRecieverData?.data?.count ?? 0
            
            return careRcvrCount + 1
            
             //return CareRecieverData?.data?.count ?? 0
        }else{
            self.tableView.setEmptyMessage("No Care-Receiver was found")
            return 1
        }
  
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ChooseCareRecieverCell", for: indexPath) as! ChooseCareRecieverCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.imgView.roundCorners(.allCorners, radius: cell.imgView.frame.width/2)
        if(indexPath.row == 0){
            cell.lblProfileName.text = UserDefaults.standard.getFirstName()
            cell.lblRelationShip.text = "Me"
            ChooseCareRecieverVC.trackingFor = ""
            ChooseCareRecieverVC.trackingForImage = UserDefaults.standard.getProfileImage() ?? ""
            let url = URL(string:  UserDefaults.standard.getProfileImage() ?? "")
            cell.imgView?.kf.indicatorType = .activity
            cell.imgView?.kf.setImage(
                with: url,
                placeholder: UIImage(named: "community_listing_user"),
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            
            //cell.imageView?.kf.setImage(with:URL.init(string: UserDefaults.standard.getProfileImage()!) )
            if(selectedIndex == indexPath.row){
                cell.btnSelectCareReciever.setImage(UIImage.init(named: "ActivityChecked"), for: .normal)
            }else{
                cell.btnSelectCareReciever.setImage(UIImage.init(named: "ChatBotUncheck"), for: .normal)
            }
            
            
            //cell.imgView.image = UserDefaults.standard.getProfileImage()
            EditMoodActivityData.sharedInstance?.careReceiverId = ""
        }else{
            cell.lblProfileName.text = CareRecieverData?.data?[indexPath.row - 1].first_name
            cell.lblRelationShip.text = CareRecieverData?.data?[indexPath.row - 1].relationship
            
           let profile_image  =  CareRecieverData?.data?[indexPath.row - 1].profile_image
            if (profile_image != nil){
                let url = URL(string:  profile_image ?? "")
                cell.imgView?.kf.indicatorType = .activity
                cell.imgView?.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "community_listing_user"),
                    options: [
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ])
            }

            if(selectedIndex == indexPath.row){
                cell.btnSelectCareReciever.setImage(UIImage.init(named: "ActivityChecked"), for: .normal)
                EditMoodActivityData.sharedInstance?.careReceiverId = CareRecieverData?.data?[indexPath.row - 1]._id
                ChooseCareRecieverVC.trackingFor = CareRecieverData?.data?[indexPath.row - 1].first_name ?? ""
                ChooseCareRecieverVC.trackingForImage = CareRecieverData?.data?[indexPath.row - 1].profile_image ?? ""
                
            }else{
                //cell.btnSelectCareReciever.imageView?.image = nil
                cell.btnSelectCareReciever.setImage(UIImage.init(named: "ChatBotUncheck"), for: .normal)
                //cell.btnSelectCareReciever.setImage(UIImage.init(named: "ActivityCheck"), for: .normal)
            }
        }
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.tableView.reloadData()
    }
    
}
extension ChooseCareRecieverVC:ChooseCareRecieverDelegate{
    func ChooseCareRecieverDidSucceeed(data: ChooseCareRecieverMapper?) {
        hideLoader()
        CareRecieverData = data
        print(UserDefaults.standard.getUserId())
        print("data CareRecieverData ",CareRecieverData)
        self.tableView.reloadData()
    }
 
    func ChooseCareRecieverDidFailed(message:String?) {
        hideLoader()
        self.showAlert(Message: message ?? "")
    }
}

extension ChooseCareRecieverVC:ChooseCareRecieverViewDelegate{
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
