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
    
    var sections: [TestSection] {
        return viewModel.sections
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        courseName.text = viewModel.courseType.courseName
        courseLevelName.text = viewModel.courseLevelName
        courseName.layer.cornerRadius = 10
        courseName.layer.borderWidth = 1
        courseName.layer.borderColor = UIColor.black.cgColor
        courseName.layer.masksToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CourseScreenHeaderFooterView.nib(), forHeaderFooterViewReuseIdentifier: CourseScreenHeaderFooterView.identifier)
        tableView.register(CourseScreenTableViewCell.nib(), forCellReuseIdentifier: CourseScreenTableViewCell.identifier)
        tableView.sectionHeaderTopPadding = 8
        

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTableViewTap(_:)))
            tapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        
        let userID = UserDefaults.standard.string(forKey: "userID") ?? "Unknown"
            viewModel.loadCourseLessons(studentId: userID) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.tableView.reloadData()
                    case .failure(let error):
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                    }
                }
            }

    }
    
    
    @objc private func handleTableViewTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: tableView)
        if tableView.indexPathForRow(at: location) != nil {
            return
        }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    

}

extension CourseScreenViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].tests.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseScreenTableViewCell.identifier) as! CourseScreenTableViewCell

        let lesson = sections[indexPath.section].tests[indexPath.row]
        cell.levelName.text = lesson.content

        let starImage = lesson.isCompleted ? "star.fill" : "star"
        cell.firstStar.image = UIImage(systemName: starImage)
        cell.secondStar.image = UIImage(systemName: starImage)
        cell.thirdStar.image = UIImage(systemName: starImage)

        return cell
    }


    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CourseScreenHeaderFooterView.identifier) as? CourseScreenHeaderFooterView else {
            return nil
        }

        header.titleLabel.text = sections[section].title
        header.tag = section
        header.imageView.isHidden = true // açılır kapanır gerek yok artık

        return header
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ApplicationCoordinator.getInstance().pushFromTabBarCoordinator(SpeakingScreenCoordinator.self, hidesBottomBar: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.estimatedSectionHeaderHeight
    }

    
}
extension CourseScreenViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
