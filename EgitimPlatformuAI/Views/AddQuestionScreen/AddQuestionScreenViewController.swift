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
    @IBOutlet var backButton: CustomBackButtonView!
    @IBOutlet var courseName: UILabel!
    @IBOutlet var tableView: UITableView!
    var lessonId: String!
    var courseId: String!
    var classIds: [String]!
    var courseClasses: [CourseClass]!
    var selectedCourseName: String!
    @IBOutlet var addQuestionButton: UIButton!
    @IBOutlet var editQuestionButton: UIButton!
    @IBOutlet var deleteLessonButton: UIButton!
    var selectedIndexPath: IndexPath?
    private let refreshControl = UIRefreshControl()
    
    var sections: [TestSection] {
        return viewModel.sections
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupTapGesture()
        setupRefreshControl()
        setNotification()
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchCourseLessons()
    }
    private func setNotification(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleQuestionScreenDismissed),
            name: .questionScreenDismissed,
            object: nil
        )
    }
    
    @IBAction func addLessonButtonTapped(_ sender: Any) {
        let coordinator = NewLessonScreenCoordinator.getInstance()
        let viewModel = NewLessonScreenViewModel(coordinator: coordinator, courseClasses: courseClasses)
        coordinator.start(with: viewModel)
        ApplicationCoordinator.getInstance().pushFromTeacherScreenCoordinatorAndVariables(coordinator, hidesBottomBar: true)
    }
    
    @IBAction func addQuestionButtonTapped(_ sender: Any) {
        let coordinator = NewQuestionScreenCoordinator.getInstance()
        let viewModel = NewQuestionScreenViewModel(coordinator: coordinator, selectedLessonId: lessonId, selecteCourseName: selectedCourseName, isUpdate: false)
        coordinator.start(with: viewModel)
        ApplicationCoordinator.getInstance().pushFromTeacherScreenCoordinatorAndVariables(coordinator, hidesBottomBar: true)
    }
    
    
    @IBAction func deleteLessonButtonTapped(_ sender: Any) {
        self.showAlertWithAction(
            title: "Delete Lesson",
            message: "Are you sure you want to delete this lesson? This action cannot be undone."
        ){ [weak self] in
            guard let lessonId = self?.lessonId else { return }
            self?.viewModel.deleteLesson(lessonId: lessonId) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self?.fetchCourseLessons()
                        self?.tableView.reloadData()
                        
                    case .failure(_):
                        self?.showAlert(title: "Error", message: "There was an error deleting the lesson", lottieName: "error")
                    }
                }
            }
        }
        
    }
    
    
    @IBAction func editQuestionButtonTapped(_ sender: Any) {
        let coordinator = NewQuestionScreenCoordinator.getInstance()
        let viewModel = NewQuestionScreenViewModel(coordinator: coordinator, selectedLessonId: lessonId, selecteCourseName: selectedCourseName, isUpdate: true)
        coordinator.start(with: viewModel)
        ApplicationCoordinator.getInstance().pushFromTeacherScreenCoordinatorAndVariables(coordinator, hidesBottomBar: true)
    }
    
    @objc func handleQuestionScreenDismissed() {
        fetchCourseLessons()
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .questionScreenDismissed, object: nil)
        
    }
    
}

private extension AddQuestionScreenViewController {
    func setupUI() {
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        courseName.layer.borderWidth = 1
        courseName.layer.borderColor = UIColor.black.cgColor
        courseName.layer.masksToBounds = true
        addQuestionButton.isEnabled = false
        editQuestionButton.isEnabled = false
        deleteLessonButton.isEnabled = false
        
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
                switch result {
                case .success:
                    self?.refreshControl.endRefreshing()
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
                    self?.courseClasses = self?.viewModel.courseClasses
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription, lottieName: "error")
                }
            }
        }
    }
    
    private func setupRefreshControl() {
        refreshControl.tintColor = .summer
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    @objc private func refreshData() {
        fetchCourseLessons()
    }
    
    @objc private func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
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
            cell.contentView.backgroundColor = UIColor.darkBlue
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
        header.imageView.isHidden = true
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        addQuestionButton.isEnabled = true
        let questionCount = sections[indexPath.section].tests[indexPath.row].questionCount
        if questionCount == 0 {
            editQuestionButton.isEnabled = false
        }else {
            editQuestionButton.isEnabled = true
        }
        deleteLessonButton.isEnabled = true
        self.lessonId = sections[indexPath.section].tests[indexPath.row].id
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



