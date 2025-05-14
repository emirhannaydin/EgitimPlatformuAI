//
//  ListeningFirstScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.05.2025.
//

import Foundation
import UIKit

final class CourseScreenViewController: UIViewController{
    
    var viewModel: CourseScreenViewModel!

    @IBOutlet var courseLevelName: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var courseName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        courseName.text = viewModel.courseName
        courseLevelName.text = viewModel.courseLevelName
    }
    
    

}
