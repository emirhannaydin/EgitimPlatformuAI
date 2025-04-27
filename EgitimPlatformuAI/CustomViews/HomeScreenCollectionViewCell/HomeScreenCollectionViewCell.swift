//
//  HomeScreenCollectionViewCell.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 4.03.2025.
//

import UIKit

class HomeScreenCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var labelText: UILabel!
    static let identifier = "HomeScreenCollectionViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "HomeScreenCollectionViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    

}
