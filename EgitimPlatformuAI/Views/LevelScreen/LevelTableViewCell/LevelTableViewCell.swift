//
//  LevelTableViewCell.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 24.05.2025.
//

import UIKit
import Foundation

class LevelTableViewCell: UITableViewCell {

    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        UIView.animate(withDuration: 0.3) {
            self.containerView.backgroundColor = selected ? UIColor.summer : UIColor.silver
        }
    }
}
