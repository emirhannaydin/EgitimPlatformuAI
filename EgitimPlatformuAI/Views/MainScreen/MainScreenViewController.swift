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
    var coursesName: [String] = ["Reading Course", "Listening Course", "Writing Course", "Speaking Course"]
    var lottieAnimations: [String] = ["reading", "listening", "writing", "speaking"]
    var lessonCount: [Int] = [10,20,30,40]
    var progressCount: [Int] = [3,8,15,20]
    var cellBackgroundColor: [UIColor] = [.silver, .sapphireBlue, .darkBlue, .mintGreen]
    
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
        nameContainerView.configureView(nameText: username.capitalizingFirstLetter(), statusText: "Online", imageName: "person.fill")

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
        
        return coursesName.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeScreenCollectionViewCell.identifier, for: indexPath) as! HomeScreenCollectionViewCell
            cell.courseName.text = coursesName[indexPath.row]
            cell.lessonLabel.text = "\(lessonCount[indexPath.row]) Lessons"
            cell.progressView.value = CGFloat(progressCount[indexPath.row])
            cell.progressView.maxValue = CGFloat(lessonCount[indexPath.row])
            let formatted = String(format: "%g", cell.progressView.maxValue)
            cell.progressView.unitString = " / \(formatted)"
            cell.backgroundColor = cellBackgroundColor[indexPath.row]
            if cell.courseName.text == "Reading Course"{
                cell.progressView.progressColor = .darkBlue
                cell.progressView.progressStrokeColor = .darkBlue
                cell.progressView.fontColor = .darkBlue
                cell.lessonLabel.textColor = .black
                cell.levelLabel.textColor = .black
                cell.courseName.textColor = .black
            }else if cell.courseName.text == "Listening Course"{
                cell.courseName.textColor = .porcelain
                cell.progressView.progressColor = .porcelain
                cell.progressView.progressStrokeColor = .porcelain
                cell.progressView.fontColor = .white
            }else if cell.courseName.text == "Writing Course"{
                cell.courseName.textColor = .winter
                cell.progressView.progressColor = .winter
                cell.progressView.progressStrokeColor = .winter
                cell.progressView.fontColor = .white
            }else if cell.courseName.text == "Speaking Course"{
                cell.courseName.textColor = .coldPurple
                cell.progressView.progressColor = .coldPurple
                cell.progressView.progressStrokeColor = .coldPurple
                cell.progressView.fontColor = .white
            }
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeScreenCourseCollectionViewCell.identifier, for: indexPath) as! HomeScreenCourseCollectionViewCell
            cell.backgroundColor = cellBackgroundColor[indexPath.row]
            cell.courseNameLabel.text = coursesName[indexPath.row]
            
            let animation = LottieAnimation.named(lottieAnimations[indexPath.row])
            cell.lottieView.animation = animation
            cell.lottieView.contentMode = .scaleAspectFill
            cell.lottieView.loopMode = .loop
            cell.lottieView.play()
            
            if cell.courseNameLabel.text == "Reading Course"{
                cell.enrollLabel.textColor = .black
                cell.courseNameLabel.textColor = .black
            }else if cell.courseNameLabel.text == "Listening Course"{
                cell.courseNameLabel.textColor = .porcelain
            }else if cell.courseNameLabel.text == "Writing Course"{
                cell.courseNameLabel.textColor = .winter
            }else if cell.courseNameLabel.text == "Speaking Course"{
                cell.courseNameLabel.textColor = .coldPurple
                cell.enrollLabel.textColor = .white
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let coordinator = CourseScreenCoordinator.getInstance()
        
        switch indexPath.row {
        case 0:
            ApplicationCoordinator.getInstance().handleCourseEntry(.reading)
        case 1:
            ApplicationCoordinator.getInstance().handleCourseEntry(.listening)
        case 2:
            ApplicationCoordinator.getInstance().handleCourseEntry(.writing)
        case 3:
            ApplicationCoordinator.getInstance().handleCourseEntry(.speaking)
        default:
            break
        }

        
    }
    
}




    
