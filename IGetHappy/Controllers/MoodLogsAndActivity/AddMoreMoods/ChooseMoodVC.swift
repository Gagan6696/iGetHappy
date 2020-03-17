//
//  ChooseMoodVC.swift
//  ActivityScreenUI
//
//  Created by Gagan on 9/25/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class ChooseMoodVC: UIViewController {
    
    // var saveArray = NSArray()
    var mutableArray = NSMutableArray()
    var saveArray = NSMutableArray()
    var from_activity_controller:String?
    let oldEmojiIndx = ExtensionModel.shared.Emoji_CurrentPage
    var arr = NSArray()
    
    var arrMoods:[[String:String]] =
        [["image":"happy",
               "name":"Happy","description":"happy"
            ],
         
         ["image":"proud",
               "name":"Proud","description":"proud"
            ],
         
         ["image":"ic_big_grin",
               "name":"Big grin","description":"ic_big_grin"
            ],
              
              ["image":"in_love",
               "name":"In Love","description":"in_love"
            ],
              
              ["image":"angel",
               "name":"Angel","description":"angel"
            ],
              
              
              ["image":"sleepy",
               "name":"Sleepy","description":"sleepy"
            ],
              
              ["image":"kiss",
               "name":"Kiss","description":"kiss"
            ],
              
              ["image":"ic_ironic_smile",
               "name":"Ironic smile","description":"ic_ironic_smile"
            ],
              
              ["image":"tounge",
               "name":"Tounge","description":"tounge"
            ],
              
       //       ["image":"Group-15",
       //        "name":"Angry","description":"ic_angry_dark"
       //     ],
              
              ["image":"ashamed",
               "name":"Ashamed","description":"ashamed"
            ],
              
              ["image":"pocker_face",
               "name":"Poker Face","description":"pocker_face"
            ],
              
              ["image":"ic_crying",
               "name":"Crying","description":"ic_crying"
            ]
            
    
    ]
    
    
//    [["image":"Group-1",
//    "name":"Happy"
//    ],["image":"Group-2",
//    "name":"LOL"
//    ],["image":"Group-3",
//    "name":"Enjoy"
//    ],["image":"Group-4",
//    "name":"Cool"
//    ],["image":"Group-5",
//    "name":"Fantastic"
//    ],["image":"Group-6",
//    "name":"Awesome"
//    ],["image":"Group-7",
//    "name":"Blushy"
//    ],["image":"Group-8",
//    "name":"Nice"
//    ],["image":"Group-9",
//    "name":"Funny"
//    ]]
//
    @IBOutlet weak var collectionViewMoods: UICollectionView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
         self.arr = ExtensionModel.shared.stored_emoji_array
        
        
        for obj in arr
        {
            let dic : NSDictionary = obj as! NSDictionary
            let imageName = dic.value(forKey: "image")as? String ?? ""
            
            for i in 0...arrMoods.count-1
            {
                let dic2 = arrMoods[i]
                let name = dic2["image"]
                
                if (imageName == name)
                {
                   self.mutableArray.add(i)
                }
            }
        }
        
    
    
    self.collectionViewMoods.reloadData()
    
}


@IBAction func ACTION_MOVE_BACK(_ sender: Any)
{
    CommonFunctions.sharedInstance.popTocontroller(from: self)
}

@IBAction func ACTION_SAVE(_ sender: Any)
{
    
    for index in 0...arrMoods.count
    {
        if(self.mutableArray.contains(index))
        {
            let obj = arrMoods[index]
            self.saveArray.add(obj)
            ExtensionModel.shared.Emoji_CurrentPage = 7//bcs last index has new value 4 will create aeverytime
            break
        }
    }
    
    ExtensionModel.shared.stored_emoji_array = self.saveArray
    
    
    if (from_activity_controller == "1")
    {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
       // CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .AddActivityWithMood, Data: nil)
    }
    else
    {
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Home, Data: nil)
    }
    
    
}


}
extension ChooseMoodVC:UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrMoods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = self.collectionViewMoods.dequeueReusableCell(withReuseIdentifier: "chooseMoodsCell", for: indexPath) as! chooseMoodCell
        cell.moodsImageView.image = UIImage.init(named: arrMoods[indexPath.row]["image"]!)
        cell.lblNameEmotion.text = arrMoods[indexPath.row]["name"]
        
        if (self.mutableArray.contains(indexPath.row))
        {
            //selected
            cell.ivSelected.isHidden = false
        }
        else
        {
            cell.ivSelected.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if self.mutableArray.contains(indexPath.row)
        {
            self.mutableArray.removeAllObjects()
            ExtensionModel.shared.Emoji_CurrentPage = oldEmojiIndx
        }
        else
        {
            self.mutableArray.removeAllObjects()
            self.mutableArray.add(indexPath.row)
        }
        
        self.collectionViewMoods.reloadData()
    }
    
}

extension ChooseMoodVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfSets = CGFloat(4)
        let width = (collectionViewMoods.frame.size.width + 5 - (numberOfSets * view.frame.size.width / 15))/numberOfSets
        let height = collectionViewMoods.frame.size.height / 8
        return CGSize(width: width, height:height)
    }
    
    // UICollectionViewDelegateFlowLayout method
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        let cellWidthPadding = collectionViewMoods.frame.size.width
    //        let cellHeightPadding = collectionViewMoods.frame.size.height / 4
    //        return UIEdgeInsets(top: cellHeightPadding,left: cellWidthPadding, bottom: cellHeightPadding,right: cellWidthPadding)
    //    }
    
}
