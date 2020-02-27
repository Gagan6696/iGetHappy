//
//  MoodStatisticsVC.swift
//  IGetHappy
//
//  Created by Gagan on 11/15/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import Charts
protocol MoodStatisticsViewDelegate:class {
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
    
}
var arrMoodsPlotGraph = ["happy","blushing","ic_angry_dark","Crying","Surprised"]
class MoodStatisticsVC: BaseUIViewController {
    
    @IBOutlet weak var consBottom: NSLayoutConstraint!
    @IBOutlet weak var chartView: LineChartView!
    
    @IBOutlet weak var viewStreak: UIView!
    @IBOutlet weak var viewMoodChart: UIView!
    @IBOutlet weak var viewMoodCount: UIView!
    @IBOutlet weak var viewOftenTogeather: UIView!
    @IBOutlet weak var viewSelectOftenTogeather: UIView!
    @IBOutlet weak var collectionViewActivity: UICollectionView!
    @IBOutlet weak var collectionViewMood: UICollectionView!
    @IBOutlet weak var collectionViewStreak: UICollectionView!
    @IBOutlet weak var collectionViewCareRecievers: UICollectionView!
    var selectedCareReceiver = Int()
    var presenter:ChooseCareRecieverPresenter?
    var presenterMoodStatistics:MoodStatisticsPresenter?
    var CareRecieverData:ChooseCareRecieverMapper?
    var moodStatisticsData:MoodStatisticsMapper?
    var streakAndMoodCountData:StreakAndMoodCountMapper?
    var getActivityCountData:ActivityCountMapper?
    var selectedCareRcvrId  = String()
    //Check user come from care recivers tab profile from side menu and select mood report
    var isFromCareReciversTab:Bool = false
    //This id we recived from care recivers tab then seleced care reciver profile.
    var showDataCareReciverId = String()
    //var resId = String()
    
    @IBOutlet weak var btnDaily: CustomButton!
    
    @IBOutlet weak var btnWeekly: CustomButton!
    
    var daysAndWeak = [String]()
    var moods = [Double]()
    var getselectedEmojiResId = String()
    
    
    @IBOutlet weak var imgViewSelectedEmoji: UIImageView!
    
    @IBOutlet weak var lblSelectedEmojiName: UILabel!
    
    @IBOutlet weak var tblViewEmojiList: UITableView!
    
    @IBOutlet weak var btnStreak: CustomButton!
    
    @IBOutlet weak var heightCareRcvrView: NSLayoutConstraint!
    
    @IBOutlet weak var careReciverView: RoundShadowView!
    
    @IBOutlet weak var currentMonths: CustomButton!
    @IBOutlet weak var lblBestStreak: UILabel!
    var arrMoods = [["name":"Sad",
                     "image":"sad_dark"],
                    ["name":"Angry",
                     "image":"ic_angry_dark"],
                    ["name":"Wow",
                     "image":"wow_dark"],
                    ["name":"Haha",
                     "image":"haha"],
                    ["name":"Excited",
                     "image":"excited"],
                    ["name":"Wink",
                     "image":"wink"],
                    ["name":"Blushing",
                     "image":"blushing"],
                    ["name":"Happy",
                     "image":"happy"],
                    ["name":"Proud",
                     "image":"proud"],
                    ["name":"Blushing",
                     "image":"blushing_dark"],
                    ["name":"Angel",
                     "image":"angel"],
                    ["name":"Smile",
                     "image":"ic_ironic_smile"],
                    ["name":"Grin",
                     "image":"ic_big_grin"],
                    ["name":"Kiss",
                     "image":"kiss"],
                    ["name":"Tounge",
                     "image":"tounge"],
                    ["name":"Sleepy",
                     "image":"sleepy"],
                    ["name":"Pockerface",
                     "image":"pocker_face"],
                    ["name":"Ashamed",
                     "image":"ashamed"],
                    ["name":"Crying",
                     "image":"ic_crying"],
                    ["name":"Love",
                     "image":"in_love"]]
    
