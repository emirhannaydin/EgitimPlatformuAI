//
//  StudentsScreenTableViewCell.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 16.06.2025.
//

import UIKit

class StudentsScreenTableViewCell: UITableViewCell {
    

    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    static let identifier = "StudentsScreenTableViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "StudentsScreenTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let selectedBGView = UIView()
        selectedBGView.backgroundColor = UIColor.systemGray5
        self.selectedBackgroundView = selectedBGView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

    }
    
    
}
