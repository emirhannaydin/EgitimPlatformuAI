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
        fetchCourses()
        setupData()
        continueButton.isEnabled = false
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setTableView(){
        let cellNib = UINib(nibName: "LevelTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "LevelCell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func setupData() {
        questionGroups = [
            [ // Reading
                Question(title: "A1 - Beginner", description: "Read short texts"),
                Question(title: "A2 - Elementary", description: "Read emails and letters"),
                Question(title: "B1 - Intermediate", description: "Read articles and reports"),
                Question(title: "B2 - Upper-Intermediate", description: "Read complex passages"),
                Question(title: "C1 - Advanced", description: "Read academic and professional texts"),
                Question(title: "C2 - Proficient", description: "Understand nuanced literary or academic materials")
            ],
            [ // Listening
                Question(title: "A1 - Beginner", description: "Understand simple phrases"),
                Question(title: "A2 - Elementary", description: "Understand short, clear speech"),
                Question(title: "B1 - Intermediate", description: "Follow conversations on familiar topics"),
                Question(title: "B2 - Upper-Intermediate", description: "Understand native-speed discussions"),
                Question(title: "C1 - Advanced", description: "Follow lectures and detailed speech"),
                Question(title: "C2 - Proficient", description: "Comprehend complex or idiomatic audio")
            ],
            [ // Writing
                Question(title: "A1 - Beginner", description: "Write simple sentences"),
                Question(title: "A2 - Elementary", description: "Write short personal messages"),
                Question(title: "B1 - Intermediate", description: "Compose structured paragraphs"),
                Question(title: "B2 - Upper-Intermediate", description: "Write emails, stories, and essays"),
                Question(title: "C1 - Advanced", description: "Develop formal writing with arguments"),
                Question(title: "C2 - Proficient", description: "Produce polished academic or professional documents")
            ],
            [ // Speaking
                Question(title: "A1 - Beginner", description: "Introduce yourself and use simple phrases"),
                Question(title: "A2 - Elementary", description: "Handle basic interactions in daily situations"),
                Question(title: "B1 - Intermediate", description: "Hold conversations on familiar topics"),
                Question(title: "B2 - Upper-Intermediate", description: "Discuss abstract topics confidently"),
                Question(title: "C1 - Advanced", description: "Express ideas fluently in debates"),
                Question(title: "C2 - Proficient", description: "Speak clearly with subtle nuance and accuracy")
            ]
        ]
        
    }
    
    func fetchCourses(){
        viewModel?.getCourses { result in
            switch result {
            case .success(let courses):
                DispatchQueue.main.async {
                    self.levelQuestionLabel.text = "What is your \((self.viewModel.courses[self.currentIndex].name)) level?"
                    self.tableView.reloadData()
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
            levelQuestionLabel.text = "What is your \((viewModel.courses[currentIndex].name)) level?"
            continueButton.isEnabled = false
        } else {
            if let userId = UserDefaults.standard.string(forKey: "userID") {
                print(userId)
                viewModel.submitSelections(studentId: userId) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            UserDefaults.standard.set(true, forKey: "hasSubmittedLevels_\(userId)")
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