    let arrActivity = [["name":"Movie",
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
                       "image":"Live Concert"]]

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.presenter = ChooseCareRecieverPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        self.presenterMoodStatistics = MoodStatisticsPresenter.init(delegate: self)
        self.presenterMoodStatistics?.attachView(view: self)
        self.presenter?.GetAllListCareReciever()
        getSreakAndMoodCountList(careRecieverId: "")
        getActivityCount(careRecieverId: "", resId: "happy")
        getChartDetails(careRecieverId: "")
        getselectedEmojiResId = "happy"
        self.imgViewSelectedEmoji.image = UIImage.init(named: getselectedEmojiResId)
        self.lblSelectedEmojiName.text = "Happy"
        self.btnDaily.layer.cornerRadius = 25
        self.btnWeekly.layer.cornerRadius  = 25
        self.btnWeekly.backgroundColor = .white
        self.btnDaily.backgroundColor = .lightGray
       // self.blurViewHeightConstraint.constant = 0
       
       
        
        
         //daysAndWeak = ["1 Weak","2 Weak","3 Weak","4 Weak"]
        // moods = [0.0,3.0,4.0,5.0]
     //   setChartView(daysAndWeak, values: moods)
        //setChartView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cuurentDate = Date().month + " " + Date().year
        currentMonths.setTitle(cuurentDate, for: .normal)
        if (isFromCareReciversTab){
            self.collectionViewCareRecievers.isHidden = true
            self.careReciverView.isHidden = true
            self.heightCareRcvrView.constant = 0
            getSreakAndMoodCountList(careRecieverId: showDataCareReciverId)
            getActivityCount(careRecieverId: showDataCareReciverId, resId: "happy")
            getChartDetails(careRecieverId: showDataCareReciverId)
        }
    }
    
    private func setChartView(_ dataPoints: [String], values: [Double]){
        
        var dataEntries: [ChartDataEntry] = []
            
            for i in 0 ..< dataPoints.count {
                dataEntries.append(ChartDataEntry(x: Double(i), y: values[i]))
            }
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
            lineChartDataSet.mode = .cubicBezier
            lineChartDataSet.drawIconsEnabled = true
            lineChartDataSet.drawCirclesEnabled = false
            lineChartDataSet.axisDependency = .left
            lineChartDataSet.setColor(UIColor.black)
            lineChartDataSet.setCircleColor(UIColor.black) // our circle will be dark red
            lineChartDataSet.lineWidth = 1.0
            lineChartDataSet.circleRadius = 3.0 // the radius of the node circle
            lineChartDataSet.fillAlpha = 1
            lineChartDataSet.fillColor = UIColor.black
            lineChartDataSet.highlightColor = UIColor.white
            lineChartDataSet.drawCircleHoleEnabled = false
            lineChartDataSet.drawValuesEnabled = false
            var dataSets = [LineChartDataSet]()
            dataSets.append(lineChartDataSet)
            let lineChartData = LineChartData(dataSets: dataSets)
            chartView.data = lineChartData
            chartView.rightAxis.enabled = false
            chartView.xAxis.drawGridLinesEnabled = false
            chartView.xAxis.axisMinimum = 0.0 //I changed this from 1 to 0
            chartView.leftAxis.drawGridLinesEnabled = false
            chartView.leftAxis.axisMinimum = 0.0
            chartView.xAxis.labelPosition = .bottom
            chartView.leftAxis.labelPosition = .outsideChart
            chartView.scaleYEnabled = false
            chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
            //chartView.setViewPortOffsets(left: 20, top: 20, right: 20, bottom: 20)
            chartView.extraRightOffset = 20
        chartView.leftAxis.axisMaximum = 6.0
            chartView.extraLeftOffset = 10
        chartView.extraTopOffset = 20
        chartView.extraBottomOffset = -10
            ///chartView.fitScreen()
    }
    private func getActivityCount(careRecieverId:String,resId:String){
        if self.checkInternetConnection(){
            self.presenterMoodStatistics?.GetActivityCount(careReceiverId: careRecieverId, resourceId: resId)
        }else{
            self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
        }
    }
    private func getChartDetails(careRecieverId:String){
        if self.checkInternetConnection(){
            self.presenterMoodStatistics?.GetChartDetails(careReceiverId: careRecieverId)
        }else{
            self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
        }
    }
    
    private func getSreakAndMoodCountList(careRecieverId:String){
        if self.checkInternetConnection(){
            self.presenterMoodStatistics?.GetSreakAndMoodCount(careReceiverId: careRecieverId)
        }else{
            self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
        }
    }
    
    @IBAction func actionSelectEmojiForActivites(_ sender: Any)
    {
        guard let popupNavController = storyboard?.instantiateViewController(withIdentifier: NavigationSelectEmojiStatistics.className) as? NavigationSelectEmojiStatistics else { return }
        if let selectEmojiStatisticsVC = popupNavController.children.first as? SelectEmojiStatisticsVC
        {
            selectEmojiStatisticsVC.delegateStatictsSelectEmoji = self
            popupNavController.shouldDismissInteractivelty = true
            self.present(popupNavController, animated: true, completion: nil)
        }
    
    }
    
    
    @IBAction func actionDaily(_ sender: Any) {
        self.btnWeekly.backgroundColor = .white
        self.btnDaily.backgroundColor = .lightGray
        chartView.notifyDataSetChanged(); // let the chart know it's data changed
        chartView.resetZoom()
        chartView.clear()
        chartView.clearValues()
        self.moods.removeAll()
        self.daysAndWeak.removeAll()
        setDailyData()
    }
    
    @IBAction func actionWeekly(_ sender: Any) {
        self.btnWeekly.backgroundColor = .lightGray
        self.btnDaily.backgroundColor = .white
        chartView.notifyDataSetChanged(); // let the chart know it's data changed
        chartView.resetZoom()
        chartView.clear()
        chartView.clearValues()
        self.moods.removeAll()
        self.daysAndWeak.removeAll()
        setWeekData()
    }
    
}

