//
//  ProfileScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 16.01.2025.
//

import UIKit
class ProfileScreenViewController: UIViewController {
    
    var viewModel: ProfileScreenViewModel?
    private var hamburgerMenuManager: HamburgerMenuManager!
    var student: Student?
    var coursesClassName: [String] = []
    var lessonCount: [Int] = []
    var coursesName: [String] = []
    var level: [Int] = []
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var surnameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        hamburgerMenuManager = HamburgerMenuManager(viewController: self)
        hamburgerMenuManager.setNavigationBar()
        loadStudentData()
        loadCourseData()
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = .clear
        self.navigationController?.navigationBar.standardAppearance.backgroundEffect = .none
        self.navigationController?.navigationBar.standardAppearance.shadowColor = .clear
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func loadStudentData() {
        let userID = UserDefaults.standard.string(forKey: "userID") ?? "Unknown"
        
        viewModel?.loadStudent(studentId: userID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    guard let student = self?.viewModel?.student else { return }
                    self?.student = student
                    self?.setupUserDetails()
                    self?.loadProfileImage()
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
        
    }
    
    func loadCourseData() {
        let userID = UserDefaults.standard.string(forKey: "userID") ?? "Unknown"
        
        viewModel?.loadCourseClasses(studentId: userID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    guard let classes = self?.viewModel?.courseClasses else { return }
                    self?.coursesClassName = classes.map { $0.name }
                    self?.lessonCount = classes.map { $0.lessons.count }
                    self?.coursesName = classes.map { $0.courseName }
                    self?.level = classes.map { $0.level }
                    self?.setupTableView()
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    func loadProfileImage() {
        viewModel?.fetchProfileImage { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let imageData):
                    self?.profileImageView.image = UIImage(data: imageData)
                case .failure:
                    self?.profileImageView.image = UIImage(named: "defaultAvatar")
                }
            }
        }
    }
    
    func setupTableView(){
        let cellNib = UINib(nibName: "LessonInfoTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "LessonInfoCell")
    }
    
    func setupUserDetails() {
        nameLabel.text = student?.name ?? "-"
        surnameLabel.text = student?.surname ?? "-"
        emailLabel.text = student?.email ?? "-"
    }
    
    
    
}

extension ProfileScreenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coursesClassName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LessonInfoCell", for: indexPath) as? LessonInfoTableViewCell else {
            return UITableViewCell()
        }
        
        let courseName = coursesClassName[indexPath.row]
        let levelText = formattedLevel(level[indexPath.row])
        
        cell.lessonNameLabel.text = courseName
        cell.lessonLevelLabel.text = levelText
        
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
}


extension ProfileScreenViewController: UITableViewDelegate{
    
}
