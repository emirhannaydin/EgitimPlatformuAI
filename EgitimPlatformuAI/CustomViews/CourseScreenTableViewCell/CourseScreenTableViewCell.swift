//
//  CourseScreenTableViewCell.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 16.05.2025.
//

import UIKit

class CourseScreenTableViewCell: UITableViewCell {

    @IBOutlet var levelName: UILabel!
    @IBOutlet var checkImage: UIImageView!
    @IBOutlet var questionNumber: UILabel!
    static let identifier = "CourseScreenTableViewCell"
    
    
    static func nib() -> UINib{
        return UINib(nibName: "CourseScreenTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
