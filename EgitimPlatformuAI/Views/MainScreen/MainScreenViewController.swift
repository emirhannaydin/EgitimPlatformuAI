//
//  ViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 16.01.2025.
//
import UIKit
import Lottie

final class MainScreenViewController: UIViewController{
    
    @IBOutlet var nameContainerView: CustomNameContainer!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionView2: UICollectionView!
    
    @IBOutlet var readingBook: UIButton!
    private var hamburgerMenuManager: HamburgerMenuManager!
    var viewModel: MainScreenViewModel?

    var screenLogo: [String] = ["house", "person.circle", "book", "lock", "lock"]
    var coursesClassName: [String] = []
    var coursesName: [String] = []
    let courseAnimationMap: [String: String] = [
        "Writing": "writing",
        "Speaking": "speaking",
        "Listening": "listening",
        "Reading": "reading"]
    var lessonCount: [Int] = []
    var progressCount: [Int] = []
    var level: [Int] = []
    var levelName: String?
    var levelColor: UIColor = .summer
    
    let username = UserDefaults.standard.string(forKey: "username") ?? "Unknown"
    let userID = UserDefaults.standard.string(forKey: "userID") ?? "Unknown"
    let userType = UserDefaults.standard.integer(forKey: "userType")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        print(userType)
        self.showLottieLoading()
        setupHamburgerMenu()
        setupCollectionViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCourseData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    @IBAction func handleReadingBookButton(_ sender: Any) {
        ApplicationCoordinator.getInstance().pushFromTabBarCoordinator(ReadingBookCoordinator.self, hidesBottomBar: true)
    }
    
    @IBAction func handleWordPuzzleButton(_ sender: Any) {
        ApplicationCoordinator.getInstance().pushFromTabBarCoordinator(WordPuzzleCoordinator.self, hidesBottomBar: true)
    }
}

// MARK: - Setup
private extension MainScreenViewController {
    func setupHamburgerMenu() {
        hamburgerMenuManager = HamburgerMenuManager(viewController: self)
        hamburgerMenuManager.setNavigationBar()
    }

    func configureNameContainer() {
        nameContainerView.hamburgerMenuManager = hamburgerMenuManager
        navigationController?.navigationBar.isHidden = true
        if let _levelName = levelName{
            UserDefaults.standard.set(_levelName, forKey: "tagName")
            nameContainerView.configureView(
                nameText: "\(username.capitalizingFirstLetter()) • \(_levelName)",
                welcomeLabelText: "Welcome",
                imageName: "person.fill",
                levelName: _levelName,
                levelColor: levelColor
            )
        }

        nameContainerView.onLogoutTapped = { [weak self] in
            self?.showAlertWithAction(title: "Logout", message: "Are you sure you want to log out?") {
                KeychainHelper.shared.delete(service: "access-token", account: "user")
                    
                UserDefaults.standard.removeObject(forKey: "userID")
                UserDefaults.standard.removeObject(forKey: "username")
                UserDefaults.standard.removeObject(forKey: "userType")

                ApplicationCoordinator.getInstance().start()
            }
        }
    }

    func setupCollectionViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.tag = 1
        collectionView.register(HomeScreenCollectionViewCell.nib(), forCellWithReuseIdentifier: HomeScreenCollectionViewCell.identifier)

        collectionView2.delegate = self
        collectionView2.dataSource = self
        collectionView2.register(HomeScreenCourseCollectionViewCell.nib(), forCellWithReuseIdentifier: HomeScreenCourseCollectionViewCell.identifier)
    }

    func loadCourseData() {

        viewModel?.loadCourseClasses(studentId: userID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    guard let classes = self?.viewModel?.courseClasses else { return }
                    self?.coursesClassName = classes.map { $0.name }
                    self?.lessonCount = classes.map { $0.lessons.count }
                    self?.progressCount = classes.map { course in
                        course.lessons.filter { $0.isCompleted == true }.count
                    }
                    self?.level = classes.map { $0.level }
                    self?.updateUserLevelTitleAndColor()
                    self?.configureNameContainer()

                    self?.coursesName = classes.map { $0.courseName }
                    self?.collectionView.reloadData()
                    self?.collectionView2.reloadData()
                    self?.hideLottieLoading()
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription, lottieName: "error")
                    self?.hideLottieLoading()
                }
            }
        }
    }
    
    func updateUserLevelTitleAndColor() {
        let levelTitles: [(range: ClosedRange<Int>, title: String, color: UIColor)] = [
            (0...3, "Novice", UIColor.systemGray),
            (4...6, "Apprentice", UIColor.systemBlue),
            (7...9, "Adept", UIColor.systemTeal),
            (10...12, "Champion", UIColor.systemGreen),
            (13...15, "Elite", UIColor.systemOrange),
            (16...17, "Master", UIColor.systemPurple),
            (18...19, "Grandmaster", UIColor.systemPink),
            (20...20, "Legendary Linguist", UIColor.systemYellow)
        ]


        let totalScore = level.reduce(0, +)

        for (range, title, color) in levelTitles {
            if range.contains(totalScore) {
                levelName = title
                levelColor = color
                break
            }
        }
    }

}

