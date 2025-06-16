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
    
    var viewModel: AddQuestionScreenViewModel!
    @IBOutlet var courseName: UILabel!
    @IBOutlet var tableView: UITableView!
    var lessonId: String!
    var courseId: String!
    var classIds: [String]!
    var selectedCourseName: String!
    @IBOutlet var addQuestionButton: UIButton!
    var selectedIndexPath: IndexPath?
    
    var sections: [TestSection] {
        return viewModel.sections
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupTapGesture()
        self.navigationController?.isNavigationBarHidden = false
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleQuestionScreenDismissed),
                name: .questionScreenDismissed,
                object: nil
            )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchCourseLessons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchCourseLessons()
    }
    
    @IBAction func addLessonButtonTapped(_ sender: Any) {
        let coordinator = NewLessonScreenCoordinator.getInstance()
        let viewModel = NewLessonScreenViewModel(coordinator: coordinator, classIds: classIds)
        coordinator.start(with: viewModel)
        ApplicationCoordinator.getInstance().pushFromTeacherScreenCoordinatorAndVariables(coordinator, hidesBottomBar: true)
    }
    
    @IBAction func addQuestionButtonTapped(_ sender: Any) {
        print(selectedCourseName!)
        let coordinator = NewQuestionScreenCoordinator.getInstance()
        let viewModel = NewQuestionScreenViewModel(coordinator: coordinator, selectedLessonId: lessonId, selecteCourseName: selectedCourseName)
        coordinator.start(with: viewModel)
        ApplicationCoordinator.getInstance().pushFromTeacherScreenCoordinatorAndVariables(coordinator, hidesBottomBar: true)
    }

    @objc func handleQuestionScreenDismissed() {
        self.showLottieLoading()
        fetchCourseLessons()
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .questionScreenDismissed, object: nil)
    }

}

private extension AddQuestionScreenViewController {
    func setupUI() {
        courseName.layer.borderWidth = 1
        courseName.layer.borderColor = UIColor.black.cgColor
        courseName.layer.masksToBounds = true
        addQuestionButton.isEnabled = false
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
        viewModel.loadCourseLessons(teacherId: userID) { [weak self] result in
            DispatchQueue.main.async {
                self?.hideLottieLoading()
                switch result {
                case .success:
                    if let courseName = self?.viewModel.courseClasses[0].courseName {
                        self?.courseName.text = "\(courseName) Class"
                        print(courseName)
                        self?.selectedCourseName = courseName
                    }
                    if let courseId = self?.viewModel.courseClasses[0].courseId {
                        print(courseId)
                        self?.courseId = courseId
                        self?.viewModel.courseId = courseId
                        self?.classIds = self?.viewModel.allClassIds ?? []
                    }
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription, lottieName: "error")
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
        if indexPath == selectedIndexPath {
            cell.contentView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        } else {
            cell.contentView.backgroundColor = .charcoal
        }
        let lesson = sections[indexPath.section].tests[indexPath.row]
        cell.levelName.text = lesson.content
        cell.checkImage.isHidden = true
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
        header.imageView.isHidden = true // açılır kapanır gerek yok artık
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        addQuestionButton.titleLabel?.text = "Add Question"
        addQuestionButton.isEnabled = true
        self.lessonId = sections[indexPath.section].tests[indexPath.row].id
        let selectedLessonId = sections[indexPath.section].tests[indexPath.row].id
        viewModel.selectedLessonId = selectedLessonId
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
        tableView.reloadData()
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



