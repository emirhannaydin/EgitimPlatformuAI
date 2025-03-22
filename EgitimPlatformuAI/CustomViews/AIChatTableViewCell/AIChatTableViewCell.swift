//
//  AIChatTableViewCell.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 22.03.2025.
//

import UIKit
import SwiftOpenAI

class AIChatTableViewCell: UITableViewCell {

   
    
    @IBOutlet weak var messageLabel: UILabel!
    static let identifier = "AIChatTableViewCell"
    
    
    static func nib() -> UINib{
        return UINib(nibName: "AIChatTableViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
   /* func configure(with message: MessageChatGPT) {
            messageLabel.text = message.text

            if message.role == .user {
                // Kullanıcı mesajı sağda
                bubbleView.backgroundColor = .blue
                messageLabel.textColor = .white
                
            } else {
                // Asistan mesajı solda
                bubbleView.backgroundColor = .lightGray
                messageLabel.textColor = .black
              
            }
        }*/
    
}
