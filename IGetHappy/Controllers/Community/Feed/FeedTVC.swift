//
//  FeedTVC.swift
//  IGetHappy
//
//  Created by Gagan on 5/30/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import Reactions
class FeedTVC: UITableViewCell {

    @IBOutlet weak var btn_Like: ReactionButton!{
        didSet {
            btn_Like.reactionSelector = ReactionSelector()
            
            btn_Like.config           = ReactionButtonConfig() {
                $0.iconMarging      = 8
                $0.spacing          = 8
                $0.font             = UIFont(name: "HelveticaNeue", size: 18)
                $0.neutralTintColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
                $0.alignment        = .centerLeft
            }
            
            btn_Like.reactionSelector?.feedbackDelegate = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    @IBAction func btn_LikeActn(_ sender: Any) {
        
        if btn_Like.isSelected == false {
            btn_Like.reaction   = Reaction.facebook.like
        }
        guard let reaction  = btn_Like.reactionSelector?.selectedReaction else { return }
        
        print("gagan",reaction.title)
         //guard let reaction = reactionSelect.selectedReaction else { return }
        
    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension FeedTVC: ReactionFeedbackDelegate {
    func reactionFeedbackDidChanged(_ feedback: ReactionFeedback?) {
//        feedbackLabel.isHidden = feedback == nil
 print("gagan",feedback?.localizedString)
//        feedbackLabel.text = feedback?.localizedString
    }
    

}
