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
    
    private var hamburgerMenuManager: HamburgerMenuManager!
    var viewModel: MainScreenViewModel?

    var screenLogo: [String] = ["house", "person.circle", "book", "lock", "lock"]
    var coursesClassName: [String] = []
    var coursesName: [String] = []
    var lottieAnimations: [String] = ["writing", "speaking", "listening", "reading"]
    var lessonCount: [Int] = []
    var progressCount: [Int] = []
    var level: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        setupHamburgerMenu()
        setupCollectionViews()
        configureNameContainer()
        clearOldUserDefaults()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCourseData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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

    func clearOldUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "enrolled_reading")
        UserDefaults.standard.removeObject(forKey: "enrolled_listening")
    }

    func loadCourseData() {
        let username = UserDefaults.standard.string(forKey: "username") ?? "Unknown"
        let userID = UserDefaults.standard.string(forKey: "userID") ?? "Unknown"
        nameContainerView.configureView(nameText: username.capitalizingFirstLetter(), welcomeLabelText: userID, imageName: "person.fill")

        viewModel?.loadCourseClasses(studentId: userID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    guard let classes = self?.viewModel?.courseClasses else { return }
                    self?.coursesClassName = classes.map { $0.name }
                    self?.lessonCount = classes.map { $0.lessons.count }
                    self?.progressCount = classes.map { $0.completedLessonCount }
                    self?.level = classes.map { $0.level }
                    self?.coursesName = classes.map { $0.courseName ?? "Unknown" }
                    self?.collectionView.reloadData()
                    self?.collectionView2.reloadData()
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
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
        styleClassCell(cell)
        return cell
    }

    func configureCourseCell(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView2.dequeueReusableCell(withReuseIdentifier: HomeScreenCourseCollectionViewCell.identifier, for: indexPath) as! HomeScreenCourseCollectionViewCell
        cell.courseNameLabel.text = coursesName[indexPath.row]
        let animation = LottieAnimation.named(lottieAnimations[indexPath.row])
        cell.lottieView.animation = animation
        cell.lottieView.contentMode = .scaleAspectFill
        cell.lottieView.loopMode = .loop
        cell.lottieView.play()
        styleCourseCell(cell)
        return cell
    }

    func formattedLevel(_ level: Int) -> String {
        switch level {
        case 0: return " - A1"
        case 1: return " - B1"
        case 2: return " - B2"
        default: return " - C1"
        }
    }

    func styleClassCell(_ cell: HomeScreenCollectionViewCell) {
        switch cell.courseName.text {
        case "Reading Class":
            cell.progressView.progressColor = .darkBlue
            cell.backgroundColor = .silver
            cell.courseName.textColor = .black
            cell.levelLabel.textColor = .black
            cell.lessonLabel.textColor = .black
        case "Listening Class":
            cell.progressView.progressColor = .porcelain
            cell.backgroundColor = .sapphireBlue
            cell.courseName.textColor = .porcelain
        case "Writing Class":
            cell.progressView.progressColor = .winter
            cell.backgroundColor = .softRed
            cell.courseName.textColor = .winter
        case "Speaking Class":
            cell.progressView.progressColor = .coldPurple
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
        let coordinator = CourseScreenCoordinator.getInstance()
        let selectedCourse = viewModel!.courseClasses[indexPath.row]
        let rawCourseName = selectedCourse.courseName.lowercased()
        let courseId = selectedCourse.courseId

        let courseType: CourseType
        if rawCourseName.contains("writing") {
            courseType = .writing
        } else if rawCourseName.contains("speaking") {
            courseType = .speaking
        } else if rawCourseName.contains("listening") {
            courseType = .listening
        } else if rawCourseName.contains("reading") {
            courseType = .reading
        } else {
            print("Eşleşen courseType bulunamadı.")
            return
        }

        let viewModel = CourseScreenViewModel(
            coordinator: coordinator,
            courseType: courseType,
            courseLevelName: "\(selectedCourse.level)",
            courseId: courseId
        )

        ApplicationCoordinator.getInstance().handleCourseEntry(courseType, with: viewModel)
    }
}




    
