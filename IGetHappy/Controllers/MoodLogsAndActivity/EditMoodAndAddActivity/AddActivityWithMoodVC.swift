//
//  AddActivityWithMoodVC.swift
//  IGetHappy
//
//  Created by Gagan on 10/23/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.



import UIKit
import UPCarouselFlowLayout
protocol UpdateDataForPopUp:class {
    func openPopup()
}
class AddActivityWithMoodVC: BaseUIViewController
{
    
    @IBOutlet weak var imgViewUser: UIImageView!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    //Dont delete this(use for multi selection)
    //var selectedIndex = [Int]()
    var selectedIndex:Int = -1
    @IBOutlet weak var btnAddEmoji: UIButton!
    
    @IBOutlet weak var lblTrackingName: UILabel!
    @IBOutlet weak var lblSelectedMood: UILabel!
    var emojiArray = [CharacterC]()
    let story = UIStoryboard.init(name: Constants.StoryBoard.Identifiers.KAuth, bundle: nil)
    var presenter:AddActivityPresenter?
    var diffrColorTxt = ""
    var Edit_Data : [MoodLogDetails]?
    
    //MARK: SWIPE MOOD CONFIGURATION
    //  fileprivate var items = [CharacterC]()
    fileprivate var currentPage: Int = 0
    {
        didSet
        {
            if (self.currentPage < self.emojiArray.count)
            {
                let character = self.emojiArray[self.currentPage]
                let diffrColorTxt = "\(character.title.capitalizingFirstLetter())"
                self.lblSelectedMood.text = "I'm Feeling \(diffrColorTxt)"
                EditMoodActivityData.sharedInstance?.moodTrack = "\(diffrColorTxt)"
                EditMoodActivityData.sharedInstance?.icon_name = character.description
                self.lblSelectedMood = CommonFunctions.make_text_different_in_label(label: self.lblSelectedMood, textForColor: diffrColorTxt)
                guard case let lblTrackingName.text = ChooseCareRecieverVC.trackingFor as String else {return}
               
                
//                if let name  =  ChooseCareRecieverVC.trackingFor as? String, name != ""{
//                    lblTrackingName.text = name
//                }
                //ChooseCareRecieverVC.trackingFor

                if (Edit_Data?.count ?? 0 == 0)
                {
                    if (checkInternetConnection() == false)
                    {
                        presenter?.update_emoji_offline(imageName: character.imageName, feel: diffrColorTxt, indx: self.currentPage, iconName: character.description)
                    }
                }
            }
        }
    }
    fileprivate var pageSize: CGSize
    {
        let layout = self.myCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal
        {
            pageSize.width += layout.minimumLineSpacing
        }
        else
        {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    var arrayImages: [UIImage] = [
        UIImage(named: "AcitivityChampagne-glass")!,
        UIImage(named: "AcitivityCross")!,
        UIImage(named: "AcitivityCutlery")!,
        UIImage(named: "AcitivityEvent")!,
        UIImage(named: "AcitivityMicrophone")!,
        UIImage(named: "AcitivityWedding-ring")!,
        UIImage(named: "AcitivityWork")!,
        UIImage(named: "AcitivityVector")!
    ]
    
    var dictImages = [["name":"Movie",
                       "image":"Movie"],
                      ["name":"Relax",
                       "image":"Relax"],
                      ["name":"Drinking",
                       "image":"Drinking"],
                      ["name":"Church",
                       "image":"Church"],
                      ["name":"Wedding",
                       "image":"Wedding"],
                      ["name":"Event",
                       "image":"Event"],
                      ["name":"Christmas Party",
                       "image":"Christmas Party"],
                      ["name":"Work",
                       "image":"Work"],
                      ["name":"Live Concert",
                       "image":"Live Concert"],
                      ["name":"Appointment",
                       "image":"Appointment"],
                      ["name":"Celebration",
                       "image":"Celebration"],
                      ["name":"Meeting",
                       "image":"Meeting"],
                      ["name":"Study",
                       "image":"Study"],
                      ["name":"Seminar",
                       "image":"Seminar"],
                      ["name":"Conference",
                       "image":"Conference"],
                      ["name":"Collaboration",
                       "image":"Collaboration"],
                      ["name":"Chill",
                       "image":"Chill"],
                      ["name":"Reading",
                       "image":"Reading"]
                      ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.collectionView.allowsMultipleSelection = true
        // Do any additional setup after loading the view, typically from a nib.
        btnAddEmoji.layer.cornerRadius = 15
        btnAddEmoji.layer.borderColor = UIColor.black.cgColor
        btnAddEmoji.layer.borderWidth = 1
        view1.layer.cornerRadius = 25
        view1.layer.borderColor = UIColor.black.cgColor
        view1.layer.borderWidth = 1
        view2.layer.borderColor = UIColor.black.cgColor
        view2.layer.borderWidth = 1
        view2.layer.cornerRadius = 20
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let layout = UPCarouselFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .horizontal
        myCollectionView.collectionViewLayout = layout
        self.setupLayout()
        self.currentPage = ExtensionModel.shared.Emoji_CurrentPage
        self.GET_SAVED_EMOJIS()
        let url = URL(string:  UserDefaults.standard.getProfileImage() ?? "")
        self.imgViewUser.setRounded()
        if (url != nil){
            self.imgViewUser?.kf.indicatorType = .activity
            self.imgViewUser?.kf.setImage(
                with: url,
                placeholder: UIImage(named: "community_listing_user"),
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
        }else{
            self.imgViewUser.image = UIImage(named: "community_listing_user")
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        if (checkInternetConnection() == true)
        {
            presenter?.get_emoji_offline()
        }
        
        
        if (Edit_Data?.count ?? 0 == 0)
        {
           //SET EMOJI TO THE CURRENT MOOD
           self.currentPage = ExtensionModel.shared.Emoji_CurrentPage
           EditMoodActivityData.sharedInstance?.evnt_id = Singleton.shared().updated_emojy_eventID
            //self.collectionView.reloadData()
            DispatchQueue.main.async {
                self.myCollectionView.scrollToItem(at:IndexPath(item: self.currentPage, section: 0), at: .centeredHorizontally, animated: true)
                self.myCollectionView.layoutIfNeeded()
                self.myCollectionView.reloadData()
            }
        }
        else
        {
            //SET EMOJI ACCORDING TO EDIT MOOD FROM MOOD LOG LISTING
            let obj = Edit_Data?[0]
            let name =  obj?.moodTrack
            EditMoodActivityData.sharedInstance?.evnt_id = obj?._id
            self.currentPage = CommonVc.AllFunctions.get_emojy_index_from_name(name: name ?? "")
            let index = getIndex(of: "image", for: obj?.eventsActivity ?? "", in: dictImages)
            
           self.selectedIndex = index
            self.collectionView.reloadData()
            self.myCollectionView.scrollToItem(at:IndexPath(item: self.currentPage, section: 0), at: .centeredHorizontally, animated: true)
            self.myCollectionView.layoutIfNeeded()
            self.myCollectionView.reloadData()
        }
        
    }
    
   
    @IBAction func ACTION_ADD_MORE_EMOJIS(_ sender: Any)
    {
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .ChooseMood, Data: "1")
    }
    
    //MARK: GET SAVED EMOJIS
    func GET_SAVED_EMOJIS()
    {
        self.emojiArray = self.createItems()
        let arr : NSArray = ExtensionModel.shared.stored_emoji_array
        if(arr.count > 0)
        {
            for obj in arr
            {
                let dic = obj as? NSDictionary
                let imageName : String = dic?.value(forKey: "image") as? String ?? ""
                let imageText : String = dic?.value(forKey: "name") as? String ?? ""
                
                let obj = CharacterC(imageName: imageName, title: imageText, description: imageName)
                
                emojiArray.append(obj)
            }
        }
        
        
//        self.myCollectionView.scrollToItem(at:IndexPath(item: self.currentPage, section: 0), at: .left, animated: false)
//
//        let page = self.currentPage
//        self.currentPage = page
        
    }
    
    @IBAction func actionDismiss(_ sender: Any) {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    fileprivate func setupLayout()
    {
        let layout = self.myCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: self.view.frame.size.width/3 - 20)
    }
    
    fileprivate func createItems() -> [CharacterC]
    {
        let characters = CommonVc.AllFunctions.createEmojy_forMood()
        return characters
    }
    
    @IBAction func actionOpenJournelThoughts(_ sender: Any)
    {
      //  EditMoodActivityData.sharedInstance?.moodTrack = self.lblSelectedMood.text
        
      //  CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .JournelThoughts, Data: nil)
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "JournelThoughtsVC")as! JournelThoughtsVC
        controller.Edit_Data_Journal = Edit_Data
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func actnCarereciever(_ sender: Any)
    {
        if (Edit_Data?.count ?? 0 == 0)
        {
            guard let popupNavController = storyboard?.instantiateViewController(withIdentifier: "NavigationSelectCareReciever") as? NavigationSelectCareReciever else { return }
            if let chooseCareRecieverVC = popupNavController.children.first as? ChooseCareRecieverVC
            {
                chooseCareRecieverVC.delegateRefrence = self
                popupNavController.shouldDismissInteractivelty = true
                self.present(popupNavController, animated: true, completion: nil)
            }
        }
        else
        {
            self.view.makeToast("Tracking for Myself is not editable for Edit Moods!")
        }
        
    }
    
    func setTrackingDetails(){
         self.imgViewUser.setRounded()
        if ChooseCareRecieverVC.trackingFor != ""{
            lblTrackingName.text = "Tracking for" + " " + ChooseCareRecieverVC.trackingFor
            
            let url = URL(string:  ChooseCareRecieverVC.trackingForImage ?? "")
            if (url != nil){
                self.imgViewUser?.kf.indicatorType = .activity
                self.imgViewUser?.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "community_listing_user"),
                    options: [
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ])
            }
            
            
        }else{
            let url = URL(string:  UserDefaults.standard.getProfileImage() ?? "")
            if (url != nil){
                self.imgViewUser?.kf.indicatorType = .activity
                self.imgViewUser?.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "community_listing_user"),
                    options: [
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ])
            }
            lblTrackingName.text = "Tracking for myself"
        }
    }
    
    
    func PopToController(){
        //I need to open bottompopup so calling delegate to perform action
        let goNext = StoryBoards.Auth.instantiateViewController(withIdentifier: AddCareRecieverVC.className) as? AddCareRecieverVC
        goNext?.delegate = self
        self.navigationController?.pushViewController(goNext ?? AddCareRecieverVC(), animated: true)
        
        //CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .AddCareReciever, Data: nil)
        
    }
    
}
extension AddActivityWithMoodVC : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.myCollectionView
        {
            return 1000
        }
        return dictImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell  =  UICollectionViewCell()
        
        if collectionView == self.myCollectionView
        {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as! CarouselCollectionViewCell
            let character = self.emojiArray[(indexPath as NSIndexPath).row % self.emojiArray.count]
            cell2.image.image = UIImage(named: character.imageName)
            cell = cell2
        }
        else
        {
            let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAcitivityCollectionCell", for: indexPath) as! AddAcitivityCollectionCell
            //cell.imageViewAcitivity.image = arrayImages[indexPath.row]
            cell3.imageViewAcitivity.image = UIImage.init(named: dictImages[indexPath.row]["image"]!)
            
            cell3.lblActivityName.text = dictImages[indexPath.row]["name"]
            let image = cell3.imageViewAcitivity.image
            
            if(selectedIndex == indexPath.row)
            {
                cell3.imageView.image = UIImage.init(named: "AcitivityCellBg")
                cell3.lblActivityName.textColor = UIColor.white
                cell3.imageViewAcitivity.image = image!.maskWithColor(color: .white)
                EditMoodActivityData.sharedInstance?.eventsActivity = cell3.lblActivityName.text
                //self.collectionView.reloadData()
            }
            else
            {
                cell3.lblActivityName.textColor = UIColor.black
                cell3.imageView.image = UIImage.init(named: "AcitivityCellWhiteBg")
                //cell.imageViewAcitivity.image = image!.maskWithColor(color: .black)
                
            }
            //cell.imageView.backgroundColor = UIColor.blue
            cell3.imageView.layer.cornerRadius = 10
            
            cell = cell3
            
            
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if (collectionView == self.myCollectionView)
        {
            selectedIndex = indexPath.row % self.emojiArray.count
        }
        else
        {
//            if(selectedIndex.contains(indexPath.row))
//            {
//                let index = selectedIndex.firstIndex(of: indexPath.row)
//                if index != nil
//                {
//                    self.selectedIndex.remove(at: index!)
//                }
//
//            }
//            else
//            {
//                selectedIndex.append(indexPath.row)
//            }
            
            if (selectedIndex == indexPath.row){
                selectedIndex = -1
                EditMoodActivityData.sharedInstance?.eventsActivity = " "
            }else{
                selectedIndex = indexPath.row
            }
            
            
            self.collectionView.reloadData()
            // image = image.maskWithColor(color: .green )
            
           
            //    let character = self.emojiArray[(indexPath as NSIndexPath).row % self.emojiArray.count]
            //    self.presenter?.setMoodFromServer(moodType: character.title, dateTime: self.tf_Date.text)
            
        }

    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if scrollView == self.myCollectionView
        {
//            let layout = self.myCollectionView.collectionViewLayout as! UPCarouselFlowLayout
//            let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
//            let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
//            let cpage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
            
            
            
            let visibleRect = CGRect(origin: myCollectionView.contentOffset, size: myCollectionView.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            let visibleIndexPath = myCollectionView.indexPathForItem(at: visiblePoint)
            let cp = (visibleIndexPath?.row)!
           
            self.currentPage = cp % self.emojiArray.count
            
            if (Edit_Data?.count ?? 0 == 0)
            {
                ExtensionModel.shared.Emoji_CurrentPage = self.currentPage
                if (checkInternetConnection() == true)
                {
                    let character = self.emojiArray[self.currentPage]
                    presenter?.update_emoji_offline(imageName: character.imageName, feel: diffrColorTxt, indx: self.currentPage, iconName: character.description)
                }
            }
        }
        
    }
    
    
   
    
}
extension AddActivityWithMoodVC : UpdateDataForPopUp{
    func openPopup() {
        guard let popupNavController = storyboard?.instantiateViewController(withIdentifier: "NavigationSelectCareReciever") as? NavigationSelectCareReciever else { return }
        if let chooseCareRecieverVC = popupNavController.children.first as? ChooseCareRecieverVC
        {
            chooseCareRecieverVC.delegateRefrence = self
            popupNavController.shouldDismissInteractivelty = true
            self.present(popupNavController, animated: true, completion: nil)
        }
    }
}
extension AddActivityWithMoodVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (collectionView == self.collectionView)
        {
            let noOfCellsInRow = 3
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
            
            let size = Int((collectionView.bounds.width - 5 - totalSpace) / CGFloat(noOfCellsInRow))
            return CGSize(width: size, height: size)
        }
        
        return  CGSize(width: 70, height: 70)
    }
    
}
