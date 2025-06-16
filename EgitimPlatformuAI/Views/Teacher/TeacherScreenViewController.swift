//
//  TeacherScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 3.06.2025.
//

import UIKit
import Foundation
import Lottie

final class TeacherScreenViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var nameContainerView: CustomNameContainer!
    @IBOutlet var uploadBookButton: UIButton!
    @IBOutlet var studentsButton: UIButton!
    var viewModel: TeacherScreenViewModel!
    let userID = UserDefaults.standard.string(forKey: "userID") ?? "Unknown"
    let username = UserDefaults.standard.string(forKey: "username") ?? "Unknown"

    let courseAnimationMap: [String: String] = [
        "Writing": "writing",
        "Speaking": "speaking",
        "Listening": "listening",
        "Reading": "reading"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.showLottieLoading()
        setNameContainer()
        setCollectionView()
        setButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        fetchCourses()
    }

    func fetchCourses() {
        viewModel?.getCourses { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.hideLottieLoading()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func setNameContainer() {
        nameContainerView.configureView(
            nameText: username.capitalizingFirstLetter(),
            welcomeLabelText: "Welcome",
            imageName: "person.fill",
            levelName: "",
            levelColor: UIColor.white
        )
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

    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            HomeScreenCourseCollectionViewCell.nib(),
            forCellWithReuseIdentifier: HomeScreenCourseCollectionViewCell.identifier
        )
    }
    
    private func setButton(){
        uploadBookButton.layer.cornerRadius = 8
        uploadBookButton.layer.masksToBounds = true
        
        studentsButton.layer.cornerRadius = 8
        studentsButton.layer.masksToBounds = true

    }
    @IBAction func handleUploadBook(_ sender: Any) {
        let coordinator = AddBookScreenCoordinator.getInstance()
        coordinator.start()
        ApplicationCoordinator.getInstance().pushFromTeacherScreenCoordinatorAndVariables(coordinator, hidesBottomBar: true)
    }
    @IBAction func handleStudentsButton(_ sender: Any) {
        let coordinator = StudentsScreenCoordinator.getInstance()
        coordinator.start()
        ApplicationCoordinator.getInstance().pushFromTeacherScreenCoordinatorAndVariables(coordinator, hidesBottomBar: true)
    }
}

extension TeacherScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.courses.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureCourseCell(at: indexPath)
    }

    func configureCourseCell(at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeScreenCourseCollectionViewCell.identifier,
            for: indexPath
        ) as? HomeScreenCourseCollectionViewCell else {
            return UICollectionViewCell()
        }

        let course = viewModel.courses[indexPath.row]
        let courseName = course.name

        cell.courseNameLabel.text = "\(courseName) Class"
        cell.enrollLabel.text = "Just click to add lessons to your course"

        if let animationName = courseAnimationMap[courseName] {
            let animation = LottieAnimation.named(animationName)
            cell.lottieView.animation = animation
            cell.lottieView.contentMode = .scaleAspectFill
            cell.lottieView.loopMode = .loop
            cell.lottieView.play()
        }

        styleCourseCell(cell, courseName: courseName)
        return cell
    }

    func styleCourseCell(_ cell: HomeScreenCourseCollectionViewCell, courseName: String) {
        switch courseName {
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
        let selectedCourse = viewModel.courses[indexPath.row]
        let coordinator = AddQuestionScreenCoordinator.getInstance()
        let viewModel = AddQuestionScreenViewModel(
            coordinator: coordinator,
            courseLevelName: "\(selectedCourse.level)",
            courseId: selectedCourse.id
        )
        coordinator.start(with: viewModel)
        ApplicationCoordinator.getInstance().pushFromTeacherScreenCoordinatorAndVariables(coordinator, hidesBottomBar: true)
    }
}