extension MoodStatisticsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView == collectionViewMood){
            return streakAndMoodCountData?.data?.moodCount?.count ?? 0
        }else if (collectionView == collectionViewStreak){
            return streakAndMoodCountData?.data?.dayStatus?.count ?? 0
        }else if (collectionView == collectionViewActivity){
            return getActivityCountData?.data?.count ?? 0
        }else if (collectionView == collectionViewCareRecievers){
            
            let careRcvrCount = CareRecieverData?.data?.count ?? 0 
            
            return careRcvrCount + 1
        }else{
            return 0
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if(collectionView == collectionViewActivity){
        let cell = self.collectionViewActivity.dequeueReusableCell(withReuseIdentifier: StatisticsActivityCell.className, for: indexPath) as! StatisticsActivityCell
            let activityData = getActivityCountData?.data?[indexPath.row]
            
            if (UIImage(named: activityData?._id ?? "hdgdh") != nil) {
               cell.imgViewActivity.image = UIImage.init(named: activityData?._id ?? "smily")
            }
            else {
                cell.imgViewActivity.image = UIImage.init(named: "smily")
                //print("Image is not existing")
            }
            
            cell.imgViewlblName.text = activityData?._id
             //cell.lblCountBagde.text = "5"
            if let count = activityData?.count{
                cell.lblCountBagde.text = "\(count)"
                //cell.lblCountBagde.text = "5"
            }else{
                cell.lblCountBagde.text = "0"
            }
           // cell.imgViewActivity.image = UIImage.init(named: arrActivity[indexPath.row]["image"] ?? "")
           // cell.imgViewlblName.text = arrActivity[indexPath.row]["name"]
            return cell
        }else if (collectionView == collectionViewMood){
             let cell = self.collectionViewMood.dequeueReusableCell(withReuseIdentifier: StatisticsMoodCell.className, for: indexPath) as! StatisticsMoodCell
            let mooodData = streakAndMoodCountData?.data?.moodCount?[indexPath.row]
            cell.imgViewMood.image = UIImage.init(named: mooodData?._id ?? "smily")
            cell.lblMoodName.text = mooodData?.moodTrack
            
            if let count = mooodData?.count{
                cell.lblCount.text = "\(count)"
            }else{
                 cell.lblCount.text = "0"
            }
            
            //cell.imgViewMood.image = UIImage.init(named: arrMoods[indexPath.row]["image"]!)
            
            return cell
        }
        else if(collectionView == collectionViewStreak){
            let cell = self.collectionViewStreak.dequeueReusableCell(withReuseIdentifier: StatisticsStreakCell.className, for: indexPath) as! StatisticsStreakCell
            
            let data = streakAndMoodCountData?.data?.dayStatus?[indexPath.row]
            if let streak = streakAndMoodCountData?.data?.streak {
                 self.lblBestStreak.text = "Longest Best Day Streak: " + "\(streak)" + " days"
            }else{
                self.lblBestStreak.text = "Longest Best Day Streak: 2 days"
            }
           
            print(data?.status)
            if(data?.status ?? false){
                cell.imgViewStreak.image  = UIImage.init(named: "MoodStatisticsCheck")
            }else{
                cell.imgViewStreak.image  = UIImage.init(named: "Statisticscross")
            }
            return cell
        }
        else {
             let cell = self.collectionViewCareRecievers.dequeueReusableCell(withReuseIdentifier: StatisticsCareReciversCell.className, for: indexPath) as! StatisticsCareReciversCell
            
            if(selectedCareReceiver == indexPath.row)
            {
                cell.contentView.backgroundColor = .clear
                 cell.contentView.alpha = 1
            }else{
                cell.contentView.backgroundColor = .white
                cell.contentView.alpha = 0.2
            }
            cell.imgView.roundCorners(.allCorners, radius: 25.0)
            
            if(indexPath.row == 0){
                cell.lblName.text = UserDefaults.standard.getFirstName()
                cell.lblRelation.text = "(Me)"
                // cell.imageView?.kf.setImage(with:URL.init(string: UserDefaults.standard.getProfileImage()!) )
                if let profileImage = UserDefaults.standard.getProfileImage(){
                     let url = URL(string: profileImage)
                    
                    cell.imgView?.kf.indicatorType = .activity
                    cell.imgView?.layer.cornerRadius = cell.imgView.frame.width/2
                    cell.imgView?.kf.setImage(
                        with: url,
                        placeholder: UIImage(named: "community_listing_user"),
                        options: [
                            .scaleFactor(UIScreen.main.scale),
                            .transition(.fade(1)),
                            .cacheOriginalImage
                        ])
                }
            }else{
                
                cell.lblName.text = CareRecieverData?.data?[indexPath.row - 1].first_name
                cell.lblRelation.text = "(" + (CareRecieverData?.data?[indexPath.row - 1].relationship ?? "User") + ")"
                
                let profileImage =  CareRecieverData?.data?[indexPath.row - 1].profile_image
                
                let url = URL(string: profileImage!)
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
            return cell
        }
        //return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(collectionView == collectionViewCareRecievers){
            
            selectedCareReceiver = indexPath.row

            if (indexPath.row == 0){
                selectedCareRcvrId = ""
            }else{
                selectedCareRcvrId = CareRecieverData?.data?[indexPath.row - 1]._id ?? ""
            }
            
            
            daysAndWeak.removeAll()
            moods.removeAll()
            
            getSreakAndMoodCountList(careRecieverId: selectedCareRcvrId)
            getActivityCount(careRecieverId: selectedCareRcvrId, resId: "happy")
            getChartDetails(careRecieverId: selectedCareRcvrId)
            
//            collectionView.performBatchUpdates({ () -> Void in
//                let ctx = UICollectionViewFlowLayoutInvalidationContext()
//                ctx.invalidateFlowLayoutDelegateMetrics = true
//                collectionView.collectionViewLayout.invalidateLayout(with: ctx)
//            }) { (_: Bool) -> Void in
//            }
            
            self.collectionViewCareRecievers.reloadData()
             //collectionView.performBatchUpdates(nil, completion: nil)
        }
        
       
    }
  //  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//     {
