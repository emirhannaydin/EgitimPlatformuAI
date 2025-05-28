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
        self.showLottieLoading()
        setupUI()
        setupTableView()
        setupTapGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchCourseLessons()
    }
}

// MARK: - Setup Methods
private extension CourseScreenViewController {
    func setupUI() {
        courseName.layer.borderWidth = 1
        courseName.layer.borderColor = UIColor.black.cgColor
        courseName.layer.masksToBounds = true
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CourseScreenHeaderFooterView.nib(), forHeaderFooterViewReuseIdentifier: CourseScreenHeaderFooterView.identifier)
        tableView.register(CourseScreenTableViewCell.nib(), forCellReuseIdentifier: CourseScreenTableViewCell.identifier)
        tableView.sectionHeaderTopPadding = 8
    }

    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTableViewTap(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
    }

    func fetchCourseLessons() {
        let userID = UserDefaults.standard.string(forKey: "userID") ?? "Unknown"
        viewModel.loadCourseLessons(studentId: userID) { [weak self] result in
            DispatchQueue.main.async {
                self?.hideLottieLoading()
                switch result {
                case .success:
                    self?.courseName.text = self?.viewModel.courseType.courseName
                    if let level = self?.viewModel.courseLevelName {
                        self?.courseLevelName.text = self?.viewModel.levelTextForString(for: level)
                    }
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - TableView DataSource & Delegate
extension CourseScreenViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].tests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseScreenTableViewCell.identifier, for: indexPath) as! CourseScreenTableViewCell
        let lesson = sections[indexPath.section].tests[indexPath.row]
        cell.levelName.text = lesson.content
        let checkImage = lesson.isCompleted ? "checkmark.circle.fill" : "checkmark.circle"
        cell.checkImage.image = UIImage(systemName: checkImage)
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

// MARK: - Gesture Handling
extension CourseScreenViewController: UIGestureRecognizerDelegate {
    @objc private func handleTableViewTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: tableView)
        if tableView.indexPathForRow(at: location) != nil { return }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
