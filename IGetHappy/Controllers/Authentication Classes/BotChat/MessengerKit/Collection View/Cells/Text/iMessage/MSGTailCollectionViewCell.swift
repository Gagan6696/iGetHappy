//
//  MSGOutgoingTailCollectionViewCell.swift
//  MessengerKit
//
//  Created by Stephen Radford on 10/06/2018.
//  Copyright © 2018 Cocoon Development Ltd. All rights reserved.
//

import UIKit

open class MSGTailCollectionViewCell: MSGMessageCell {
    
    @IBOutlet public weak var bubble: MSGTailOutgoingBubble!
    @IBOutlet weak var bubbleWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblSenderNAme: UILabel!
    
    override open var message: MSGMessage? {
        didSet {
            guard let message = message,
                case let MSGMessageBody.text(body) = message.body else { return }
            
            bubble.text = body
        }
    }
//     open var user: MSGUser? {
//        didSet {
//            guard let user = user else { return }
//            print(user.displayName)
//
//        }
//    }
    override open var style: MSGMessengerStyle? {
        didSet {
            guard let message = message, let style = style as? MSGIMessageStyle else { return }
//            bubble.linkTextAttributes = [NSAttributedString.Key.underlineColor: style.outgoingLinkColor]
//            bubble.linkTextAttributes = [NSAttributedString.Key.foregroundColor: style.outgoingLinkColor]
            print(bubble)
            bubble.font = style.font
            bubble.backgroundImageView.tintColor = message.user.isSender ? style.outgoingBubbleColor : style.incomingBubbleColor
    
            lblSenderNAme.text =   message.user.displayName
          
            bubble.textColor = message.user.isSender ? style.outgoingTextColor : style.incomingTextColor
           // bubble.textColor = .green
        }
    }
    
    override open var isLastInSection: Bool {
        didSet {
            guard let style = style as? MSGIMessageStyle,
            !style.alwaysDisplayTails else {
                bubble.shouldShowTail = true
                return
            }
            
            bubble.shouldShowTail = isLastInSection
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        let bubbleSize = bubble.calculatedSize(in: bounds.size)
        bubbleWidthConstraint.constant = bubbleSize.width
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        isLastInSection = false
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        bubble.delegate = self
    }

}

extension MSGTailCollectionViewCell: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        delegate?.cellLinkTapped(url: URL)
        
        return false
    }
    
}
