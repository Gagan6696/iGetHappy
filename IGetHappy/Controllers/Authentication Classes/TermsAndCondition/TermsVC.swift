//
//  TermsVC.swift
//  IGetHappy
//
//  Created by Gagan on 1/23/20.
//  Copyright © 2020 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class TermsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
