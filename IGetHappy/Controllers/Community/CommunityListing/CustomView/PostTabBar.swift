//
//  PostTabBar.swift
//  SamplePostApp
//
//  Created by Akash Dhiman on 7/18/19.
//  Copyright © 2019 Akash Dhiman. All rights reserved.
//

import UIKit
import Reactions

protocol PostTabBarDelegate
{
    func shareButtonTapped(sender: UIButton)
    func commentButtonTapped(sender: UIButton)
    func supportButtonTapped(sender: UIButton, reactionTitle: String)
}

class PostTabBar: UIView
{
    private var lastFocusedReaction: Reaction?
    //MARK:- Variables
    var delegate: PostTabBarDelegate?
    let reactionSelector = ReactionSelector()
    //MARK:- Properties
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var supportButton: ReactionButton!{
        didSet {
            supportButton.reactionSelector = ReactionSelector()
            
            supportButton.config           = ReactionButtonConfig() {
                $0.iconMarging      = 8
                $0.spacing          = 8
                $0.font             = UIFont(name: "HelveticaNeue", size: 14)
                $0.neutralTintColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
                $0.alignment        = .centerLeft
                
            }
            let summary       = ReactionSummary()
            summary.reactions = Reaction.facebook.all
            summary.text      = "16"
            
            supportButton.reactionSelector?.feedbackDelegate = self
            setupReactionsSelector()
        }
    }
    
    //MARK:- Instantiate Method
    class func instanceFromNib() -> PostTabBar {
        return UINib(nibName: PostTabBar.className , bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PostTabBar
    }
    
    func setupReactionsSelector() {
        
      
    
       // reactionSelector.reactions = Reaction.facebook.all
        
        
     
        
        // This one takes a value from ReactionSelector
        supportButton.addTarget(self, action: #selector(reactionChanged), for: .valueChanged)
        // And this one from ReactionButton
        supportButton.addTarget(self, action: #selector(reactionChanged), for: .touchUpInside)
        
        // The last focused reaction is empty, so we'll make it the first of the reactions
        lastFocusedReaction = reactionSelector.reactions.first
    }
    
    @objc func reactionChanged(_ sender: UIButton) {
        var reaction = self.supportButton.reactionSelector?.selectedReaction
         supportButton.reactionSelector?.selectedReaction = nil
        if(reaction == nil){
            reaction = lastFocusedReaction
        }
        self.likeAPI(reactions: reaction!, selectedSender: sender)
    }
    
    func likeAPI(reactions: Reaction, selectedSender: UIButton){
        if supportButton.isSelected {
            if reactions.title == "Love"{
                delegate?.supportButtonTapped(sender: selectedSender, reactionTitle: "heart")
            }else if reactions.title == "Support"{
                delegate?.supportButtonTapped(sender: selectedSender, reactionTitle: "Like")
            }
            else{
                delegate?.supportButtonTapped(sender: selectedSender, reactionTitle: reactions.title)
            }
        }else{
            delegate?.supportButtonTapped(sender: selectedSender, reactionTitle:"Unlike")
        }
    }
    
    //MARK:- Button Actions
    @IBAction func shareButtonAction(_ sender: UIButton) {
        delegate?.shareButtonTapped(sender: sender)
    }
    
    @IBAction func commentButtonAction(_ sender: UIButton) {
        delegate?.commentButtonTapped(sender: sender)
    }
}

//MARK:- Reaction Feedback Delegate Methods
extension PostTabBar: ReactionFeedbackDelegate {
    func reactionFeedbackDidChanged(_ feedback: ReactionFeedback?) {
        
    }
}
