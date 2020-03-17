//
//  CustomAlert.swift
//  IGetHappy
//
//  Created by Akash Dhiman on 8/9/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

protocol CustomAlertDelegate {
    func YesButtonTapped(sender: UIButton)
    func NoButtonTapped(sender: UIButton)
}
class CustomAlert: UIView {

    //MARK:- Variables
    var delegate: CustomAlertDelegate?
    @IBOutlet weak var alertMessageLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var yesButton: UIButton!
    
    //MARK:- Instantiate Method
    class func instanceFromNib() -> CustomAlert {
        return UINib(nibName: CustomAlert.className , bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomAlert
    }
    
    @IBAction func NoButtonAction(_ sender: UIButton) {
        self.removeFromSuperview()
        delegate?.NoButtonTapped(sender: sender)
    }
    
    @IBAction func YesButtonAction(_ sender: UIButton) {
        self.removeFromSuperview()
        delegate?.YesButtonTapped(sender: sender)
    }
}
