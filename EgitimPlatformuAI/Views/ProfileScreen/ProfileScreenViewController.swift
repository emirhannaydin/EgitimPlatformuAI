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
    var level: [Int] = []
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var surnameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var signOutButton: UIButton!
    
    @IBOutlet var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        hamburgerMenuManager = HamburgerMenuManager(viewController: self)
        hamburgerMenuManager.setNavigationBar()
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = .clear
        self.navigationController?.navigationBar.standardAppearance.backgroundEffect = .none
        self.navigationController?.navigationBar.standardAppearance.shadowColor = .clear
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.showLottieLoading()
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadStudentData()
        loadCourseData()
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        self.showAlertWithAction(title: "Logout", message: "Are you sure you want to log out?") {
            KeychainHelper.shared.delete(service: "access-token", account: "user")
            
            UserDefaults.standard.removeObject(forKey: "userID")
            UserDefaults.standard.removeObject(forKey: "username")
            UserDefaults.standard.removeObject(forKey: "userType")
            
            
            ApplicationCoordinator.getInstance().start()
        }
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
                    self?.showAlert(title: "Error", message: error.localizedDescription, lottieName: "error")
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
        let tagName = UserDefaults.standard.string(forKey: "tagName") ?? "-"
        nameLabel.text = student?.name ?? "-"
        surnameLabel.text = tagName
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


extension ProfileScreenViewController: UITableViewDelegate{
    
}