// MARK: - Collection View
extension MainScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coursesClassName.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            return configureClassCell(at: indexPath)
        } else {
            return configureCourseCell(at: indexPath)
        }
    }

    func configureClassCell(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeScreenCollectionViewCell.identifier, for: indexPath) as! HomeScreenCollectionViewCell
        cell.courseName.text = coursesClassName[indexPath.row]
        cell.lessonLabel.text = "\(lessonCount[indexPath.row]) Lessons"
        cell.progressView.value = CGFloat(progressCount[indexPath.row])
        cell.progressView.maxValue = CGFloat(lessonCount[indexPath.row])
        cell.levelLabel.text = formattedLevel(level[indexPath.row])
        let formatted = String(format: "%g", cell.progressView.maxValue)
        cell.progressView.unitString = " / \(formatted)"
        
        if cell.progressView.value == cell.progressView.maxValue {
            cell.progressView.isHidden = true
            cell.completedLessonLabel.isHidden = false
        }else{
            cell.progressView.isHidden = false
            cell.completedLessonLabel.isHidden = true
        }
        styleClassCell(cell)
        return cell
    }

    func configureCourseCell(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView2.dequeueReusableCell(withReuseIdentifier: HomeScreenCourseCollectionViewCell.identifier, for: indexPath) as! HomeScreenCourseCollectionViewCell
        
        let courseName = coursesName[indexPath.row]
        cell.courseNameLabel.text = courseName

        if let animationName = courseAnimationMap[courseName] {
            let animation = LottieAnimation.named(animationName)
            cell.lottieView.animation = animation
            cell.lottieView.contentMode = .scaleAspectFill
            cell.lottieView.loopMode = .loop
            cell.lottieView.play()
        }
        styleCourseCell(cell)
        return cell
    }


    func formattedLevel(_ level: Int) -> String {
        switch level {
        case 0: return " - A1"
        case 1: return " - A2"
        case 2: return " - B1"
        case 3: return " - B2"
        case 4: return " - C1"
        case 5: return " - C2"

        default: return " - "
        }
    }

    func styleClassCell(_ cell: HomeScreenCollectionViewCell) {
        switch cell.courseName.text {
        case "Reading Class":
            cell.backgroundColor = .silver
            cell.courseName.textColor = .black
            cell.levelLabel.textColor = .black
            cell.lessonLabel.textColor = .black
        case "Listening Class":
            cell.backgroundColor = .sapphireBlue
            cell.courseName.textColor = .porcelain
        case "Writing Class":
            cell.backgroundColor = .softRed
            cell.courseName.textColor = .winter
        case "Speaking Class":
            cell.backgroundColor = .mintGreen
            cell.courseName.textColor = .coldPurple
        default:
            break
        }
    }

    func styleCourseCell(_ cell: HomeScreenCourseCollectionViewCell) {
        switch cell.courseNameLabel.text {
        case "Reading":
            cell.courseNameLabel.textColor = .black
            cell.enrollLabel.textColor = .black
            cell.backgroundColor = .silver
        case "Listening":
            cell.courseNameLabel.textColor = .porcelain
            cell.backgroundColor = .sapphireBlue
        case "Writing":
            cell.courseNameLabel.textColor = .winter
            cell.backgroundColor = .softRed
        case "Speaking":
            cell.courseNameLabel.textColor = .coldPurple
            cell.enrollLabel.textColor = .white
            cell.backgroundColor = .mintGreen
        default:
            break
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCourse = viewModel!.courseClasses[indexPath.row]
        let courseId = selectedCourse.courseId

        if collectionView.tag == 1 {
            if let nextLesson = selectedCourse.lessons
                .filter({ $0.isCompleted == false })
                .sorted(by: { $0.order < $1.order })
                .first
            {
                if selectedCourse.courseName == "Reading" {
                    let coordinator = ReadingScreenCoordinator.getInstance()
                    let viewModel = ReadingScreenViewModel(coordinator: coordinator, lessonId: nextLesson.id)
                    coordinator.start(with: viewModel)
                    ApplicationCoordinator.getInstance().pushFromTabBarCoordinatorAndVariables(coordinator, hidesBottomBar: true)
                }else if selectedCourse.courseName == "Writing" {
                    let coordinator = WritingScreenCoordinator.getInstance()
                    let viewModel = WritingScreenViewModel(coordinator: coordinator, lessonId: nextLesson.id)
                    coordinator.start(with: viewModel)
                    ApplicationCoordinator.getInstance().pushFromTabBarCoordinatorAndVariables(coordinator, hidesBottomBar: true)
                }else if selectedCourse.courseName == "Speaking" {
                    let coordinator = SpeakingScreenCoordinator.getInstance()
                    let viewModel = SpeakingScreenViewModel(coordinator: coordinator, lessonId: nextLesson.id)
                    coordinator.start(with: viewModel)
                    ApplicationCoordinator.getInstance().pushFromTabBarCoordinatorAndVariables(coordinator, hidesBottomBar: true)
                }else if selectedCourse.courseName == "Listening"{
                    let coordinator = ListeningScreenCoordinator.getInstance()
                    let viewModel = ListeningScreenViewModel(coordinator: coordinator, lessonId: nextLesson.id)
                    coordinator.start(with: viewModel)
                    ApplicationCoordinator.getInstance().pushFromTabBarCoordinatorAndVariables(coordinator, hidesBottomBar: true)
                }else{
                    let coordinator = CourseScreenCoordinator.getInstance()
                    let viewModel = CourseScreenViewModel(
                        coordinator: coordinator,
                        courseLevelName: "\(selectedCourse.level)",
                        courseId: courseId
                    )
                    
                    ApplicationCoordinator.getInstance().handleCourseEntry(with: viewModel)
                }
                
            }
        } else {
            let coordinator = CourseScreenCoordinator.getInstance()
            let viewModel = CourseScreenViewModel(
                coordinator: coordinator,
                courseLevelName: "\(selectedCourse.level)",
                courseId: courseId
            )
            
            ApplicationCoordinator.getInstance().handleCourseEntry(with: viewModel)
        }
        
        
        
    }
}




    