//
//        if(collectionView == collectionViewCareRecievers){
//            switch collectionView.indexPathsForSelectedItems?.first {
//            case .some(indexPath):
//
//
//                return CGSize.init(90.0, 140.0) // your selected height
//            default:
//                return  CGSize.init(68.0, 114.0)
//            }
//
//        }else if (collectionView == collectionViewActivity){
//            return CGSize.init(75.0, 90.0)
//        }else if (collectionView == collectionViewStreak){
//            return CGSize.init(50.0, 56.0)
//        }else if (collectionView == collectionViewMood){
//            return CGSize.init(72.0, 87.0)
//        }else{
//            return CGSize()
//        }
//
//    }
    
    
}


extension MoodStatisticsVC:ChooseCareRecieverDelegate{
    func ChooseCareRecieverDidSucceeed(data: ChooseCareRecieverMapper?) {
        hideLoader()
        CareRecieverData = data
        print(UserDefaults.standard.getUserId() ?? "")
       // print("data CareRecieverData ",CareRecieverData )
        self.collectionViewCareRecievers.reloadData()
    }
    
    func ChooseCareRecieverDidFailed(message:String?) {
        hideLoader()
        self.showAlert(Message: message ?? "")
    }
}

extension MoodStatisticsVC:ChooseCareRecieverViewDelegate{
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
extension MoodStatisticsVC : MoodStatisticsDelegate{
    func MoodStatisticsChartDidSucceeed(data: MoodStatisticsMapper?) {
        self.hideLoader()
        self.collectionViewMood.reloadData()
        self.collectionViewStreak.reloadData()
        self.collectionViewActivity.reloadData()
        self.collectionViewCareRecievers.reloadData()
        moodStatisticsData = data
        setDailyData()
     
        //self.actionDaily(self)
    }
    
