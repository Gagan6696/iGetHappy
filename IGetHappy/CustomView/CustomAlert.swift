//
//  CustomAlert.swift
//  IGetHappy
//
//  Created by Akash Dhiman on 8/9/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

protocol CustomAlertDelegate {
    func okayButtonTapped(sender: UIButton)
}
class CustomAlert: UIView {

    //MARK:- Variables
    var delegate: CustomAlertDelegate?
    @IBOutlet weak var alertMessageLabel: UILabel!
    @IBOutlet weak var okayButton: UIButton!
    
    //MARK:- Instantiate Method
    class func instanceFromNib() -> CustomAlert {
        return UINib(nibName: CustomAlert.className , bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomAlert
    }
    
    @IBAction func okayButtonAction(_ sender: UIButton) {
        self.removeFromSuperview()
        delegate?.okayButtonTapped(sender: sender)
    }
}
