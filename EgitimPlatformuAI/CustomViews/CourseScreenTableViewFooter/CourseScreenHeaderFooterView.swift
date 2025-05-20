//
//  CourseScreenHeaderFooterView.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 16.05.2025.
//

import UIKit

class CourseScreenHeaderFooterView: UITableViewHeaderFooterView {

    @IBOutlet var titleLabel: UILabel!
    
    
    @IBOutlet var imageView: UIImageView!
    static let identifier = "CourseScreenHeaderFooterView"
    
    static func nib() -> UINib{
        return UINib(nibName: "CourseScreenHeaderFooterView", bundle: nil)
    }
}
