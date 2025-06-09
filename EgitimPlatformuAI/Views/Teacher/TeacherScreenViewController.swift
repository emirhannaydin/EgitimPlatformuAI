//
//  TeacherScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 3.06.2025.
//

import UIKit
import Foundation
import Lottie

final class TeacherScreenViewController: UIViewController{
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var nameContainerView: CustomNameContainer!
    var coursesName: [String] = []
    let courseAnimationMap: [String: String] = [
        "Writing Class": "writing",
        "Speaking Class": "speaking",
        "Listening Class": "listening",
        "Reading Class": "reading"]
    var viewModel: TeacherScreenViewModel!
    let userID = UserDefaults.standard.string(forKey: "userID") ?? "Unknown"
    let username = UserDefaults.standard.string(forKey: "username") ?? "Unknown"


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setNameContainer()
        setCollectionView()
        loadTeacherScreenData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func loadTeacherScreenData(){
        viewModel.loadCourseClasses(teacherId: userID) { [weak self] result in

            DispatchQueue.main.async {
                switch result{
                case .success:
                    guard let classes = self?.viewModel?.courseClasses else { return }
                    self?.coursesName = self?.viewModel.uniqueCourseClasses.map { $0.name } ?? []
                    self?.collectionView.reloadData()
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func setNameContainer(){
        nameContainerView.configureView(nameText: "Teacher \(username.capitalizingFirstLetter())", welcomeLabelText: "Welcome", imageName: "person.fill")
        nameContainerView.onLogoutTapped = { [weak self] in
            self?.showAlertWithAction(title: "Logout", message: "Are you sure you want to log out?") {
                ApplicationCoordinator.getInstance().start()
            }
        }
    }
    
    private func setCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeScreenCourseCollectionViewCell.nib(), forCellWithReuseIdentifier: HomeScreenCourseCollectionViewCell.identifier)
    }
    
    
}

extension TeacherScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coursesName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        return configureCourseCell(at: indexPath)

    }
    
    func configureCourseCell(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeScreenCourseCollectionViewCell.identifier, for: indexPath) as! HomeScreenCourseCollectionViewCell
        
        let courseName = coursesName[indexPath.row]
        cell.courseNameLabel.text = courseName
        cell.enrollLabel.text = "Just click to add lessons to your course"
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
    
    func styleCourseCell(_ cell: HomeScreenCourseCollectionViewCell) {
        switch cell.courseNameLabel.text {
        case "Reading Class":
            cell.courseNameLabel.textColor = .black
            cell.enrollLabel.textColor = .black
            cell.backgroundColor = .silver
        case "Listening Class":
            cell.courseNameLabel.textColor = .porcelain
            cell.backgroundColor = .sapphireBlue
        case "Writing Class":
            cell.courseNameLabel.textColor = .winter
            cell.backgroundColor = .softRed
        case "Speaking Class":
            cell.courseNameLabel.textColor = .coldPurple
            cell.enrollLabel.textColor = .white
            cell.backgroundColor = .mintGreen
        default:
            break
        }
    }
}


