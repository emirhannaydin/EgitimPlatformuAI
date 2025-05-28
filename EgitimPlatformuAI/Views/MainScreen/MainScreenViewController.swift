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
    var screenLogo: [String] = ["house", "person.circle", "book","lock","lock"]
    var coursesClassName: [String] = []
    var coursesName: [String] = []
    var lottieAnimations: [String] = ["writing", "speaking", "listening", "reading"]
    var lessonCount: [Int] = []
    var progressCount: [Int] = []
    var level: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        hamburgerMenuManager = HamburgerMenuManager(viewController: self)
        hamburgerMenuManager.setNavigationBar()
        setCollectionView()
        UserDefaults.standard.removeObject(forKey: "enrolled_reading")
        UserDefaults.standard.removeObject(forKey: "enrolled_listening")


        nameContainerView.hamburgerMenuManager = hamburgerMenuManager
        navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let username = UserDefaults.standard.string(forKey: "username") ?? "Unknown"
        let userID = UserDefaults.standard.string(forKey: "userID") ?? "Unknown"
        nameContainerView.configureView(nameText: username.capitalizingFirstLetter(), welcomeLabelText: userID, imageName: "person.fill")
        
        viewModel!.loadCourseClasses(studentId: userID) { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            if let coursesClasses = self?.viewModel?.courseClasses{
                                self?.coursesClassName = coursesClasses.map { $0.name }
                                self?.lessonCount = coursesClasses.map { $0.lessons.count }
                                self?.progressCount = coursesClasses.map { $0.completedLessonCount }
                                self?.level = coursesClasses.map { $0.level }
                                self?.coursesName = coursesClasses.map { $0.courseName ?? "asdad" }
                                self?.collectionView.reloadData()
                                self?.collectionView2.reloadData()
                            }
                            
                        case .failure(let error):
                            self?.showAlert(title: "Error", message: error.localizedDescription)
                        }
                    }
                }

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func setCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.tag = 1
        collectionView.register(HomeScreenCollectionViewCell.nib(), forCellWithReuseIdentifier: HomeScreenCollectionViewCell.identifier)
        
        collectionView2.delegate = self
        collectionView2.dataSource = self
        collectionView2.register(HomeScreenCourseCollectionViewCell.nib(), forCellWithReuseIdentifier: HomeScreenCourseCollectionViewCell.identifier)
    }
    
    
}

extension MainScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return coursesClassName.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeScreenCollectionViewCell.identifier, for: indexPath) as! HomeScreenCollectionViewCell
            cell.courseName.text = coursesClassName[indexPath.row]
            cell.lessonLabel.text = "\(lessonCount[indexPath.row]) Lessons"
            cell.progressView.value = CGFloat(progressCount[indexPath.row])
            cell.progressView.maxValue = CGFloat(lessonCount[indexPath.row])
            if level[indexPath.row] == 0{
                cell.levelLabel.text = " - A1"
            }else if level[indexPath.row] == 1{
                cell.levelLabel.text = " - B1"
            }else if level[indexPath.row] == 2{
                cell.levelLabel.text = " - B2"
            }else{
                cell.levelLabel.text = " - C1"
            }
            let formatted = String(format: "%g", cell.progressView.maxValue)
            cell.progressView.unitString = " / \(formatted)"
            if cell.courseName.text == "Reading Class"{
                cell.progressView.progressColor = .darkBlue
                cell.progressView.progressStrokeColor = .darkBlue
                cell.progressView.fontColor = .darkBlue
                cell.backgroundColor = .silver
                cell.lessonLabel.textColor = .black
                cell.levelLabel.textColor = .black
                cell.courseName.textColor = .black
            }else if cell.courseName.text == "Listening Class"{
                cell.courseName.textColor = .porcelain
                cell.progressView.progressColor = .porcelain
                cell.progressView.progressStrokeColor = .porcelain
                cell.progressView.fontColor = .white
                cell.backgroundColor = .sapphireBlue
            }else if cell.courseName.text == "Writing Class"{
                cell.courseName.textColor = .winter
                cell.backgroundColor = .softRed
                cell.progressView.progressColor = .winter
                cell.progressView.progressStrokeColor = .winter
                cell.progressView.fontColor = .white
            }else if cell.courseName.text == "Speaking Class"{
                cell.courseName.textColor = .coldPurple
                cell.backgroundColor = .mintGreen
                cell.progressView.progressColor = .coldPurple
                cell.progressView.progressStrokeColor = .coldPurple
                cell.progressView.fontColor = .white
            }
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeScreenCourseCollectionViewCell.identifier, for: indexPath) as! HomeScreenCourseCollectionViewCell
            cell.courseNameLabel.text = coursesName[indexPath.row]
            
            let animation = LottieAnimation.named(lottieAnimations[indexPath.row])
            cell.lottieView.animation = animation
            cell.lottieView.contentMode = .scaleAspectFill
            cell.lottieView.loopMode = .loop
            cell.lottieView.play()
            
            if cell.courseNameLabel.text == "Reading"{
                cell.enrollLabel.textColor = .black
                cell.courseNameLabel.textColor = .black
                cell.backgroundColor = .silver
            }else if cell.courseNameLabel.text == "Listening"{
                cell.courseNameLabel.textColor = .porcelain
                cell.backgroundColor = .sapphireBlue
            }else if cell.courseNameLabel.text == "Writing"{
                cell.courseNameLabel.textColor = .winter
                cell.backgroundColor = .softRed
            }else if cell.courseNameLabel.text == "Speaking"{
                cell.courseNameLabel.textColor = .coldPurple
                cell.enrollLabel.textColor = .white
                cell.backgroundColor = .mintGreen
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let coordinator = CourseScreenCoordinator.getInstance()
        
        let selectedCourse = viewModel!.courseClasses[indexPath.row]

        guard let rawCourseName = selectedCourse.courseName?.lowercased() else {
            print("courseName bulunamadı.")
            return
        }
        guard let courseId = selectedCourse.courseId else {
                print("courseId bulunamadı.")
                return
            }
        
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




    
