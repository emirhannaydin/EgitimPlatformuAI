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

    @IBOutlet var backButton: CustomBackButtonView!
    @IBOutlet var courseLevelName: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var courseName: UILabel!
    private let refreshControl = UIRefreshControl()
    var sections: [TestSection] {
        return viewModel.sections
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLottieLoading()
        setupUI()
        setupTableView()
        setupTapGesture()
        setupRefreshControl()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLottieLoading()
        fetchCourseLessons()
    }
}

// MARK: - Setup Methods
private extension CourseScreenViewController {
    func setupUI() {
        courseName.layer.borderWidth = 1
        courseName.layer.borderColor = UIColor.black.cgColor
        courseName.layer.masksToBounds = true
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
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
                    self?.refreshControl.endRefreshing()
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
                    self?.showAlert(title: "Error", message: error.localizedDescription, lottieName: "error")
                }
            }
        }
    }
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupRefreshControl() {
        refreshControl.tintColor = .summer
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    @objc private func refreshData() {
        fetchCourseLessons()
    }
}

// MARK: - TableView DataSource & Delegate
extension CourseScreenViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].isExpanded ? sections[section].tests.count : 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseScreenTableViewCell.identifier, for: indexPath) as! CourseScreenTableViewCell
        let lesson = sections[indexPath.section].tests[indexPath.row]
        cell.levelName.text = lesson.content
        let checkImage = lesson.isCompleted! ? "checkmark.circle.fill" : "checkmark.circle"
        cell.checkImage.image = UIImage(systemName: checkImage)
        let questionCount = lesson.questionCount
        cell.questionNumber.text = "\(questionCount ?? 0) Question"
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CourseScreenHeaderFooterView.identifier) as? CourseScreenHeaderFooterView else {
            return nil
        }
        header.titleLabel.text = sections[section].title
        header.tag = section
        header.imageView.image = UIImage(systemName: "chevron.down")
        header.imageView.transform = sections[section].isExpanded ? .identity : CGAffineTransform(rotationAngle: -.pi / 2)


        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleSection(_:)))
        header.addGestureRecognizer(tapGesture)
        
        return header
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSection = sections[indexPath.section]
        let selectedLesson = selectedSection.tests[indexPath.row]
        let userLevel = Int(viewModel.courseLevelName) ?? 0

        if selectedSection.level > userLevel {
            showAlert(
                title: "Access Denied",
                message: "You cannot access level \(viewModel.levelTextForInt(for: selectedSection.level)) before completing your current level.",
                lottieName: "error"
            )
            return
        }

        let previousLessons = selectedSection.tests[..<indexPath.row]
        if let incompleteLesson = previousLessons.first(where: { $0.isCompleted != true }) {
            showAlert(
                title: "Access Denied",
                message: "Please complete the previous lesson first: \(incompleteLesson.content)",
                lottieName: "error"
            )
            return
        }

        let lessonId = selectedLesson.id
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
    
    @objc private func toggleSection(_ gesture: UITapGestureRecognizer) {
        guard let headerView = gesture.view else { return }
        let section = headerView.tag
        viewModel.sections[section].isExpanded.toggle()

        if let header = tableView.headerView(forSection: section) as? CourseScreenHeaderFooterView {
            UIView.animate(withDuration: 0.3) {
                let isExpanded = self.viewModel.sections[section].isExpanded
                header.imageView.transform = isExpanded ? .identity : CGAffineTransform(rotationAngle: -.pi / 2)
            }
        }

        tableView.beginUpdates()
        tableView.reloadSections([section], with: .automatic)
        tableView.endUpdates()
    }


}
