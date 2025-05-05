//
//  HomeScreenCourseCollectionViewCell.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 27.04.2025.
//

import UIKit
import Lottie

class HomeScreenCourseCollectionViewCell: UICollectionViewCell {

    @IBOutlet var courseNameLabel: UILabel!
    
    @IBOutlet var enrollLabel: UILabel!
    @IBOutlet var lottieView: LottieAnimationView!
    @IBOutlet var clickLabel: UILabel!
    static let identifier = "HomeScreenCourseCollectionViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "HomeScreenCourseCollectionViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    

}
