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
    var questionGroups: [[LevelQuestion]] = []
    var currentIndex = 0
    @IBOutlet var levelQuestionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyGradientBackground()
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
    
    private func setTableView(){
        let cellNib = UINib(nibName: "LevelTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "LevelCell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func setupData() {
        questionGroups = [
            [ // Reading
                LevelQuestion(title: "A1 - Beginner", description: "Read short texts"),
                LevelQuestion(title: "A2 - Elementary", description: "Read emails and letters"),
                LevelQuestion(title: "B1 - Intermediate", description: "Read articles and reports"),
                LevelQuestion(title: "B2 - Upper-Intermediate", description: "Read complex passages"),
                LevelQuestion(title: "C1 - Advanced", description: "Read academic and professional texts"),
                LevelQuestion(title: "C2 - Proficient", description: "Understand nuanced literary or academic materials")
            ],
            [ // Listening
                LevelQuestion(title: "A1 - Beginner", description: "Understand simple phrases"),
                LevelQuestion(title: "A2 - Elementary", description: "Understand short, clear speech"),
                LevelQuestion(title: "B1 - Intermediate", description: "Follow conversations on familiar topics"),
                LevelQuestion(title: "B2 - Upper-Intermediate", description: "Understand native-speed discussions"),
                LevelQuestion(title: "C1 - Advanced", description: "Follow lectures and detailed speech"),
                LevelQuestion(title: "C2 - Proficient", description: "Comprehend complex or idiomatic audio")
            ],
            [ // Writing
                LevelQuestion(title: "A1 - Beginner", description: "Write simple sentences"),
                LevelQuestion(title: "A2 - Elementary", description: "Write short personal messages"),
                LevelQuestion(title: "B1 - Intermediate", description: "Compose structured paragraphs"),
                LevelQuestion(title: "B2 - Upper-Intermediate", description: "Write emails, stories, and essays"),
                LevelQuestion(title: "C1 - Advanced", description: "Develop formal writing with arguments"),
                LevelQuestion(title: "C2 - Proficient", description: "Produce polished academic or professional documents")
            ],
            [ // Speaking
                LevelQuestion(title: "A1 - Beginner", description: "Introduce yourself and use simple phrases"),
                LevelQuestion(title: "A2 - Elementary", description: "Handle basic interactions in daily situations"),
                LevelQuestion(title: "B1 - Intermediate", description: "Hold conversations on familiar topics"),
                LevelQuestion(title: "B2 - Upper-Intermediate", description: "Discuss abstract topics confidently"),
                LevelQuestion(title: "C1 - Advanced", description: "Express ideas fluently in debates"),
                LevelQuestion(title: "C2 - Proficient", description: "Speak clearly with subtle nuance and accuracy")
            ]
        ]
        
    }
    
    private func fetchCourses(){
        viewModel?.getCourses { result in
            switch result {
            case .success(let courses):
                DispatchQueue.main.async {
                    let levelText = "\((self.viewModel.courses[self.currentIndex].name))"
                    let fullText = "What is your \(levelText) level?"
                    let attributedText = NSMutableAttributedString(string: fullText)
                    
                    let range = (fullText as NSString).range(of: levelText)
                    attributedText.addAttribute(.foregroundColor, value: UIColor.summer, range: range)
                    self.levelQuestionLabel.attributedText = attributedText
                    self.tableView.reloadData()
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
            let levelText = "\((self.viewModel.courses[self.currentIndex].name))"
            let fullText = "What is your \(levelText) level?"
            let attributedText = NSMutableAttributedString(string: fullText)
            
            let range = (fullText as NSString).range(of: levelText)
            attributedText.addAttribute(.foregroundColor, value: UIColor.summer, range: range)
            self.levelQuestionLabel.attributedText = attributedText
            continueButton.isEnabled = false
        } else {
            if let userId = UserDefaults.standard.string(forKey: "userID") {
                viewModel.submitSelections(studentId: userId) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            self.goToNextPage()
                        case .failure(let error):
                            print("Gönderim hatası: \(error.localizedDescription)")
                        }
                    }
                }
            } else {
            }
        }
    }
    
    
    private func goToNextPage() {
        ApplicationCoordinator.getInstance().initTabBar()
    }

    private func showSelectionAlert() {
        self.showAlert(title: "Selection Required", message: "Please select a level before continuing.", lottieName: "error")
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
