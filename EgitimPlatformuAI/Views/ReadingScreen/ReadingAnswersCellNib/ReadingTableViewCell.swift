//
//  ReadingTableViewCell.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 5.05.2025.
//

import UIKit

class ReadingTableViewCell: UITableViewCell {

    @IBOutlet var answerText: UILabel!
    @IBOutlet var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        UIView.animate(withDuration: 0.3) {
                self.containerView.backgroundColor = selected ? UIColor.mediumTurqoise : UIColor.paleGray
        }
    }
    
}
