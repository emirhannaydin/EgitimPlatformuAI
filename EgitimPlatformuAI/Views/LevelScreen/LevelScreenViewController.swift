//
//  WritingScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 28.04.2025.
//

import Foundation
import UIKit

final class LevelScreenViewController: UIViewController {
    var viewModel: LevelScreenViewModel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var continueButton: UIButton!
    var questionGroups: [[Question]] = []
    var currentIndex = 0
    @IBOutlet var levelQuestionLabel: UILabel!
    
    
    struct Question {
        let title: String
        let description: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "LevelTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "LevelCell")
        continueButton.isEnabled = false
        setupData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        fetchCourses()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupData() {
        questionGroups = [
            [ // Reading
                Question(title: "Beginner", description: "Read short texts"),
                Question(title: "Intermediate", description: "Read emails and letters"),
                Question(title: "Advanced", description: "Read articles and reports"),
                Question(title: "Expert", description: "Read academic texts")
            ],
            [ // Listening
                Question(title: "Beginner", description: "Understand simple phrases"),
                Question(title: "Intermediate", description: "Follow basic conversations"),
                Question(title: "Advanced", description: "Understand native speed speech"),
                Question(title: "Expert", description: "Comprehend complex audio")
            ],
            [
                Question(title: "Beginner", description: "Write simple sentences about familiar topics"),
                Question(title: "Intermediate", description: "Compose short paragraphs with correct structure"),
                Question(title: "Advanced", description: "Develop essays with arguments and proper grammar"),
                Question(title: "Expert", description: "Produce professional-level writing with clarity and style")
            ],
            [
                Question(title: "Beginner", description: "Introduce yourself and use common expressions"),
                Question(title: "Intermediate", description: "Participate in everyday conversations confidently"),
                Question(title: "Advanced", description: "Express opinions clearly in discussions"),
                Question(title: "Expert", description: "Speak fluently with advanced vocabulary and coherence")
            ]
        ]
        DispatchQueue.main.async {
            self.levelQuestionLabel.text = (self.viewModel.courses[self.currentIndex].name)
        }
    }
    
    func fetchCourses(){
        viewModel?.getCourses { result in
            switch result {
            case .success(let courses):
                DispatchQueue.main.async {
                    print("controller calisti")
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
            showSelectionAlert()
            return
        }
        let selectedLevel = selectedIndexPath.row
        let selectedCourse = viewModel.courses[currentIndex]
        viewModel.addCourseSelection(courseId: selectedCourse.id, level: selectedLevel)
        
        if currentIndex < viewModel.courses.count - 1 {
            currentIndex += 1
            tableView.reloadData()
            levelQuestionLabel.text = (viewModel.courses[currentIndex].name)
            continueButton.isEnabled = false
        } else {
            if let userId = UserDefaults.standard.string(forKey: "userID") {
                print(userId)
                viewModel.submitSelections(studentId: userId) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            UserDefaults.standard.set(true, forKey: "hasSubmittedLevels")
                            print("Başarıyla gönderildi.")
                            self.goToNextPage()
                        case .failure(let error):
                            print("Gönderim hatası: \(error.localizedDescription)")
                        }
                    }
                }
            } else {
                print("UserID bulunamadı.")
            }
        }
    }
    
    
    func goToNextPage() {
        ApplicationCoordinator.getInstance().initTabBar()
    }

    func showSelectionAlert() {
        let alert = UIAlertController(title: "Selection Required", message: "Please select a level before continuing.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}

extension LevelScreenViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionGroups[currentIndex].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let question = questionGroups[currentIndex][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LevelCell", for: indexPath) as! LevelTableViewCell
        cell.levelLabel.text = question.title
        cell.infoLabel.text = question.description
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        continueButton.isEnabled = true
    }
    
    
}

extension LevelScreenViewController: UITableViewDelegate{
    
}
