//
//  SelectGenderVC.swift
//  IGetHappy
//
//  Created by Gagan on 6/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import ADDatePicker
class SelectGenderVC: UIViewController {
    
    @IBOutlet weak var selectedTickM: UIImageView!
    @IBOutlet weak var seletedTickF: UIImageView!
    @IBOutlet weak var Male: UIImageView!
    @IBOutlet weak var Female: UIImageView!
    @IBOutlet weak var datePicker: ADDatePicker!
    var selctedGender:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.yearRange(inBetween: 1990, end: 2022)
        datePicker.intialDate = Date()
        datePicker.bgColor = .clear
        datePicker.deselectedBgColor = .clear
        datePicker.selectedBgColor = .lightGray
        datePicker.selectionType = .circle
        datePicker.selectedTextColor = .black
        datePicker.deselectTextColor = .lightGray
        prepareTapGesture()
        self.selectedTickM.isHidden = false
        self.seletedTickF.isHidden = true
        UIView.animate(withDuration: 0.5) {
            
            self.Female.transform = .init(scaleX: 0.7, y: 0.7)
            self.Male.transform = .init(scaleX: 1, y: 1)
            
        }
        // Do any additional setup after loading the view.
    }
    
    
    
    func prepareTapGesture() {
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(SelectGenderVC.tapFunction(sender:)))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(SelectGenderVC.tapFunction(sender:)))
        tapGesture1.numberOfTapsRequired = 1
        tapGesture2.numberOfTapsRequired = 1
        
        
        Male.addGestureRecognizer(tapGesture1)
        Female.addGestureRecognizer(tapGesture2)
        Male.tag = 1
        Female.tag = 2
        Male.isUserInteractionEnabled = true
        Female.isUserInteractionEnabled = true
    }
    
    @objc func tapFunction(sender: UITapGestureRecognizer) {
        if(sender.view?.tag == 1){
            self.selectedTickM.isHidden = false
            self.seletedTickF.isHidden = true
            UIView.animate(withDuration: 0.5) {
                self.selctedGender = "Male"
                self.selectedTickM.transform = .init(scaleX: 1, y: 1)
                self.seletedTickF.transform = .init(scaleX: 0.7, y: 0.7)
                self.Female.transform = .init(scaleX: 0.7, y: 0.7)
                 self.Male.transform = .init(scaleX: 1, y: 1)
              
            }
            
        }else {
            self.selectedTickM.isHidden = true
            self.seletedTickF.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.selctedGender = "Female"
                self.selectedTickM.transform = .init(scaleX: 0.7, y: 0.7)
                self.seletedTickF.transform = .init(scaleX: 1.0, y: 1.0)
                self.Male.transform = .init(scaleX: 0.7, y: 0.7)
                self.Female.transform = .init(scaleX: 1, y: 1)
               
            }
            
        }
        
        // show pop up
        
    }

  

}
