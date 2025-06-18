//
//  StudentsScreenInfoViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 16.06.2025.
//

import UIKit
import Foundation

final class StudentsScreenInfoViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    var student: Student?
    var coursesClassName: [String] = []
    var level: [Int] = []
    
    var viewModel: StudentsScreenInfoViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.layer.cornerRadius = 8
        nameLabel.layer.masksToBounds = true
        emailLabel.layer.cornerRadius = 8
        emailLabel.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadStudentData()
        loadCourseData()
        
        if let presentingVC = presentingViewController {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
                tapGesture.cancelsTouchesInView = false
                presentingVC.view.addGestureRecognizer(tapGesture)
            }
    }
    
    private func loadStudentData() {
        if let userID = viewModel.studentId{
            viewModel?.loadStudent(studentId: userID) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        guard let student = self?.viewModel?.student else { return }
                        self?.student = student
                        self?.setupUserDetails()
                    case .failure(let error):
                        self?.showAlert(title: "Error", message: error.localizedDescription, lottieName: "error")
                    }
                }
            }
        }
        
    }
    
    private func loadCourseData() {
        if let userID = viewModel.studentId{
            viewModel?.loadCourseClasses(studentId: userID) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        guard let classes = self?.viewModel?.courseClasses else { return }
                        self?.coursesClassName = classes.map { $0.name }
                        self?.level = classes.map { $0.level }
                        self?.setupTableView()
                        self?.tableView.reloadData()
                        self?.hideLottieLoading()

                    case .failure(let error):
                        self?.hideLottieLoading()
                        self?.showAlert(title: "Error", message: error.localizedDescription, lottieName: "error")
                    }
                }
            }
        }
    }
    
    func setupTableView(){
        let cellNib = UINib(nibName: "LessonInfoTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "LessonInfoCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupUserDetails() {
        nameLabel.text = "Name: \(student?.name ?? "-")"
        emailLabel.text = "Email: \(student?.email ?? "-")"
    }
    
    @objc func handleBackgroundTap() {
        self.dismiss(animated: true)
    }
    
}

extension StudentsScreenInfoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coursesClassName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LessonInfoCell", for: indexPath) as? LessonInfoTableViewCell else {
            return UITableViewCell()
        }
        cell.progressBar.progress = 0
        let courseName = coursesClassName[indexPath.row]
        let levelText = formattedLevel(level[indexPath.row])

        cell.lessonNameLabel.text = "\(courseName):"
        cell.lessonLevelLabel.text = "\(levelText)"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            cell.progressBar.setProgress(self.formattedProgress(self.level[indexPath.row]), animated: true)
            }

        switch cell.lessonNameLabel.text {
        case "Reading Class:":
            cell.backView.backgroundColor = .silver
            cell.lessonNameLabel.textColor = .backDarkBlue
            cell.lessonLevelLabel.textColor = .backDarkBlue
        case "Listening Class:":
            cell.backView.backgroundColor = .sapphireBlue
            cell.lessonNameLabel.textColor = .porcelain
            cell.lessonLevelLabel.textColor = .porcelain
        case "Writing Class:":
            cell.backView.backgroundColor = .softRed
            cell.lessonNameLabel.textColor = .winter
            cell.lessonLevelLabel.textColor = .winter
        case "Speaking Class:":
            cell.backView.backgroundColor = .mintGreen
            cell.lessonNameLabel.textColor = .coldPurple
            cell.lessonLevelLabel.textColor = .coldPurple
        default:
            break
        }

        return cell
    }
    
    private func formattedLevel(_ level: Int) -> String {
        switch level {
        case 0: return "A1"
        case 1: return "A2"
        case 2: return "B1"
        case 3: return "B2"
        case 4: return "C1"
        case 5: return "C2"
        default: return "-"
        }
    }
    
    private func formattedProgress(_ level: Int) -> Float {
        switch level {
        case 0: return 0.16
        case 1: return 0.32
        case 2: return 0.48
        case 3: return 0.65
        case 4: return 0.81
        case 5: return 1
        default: return 0
        }
    }
}


