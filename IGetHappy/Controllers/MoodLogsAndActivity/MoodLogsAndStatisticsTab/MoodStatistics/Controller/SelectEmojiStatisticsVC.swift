//
//  SelectEmojiStatisticsVC.swift
//  IGetHappy
//
//  Created by Gagan on 12/19/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
protocol SelectEmojiDelegate:class {
    func sendDataBack(selectedEmojiResId: String,emojiName:String)
    
}
class SelectEmojiStatisticsVC: UIViewController {
    
   var selectedIndex  = Int()
    var delegateStatictsSelectEmoji:MoodStatisticsVC?
    @IBOutlet weak var tblViewEmojiList: UITableView!
    
    
    var arrMoods = [["name":"Haha",
                     "image":"haha"],
                    ["name":"Angry",
                     "image":"ic_angry_dark"],
                    ["name":"Wow",
                     "image":"wow_dark"],
                    ["name":"Sad",
                     "image":"sad_dark"],
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
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = -1
    }
    
    @IBAction func actionSelectEmoji(_ sender: Any) {
        
        
    }
    
    @IBAction func dismissView(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension SelectEmojiStatisticsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMoods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = self.tblViewEmojiList.dequeueReusableCell(withIdentifier: ShowEmojiListCell.className) as!  ShowEmojiListCell
        
        cell.imgViewListEmoji.image = UIImage.init(named: arrMoods[indexPath.row]["image"] ?? "smiley")
        cell.lblEmojiNameList.text = arrMoods[indexPath.row]["name"]
        
        if(selectedIndex == indexPath.row){
            cell.btnSelectEmoji.setImage(UIImage.init(named: "ActivityChecked"), for: .normal)
           
        }else{
            //cell.btnSelectCareReciever.imageView?.image = nil
            cell.btnSelectEmoji.setImage(UIImage.init(named: "ChatBotUncheck"), for: .normal)
            //cell.btnSelectCareReciever.setImage(UIImage.init(named: "ActivityCheck"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let resId = arrMoods[indexPath.row]["image"]
        let name = arrMoods[indexPath.row]["name"]
        delegateStatictsSelectEmoji?.sendDataBack(selectedEmojiResId: resId ?? "happy", emojiName: name ?? "Happy")
        self.tblViewEmojiList.reloadData()
        
    }
}
