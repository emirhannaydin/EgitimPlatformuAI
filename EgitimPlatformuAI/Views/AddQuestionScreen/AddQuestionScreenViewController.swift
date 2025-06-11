//
//  AddQuestionScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 9.06.2025.
//

import UIKit
import Foundation
import Lottie

final class AddQuestionScreenViewController: UIViewController{
    
    @IBOutlet var backButton: CustomBackButtonView!
    var viewModel: AddQuestionScreenViewModel!
    @IBOutlet var courseName: UILabel!
    @IBOutlet var courseLevelName: UILabel!
    @IBOutlet var tableView: UITableView!

    var sections: [TestSection] {
        return viewModel.sections
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        self.showLottieLoading()
        setupUI()
        setupTableView()
        setupTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchCourseLessons()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func backButtonTapped(){
        print("back button tapped")
        navigationController?.popViewController(animated: true)
    }
    
}

private extension AddQuestionScreenViewController {
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
                    if let courseName = self?.viewModel.courseClasses[0].courseName {
                        self?.courseName.text = "\(courseName) Class"
                    }
                    if let level = self?.viewModel.courseLevelName {
                        let levelText = self?.viewModel.levelTextForString(for: level) ?? "-"
                        
                        let fullText = "Current Level = \(levelText)"
                        let attributedText = NSMutableAttributedString(string: fullText)
                        
                        let range = (fullText as NSString).range(of: levelText)
                        attributedText.addAttribute(.foregroundColor, value: UIColor.summer, range: range)

                        self?.courseLevelName.attributedText = attributedText
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
extension AddQuestionScreenViewController: UITableViewDataSource, UITableViewDelegate {

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
        let checkImage = lesson.isCompleted! ? "checkmark.circle.fill" : "checkmark.circle"
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
        let lessonId = sections[indexPath.section].tests[indexPath.row].id
        print(lessonId)
        switch self.viewModel.courseClasses[0].courseName {
        case "Writing":
            let coordinator = WritingScreenCoordinator.getInstance()
            let viewModel = WritingScreenViewModel(coordinator: coordinator, lessonId: lessonId)
            coordinator.start(with: viewModel)
            ApplicationCoordinator.getInstance().pushFromTabBarCoordinatorAndVariables(coordinator, hidesBottomBar: true)
        case "Listening":
            let coordinator = ListeningScreenCoordinator.getInstance()
            let viewModel = ListeningScreenViewModel(coordinator: coordinator, lessonId: lessonId)
            coordinator.start(with: viewModel)
            ApplicationCoordinator.getInstance().pushFromTabBarCoordinatorAndVariables(coordinator, hidesBottomBar: true)
        case "Reading":
            let coordinator = ReadingScreenCoordinator.getInstance()
            let viewModel = ReadingScreenViewModel(coordinator: coordinator, lessonId: lessonId)
            coordinator.start(with: viewModel)
            ApplicationCoordinator.getInstance().pushFromTabBarCoordinatorAndVariables(coordinator, hidesBottomBar: true)
        case "Speaking":
            let coordinator = SpeakingScreenCoordinator.getInstance()
            let viewModel = SpeakingScreenViewModel(coordinator: coordinator, lessonId: lessonId)
            coordinator.start(with: viewModel)
            ApplicationCoordinator.getInstance().pushFromTabBarCoordinatorAndVariables(coordinator, hidesBottomBar: true)
        default:
                break
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.estimatedSectionHeaderHeight
    }
}

// MARK: - Gesture Handling
extension AddQuestionScreenViewController: UIGestureRecognizerDelegate {
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



