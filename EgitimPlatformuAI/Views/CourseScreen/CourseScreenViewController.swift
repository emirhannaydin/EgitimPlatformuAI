//
//  ListeningFirstScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.05.2025.
//

import Foundation
import UIKit

struct TestSection {
    let title: String
    let tests: [String]
    var isExpanded: Bool

}

final class CourseScreenViewController: UIViewController{

    
    var viewModel: CourseScreenViewModel!

    @IBOutlet var courseLevelName: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var courseName: UILabel!
    
    var sections: [TestSection] = [
        TestSection(title: "A1", tests: ["Greetings", "Family", "Numbers"], isExpanded: true),
        TestSection(title: "A2", tests: ["Shopping", "Directions"], isExpanded: false),
        TestSection(title: "B1", tests: ["Work", "Travel"], isExpanded: false),
        TestSection(title: "B2", tests: ["Debate", "News"], isExpanded: false),
        TestSection(title: "C1", tests: ["deneme", "deneme","deneme","deneme","deneme","deneme","deneme","deneme","deneme","deneme","deneme","deneme","deneme","deneme"], isExpanded: false),
        TestSection(title: "C2", tests: ["Debate", "News"], isExpanded: false)

    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        courseName.text = viewModel.courseType.courseName
        courseLevelName.text = viewModel.courseLevelName
        courseName.layer.cornerRadius = 10
        courseName.layer.borderWidth = 2
        courseName.layer.borderColor = UIColor.black.cgColor
        courseName.layer.masksToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CourseScreenHeaderFooterView.nib(), forHeaderFooterViewReuseIdentifier: CourseScreenHeaderFooterView.identifier)
        tableView.register(CourseScreenTableViewCell.nib(), forCellReuseIdentifier: CourseScreenTableViewCell.identifier)
        tableView.sectionHeaderTopPadding = 5
        

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTableViewTap(_:)))
            tapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self

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
        return sections[section].isExpanded ? sections[section].tests.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseScreenTableViewCell.identifier) as! CourseScreenTableViewCell
        
        cell.levelName.text = sections[indexPath.section].tests[indexPath.row]
        cell.firstStar.image = UIImage(systemName: "star.fill")
        cell.secondStar.image = UIImage(systemName: "star.fill")
        cell.thirdStar.image = UIImage(systemName: "star")

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CourseScreenHeaderFooterView.identifier) as? CourseScreenHeaderFooterView else {
            return nil
        }

        header.titleLabel.text = sections[section].title
        header.tag = section

        let isExpanded = sections[section].isExpanded
        header.imageView.image = UIImage(systemName: isExpanded ? "chevron.down" : "chevron.right")

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleHeaderTap(_:)))
        tap.delegate = self

        header.addGestureRecognizer(tap)

        return header
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.estimatedSectionHeaderHeight
    }

    @objc private func handleHeaderTap(_ gesture: UITapGestureRecognizer) {
        guard let tappedSection = gesture.view?.tag else { return }

        let isExpanded = sections[tappedSection].isExpanded
        tableView.beginUpdates()

        for (i, section) in sections.enumerated() {
            if section.isExpanded {
                sections[i].isExpanded = false
                let indexPathsToDelete = section.tests.indices.map {
                    IndexPath(row: $0, section: i)
                }
                tableView.deleteRows(at: indexPathsToDelete, with: .fade)
            }
        }

        if isExpanded {
            tableView.endUpdates()
            tableView.reloadSections(IndexSet(integer: tappedSection), with: .none)
            return
        }

        sections[tappedSection].isExpanded = true
        let indexPathsToInsert = sections[tappedSection].tests.indices.map {
            IndexPath(row: $0, section: tappedSection)
        }
        tableView.insertRows(at: indexPathsToInsert, with: .fade)
        tableView.endUpdates()
        tableView.reloadSections(IndexSet(integer: tappedSection), with: .none)
    }
}
extension CourseScreenViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
