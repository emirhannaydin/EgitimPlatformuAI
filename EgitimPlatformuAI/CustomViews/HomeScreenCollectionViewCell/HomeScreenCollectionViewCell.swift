//
//  HomeScreenCollectionViewCell.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 4.03.2025.
//

import UIKit
import MBCircularProgressBar

class HomeScreenCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet var completedLessonLabel: UILabel!
    @IBOutlet var courseName: UILabel!
    @IBOutlet var progressView: MBCircularProgressBarView!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var lessonLabel: UILabel!
    static let identifier = "HomeScreenCollectionViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "HomeScreenCollectionViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        let formatted = String(format: "%g", progressView.maxValue)
        progressView.unitString = " / \(formatted)"
    }
    

}
