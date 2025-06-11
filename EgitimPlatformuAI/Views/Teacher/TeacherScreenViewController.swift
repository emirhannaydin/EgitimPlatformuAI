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
        setNameContainer()
        setCollectionView()
        fetchCourses()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    func fetchCourses() {
        viewModel?.getCourses { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func setNameContainer() {
        nameContainerView.configureView(
            nameText: "Teacher \(username.capitalizingFirstLetter())",
            welcomeLabelText: "Welcome",
            imageName: "person.fill"
        )
        nameContainerView.onLogoutTapped = { [weak self] in
            self?.showAlertWithAction(title: "Logout", message: "Are you sure you want to log out?") {
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

        let viewModel = AddQuestionScreenViewModel(
            coordinator: AddQuestionScreenCoordinator.getInstance(),
            courseLevelName: "\(selectedCourse.level)",
            courseId: selectedCourse.id
        )

        ApplicationCoordinator.getInstance().handleAddQuestionEntry(with: viewModel)
    }
}
