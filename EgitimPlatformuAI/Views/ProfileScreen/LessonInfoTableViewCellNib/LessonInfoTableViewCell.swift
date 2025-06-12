//
//  LessonInfoTableViewCell.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 5.06.2025.
//

import UIKit

class LessonInfoTableViewCell: UITableViewCell {

    @IBOutlet var lessonLevelLabel: UILabel!
    @IBOutlet var lessonNameLabel: UILabel! 
    @IBOutlet var backView: UIView!
    @IBOutlet var progressBar: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
