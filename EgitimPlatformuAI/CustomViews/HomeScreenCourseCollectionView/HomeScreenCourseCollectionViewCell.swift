//
//  HomeScreenCourseCollectionViewCell.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 27.04.2025.
//

import UIKit

class HomeScreenCourseCollectionViewCell: UICollectionViewCell {

    @IBOutlet var courseNameLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    static let identifier = "HomeScreenCourseCollectionViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "HomeScreenCourseCollectionViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    

}