    func setDailyData(){
        
        
        if (moodStatisticsData?.data?.count ?? 0 > 0){
            let count = moodStatisticsData?.data?.count
            for i in 0...count! - 1{
                let catName = moodStatisticsData?.data?[i].catname
                
                let catNumber = getCategoryNumberForMood(moodName: catName ?? "")
                
                if (catNumber <= 5.0)
                {
                    moods.append(catNumber)
                    
//                    let day = self.getDayFromISOString(string: moodStatisticsData?.data?[i].key ?? "")
//                    if day != nil{
//                        daysAndWeak.append(day ?? "")
//                    }
                }else{
                     moods.append(0.0)
                }
                let day = self.getDayFromISOString(string: moodStatisticsData?.data?[i].key ?? "")
                if day != nil{
                    daysAndWeak.append(day ?? "")
                }
            }
            
        }
        
        if (moods.count == daysAndWeak.count && moods.count != 0 && daysAndWeak.count != 0) {
            
             setChartView(daysAndWeak, values: moods)
        }else{
            self.view.makeToast("Some error occured while loading graph")
        }
        
    }
    
    func setWeekData(){
        if (moodStatisticsData?.groupedByWeek?.count ?? 0 > 0){
            let count = moodStatisticsData?.groupedByWeek?.count
            for i in 0...count! -  1{
                let catName = moodStatisticsData?.groupedByWeek?[i].catname
                
                let catNumber = getCategoryNumberForMood(moodName: catName ?? "")
                
                if (catNumber <= 5.0)
                {
                    moods.append(catNumber)
                    
                    //                    let day = self.getDayFromISOString(string: moodStatisticsData?.data?[i].key ?? "")
                    //                    if day != nil{
                    //                        daysAndWeak.append(day ?? "")
                    //                    }
                }else{
                    moods.append(0.0)
                }
                //let day = self.getDayFromISOString(string: moodStatisticsData?.groupedByWeek?[i].key ?? "")
                let week = moodStatisticsData?.groupedByWeek?[i].week
                daysAndWeak.append(week ?? "")
            }
        }
        
        if (moods.count == daysAndWeak.count && moods.count != 0 && daysAndWeak.count != 0) {
            
            setChartView(daysAndWeak, values: moods)
        }else{
            self.view.makeToast("Some error occured while loading graph")
        }
        
    }
    
    func MoodStatisticsActivityDidSucceeed(data: ActivityCountMapper?) {
        self.hideLoader()
        self.collectionViewMood.reloadData()
        self.collectionViewStreak.reloadData()
        self.collectionViewActivity.reloadData()
        self.collectionViewCareRecievers.reloadData()
        getActivityCountData = data
    }
    
    func MoodStatisticsDidSucceeed(data: StreakAndMoodCountMapper?) {
        self.hideLoader()
        streakAndMoodCountData = data
        self.collectionViewMood.reloadData()
        self.collectionViewStreak.reloadData()
        self.collectionViewActivity.reloadData()
        self.collectionViewCareRecievers.reloadData()
        
    }
    
    func MoodStatisticsDidFailed(message: String?) {
        hideLoader()
        
    }
}
extension MoodStatisticsVC : MoodStatisticsViewDelegate{
    
}
extension MoodStatisticsVC:SelectEmojiDelegate{
    func sendDataBack(selectedEmojiResId: String,emojiName:String) {
        getselectedEmojiResId = selectedEmojiResId
        self.imgViewSelectedEmoji.image = UIImage.init(named: selectedEmojiResId)
        self.lblSelectedEmojiName.text = emojiName
        getActivityCount(careRecieverId: selectedCareRcvrId, resId: selectedEmojiResId)
    }
    
}
