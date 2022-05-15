//
//  MessageBubbleView.swift
//  ChatApp
//
//  Created by s b on 13.05.2022.
//

import UIKit

class MessageBubbleView: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    
    var id = ""
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.messageLabel?.layer.backgroundColor = UIColor.systemBlue.cgColor
        
        self.messageLabel?.textColor = .white
        

    }


}
