//
//  HamburgerTableViewCell.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 2.03.2025.
//

import UIKit

class HamburgerTableViewCell: UITableViewCell {
    

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var labelText: UILabel!
    static let identifier = "HamburgerTableViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "HamburgerTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
