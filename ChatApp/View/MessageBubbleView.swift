//
//  MessageBubbleView.swift
//  ChatApp
//
//  Created by s b on 13.05.2022.
//

import UIKit

class MessageBubbleView: UICollectionViewCell {
    var message: String = ""
    
    let messageLabel: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = "TEXTtext"
        textView.backgroundColor = UIColor.clear
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        messageLabel.text = message
        addSubview(messageLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

