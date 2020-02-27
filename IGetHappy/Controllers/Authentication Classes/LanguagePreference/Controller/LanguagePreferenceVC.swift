//
//  LanguagePreferenceVC.swift
//  IGetHappy
//
//  Created by Gagan on 5/22/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
protocol LanguagePreferenceViewDelegate:class {
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
}
class LanguagePreferenceVC: BaseUIViewController , UICollectionViewDataSource, UICollectionViewDelegate, MICollectionViewBubbleLayoutDelegate{
    var presenter:LanguagePresenter?
    @IBOutlet var collVData:UICollectionView!
    
    let kItemPadding = 15
    var arrData = [String?]()
    var selctdLanguage = String()
    var arrLanguage = [String]()
    var selectedIndexItem = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collVData.dataSource = self
        collVData.delegate = self
        collVData.allowsMultipleSelection = true
        self.presenter = LanguagePresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        //fetchLanguages()
       // self.hideKeyboardWhenTappedAround()
        let bubbleLayout = MICollectionViewBubbleLayout()
        bubbleLayout.minimumLineSpacing = 30.0
        bubbleLayout.minimumInteritemSpacing = 10.0
        bubbleLayout.delegate = self
        collVData.setCollectionViewLayout(bubbleLayout, animated: false)
    }
    override  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         arrData.removeAll()
         arrLanguage.removeAll()
         selectedIndexItem.removeAll()
        collVData.dataSource = self
        collVData.delegate = self
        collVData.allowsMultipleSelection = true
        fetchLanguages()
        let bubbleLayout = MICollectionViewBubbleLayout()
        bubbleLayout.minimumLineSpacing = 30.0
        bubbleLayout.minimumInteritemSpacing = 10.0
        bubbleLayout.delegate = self
        collVData.setCollectionViewLayout(bubbleLayout, animated: false)
        collVData.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backAction(_ sender: Any) {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    
    private func fetchLanguages(){
        self.showLoader()
        if self.checkInternetConnection(){
            guard let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String else {
                return
            }
            self.presenter?.getLanguages(currentLocale:countryCode)
        }else{
            self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
        }
    }
    @IBAction func Continue(_ sender: Any) {
         dismissKeyboardBeforeAction()
        do {
            try presenter?.Validations(language: arrLanguage)
           
            if self.checkInternetConnection(){
                
                CompleteRegisterData.sharedInstance?.language_preferences = arrLanguage
                CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .BeCaregiver, Data: nil)
            }else{
                self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
               
            }

        } catch let error {
            switch  error {

            case ValidationError.SelectLanguage.selectlang:
              
                 self.view.makeToast(Constants.LanguagePreference.Validations.KSelectLanguage)
                self.hideLoader()
            
            default:
                self.view.makeToast( Constants.Global.MessagesStrings.ServerError)
                self.hideLoader()
            }
        }
        
    }
    
    
    // MARK: -
    // MARK: - UICollectionView Delegate & Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(arrData.count)
        return arrData.count
       
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indentifier = "MIBubbleCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: indentifier, for: indexPath) as! MIBubbleCollectionViewCell
        if let Language  = arrData[indexPath.row] {
            selctdLanguage = Language
            print(selctdLanguage)
        }
        //selctdLanguage = arrData[indexPath.row] as! String
        if(!selectedIndexItem.isEmpty){
            if(selectedIndexItem.contains(indexPath.row)){
                
                
                //let index = selectedIndexItem.firstIndex(of: indexPath.row)
                selectedIndexItem.remove(at: selectedIndexItem.firstIndex(of: indexPath.row)!)
                if(!arrLanguage.isEmpty){
                    for i in 0..<arrLanguage.count{
                        if(arrLanguage[i] == selctdLanguage){
                            arrLanguage.remove(at: i)
                            break
                        }
                    }
                    //arrLanguage.removeLast()
                }
                 self.collVData.reloadData()
            }else{
                 selectedIndexItem.append(indexPath.row)
                arrLanguage.append(selctdLanguage)
            }
        }else{
            //selctdLanguage = (arrData[2] as? String)!
            //let selctdLanguag = arrData[2] as? String
            arrLanguage.append(selctdLanguage ?? "")
            selectedIndexItem.append(indexPath.row)
//            self.view.makeToast("you have to selct atleast one language")
           
        }
        
        print("\(selctdLanguage)")
        
        self.collVData.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let indentifier = "MIBubbleCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: indentifier, for: indexPath) as! MIBubbleCollectionViewCell
        cell.lblTitle.text = arrData[indexPath.row] as? String
        if(!selectedIndexItem.isEmpty){
            if(selectedIndexItem.contains(indexPath.row)){
                 //cell.lblTitle.backgroundColor = .orange
                cell.bgImgView.image = UIImage.init(named: "globalBackground")
                
                
            }else{
                 cell.lblTitle.backgroundColor = .clear
               
                cell.bgImgView.image = UIImage()
            }
        }else{
            cell.lblTitle.backgroundColor = .clear
            cell.bgImgView.image = UIImage()
//            selctdLanguage = (arrData[2] as? String)!
//            let selctdLanguag = arrData[2] as? String
//            arrLanguage.append(selctdLanguag ?? "")
//            selectedIndexItem.append(2)
             //self.view.makeToast("you have to selct atleast one language")
           
        }
        
        return cell
    }
    
    
    // MARK: -
    // MARK: - MICollectionViewBubbleLayoutDelegate
    
    func collectionView(_ collectionView:UICollectionView, itemSizeAt indexPath:NSIndexPath) -> CGSize
    {
        let title = arrData[indexPath.row] as! NSString
        var size = title.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 15)!])
        size.width = CGFloat(ceilf(Float(size.width + CGFloat(kItemPadding * 2))))
        size.height = 24
        
        //...Checking if item width is greater than collection view width then set item width == collection view width.
        if size.width > collectionView.frame.size.width {
            size.width = collectionView.frame.size.width
        }
        
        return size;
    }


}
extension LanguagePreferenceVC:LanguagePreferenceDelegate{
    func LanguagePreferenceDidSucceeed(languagesData: [AllLanguages]?) {
       print(languagesData)
        for i in 0..<languagesData!.count{
            
            arrData.append(languagesData?[i].language_name ?? "")
        }
        
        
        collVData.dataSource = self
        collVData.delegate = self
        collVData.allowsMultipleSelection = true
        //selectedIndexItem.append(2)
        print(arrData)
        //selctdLanguage = (arrData[2] as? String)!
        //let selctdLanguag = arrData[2] as? String
        //arrLanguage.append(selctdLanguag ?? "")
        let bubbleLayout = MICollectionViewBubbleLayout()
        bubbleLayout.minimumLineSpacing = 30.0
        bubbleLayout.minimumInteritemSpacing = 10.0
        bubbleLayout.delegate = self
        collVData.setCollectionViewLayout(bubbleLayout, animated: false)
       
        CompleteRegisterData.sharedInstance?.language_preferences = arrLanguage
       
    }
    
    func LanguagePreferenceDidFailed() {
        
    }
    
    
}
extension LanguagePreferenceVC:LanguagePreferenceViewDelegate{
    func showAlert(alertMessage: String) {
        
    }
    
    func showLoader() {
        ShowLoaderCommon()
    }
    
    func hideLoader() {
        HideLoaderCommon()
    }
    
    
}
