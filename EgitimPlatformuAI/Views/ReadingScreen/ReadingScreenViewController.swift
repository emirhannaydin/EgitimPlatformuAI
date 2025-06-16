//
//  ReadingScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 28.04.2025.
//

import Foundation
import UIKit

final class ReadingScreenViewController: UIViewController {
    var viewModel: ReadingScreenViewModel!

    @IBOutlet var backButton: CustomBackButtonView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var checkButton: UIButton!
    @IBOutlet var passageLabel: UILabel!
    @IBOutlet var questionLabel: UILabel!
    private var currentQuestionIndex = 0
    private var readingAnswer = ""
    private var selectedText = ""
    @IBOutlet var continueButton: CustomContinueView!
    @IBOutlet var questionCount: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLottieLoading()
        navigationController?.isNavigationBarHidden = false
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        setNotification()
        setTableView()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setLessonData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @objc func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    private func setLessonData(){
        if let lessonId = viewModel.lessonId{
            viewModel.loadLessonData(lessonId: lessonId) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result{
                        
                    case(.success(_)):
                        self.loadQuestion()
                        self.tableView.reloadData()
                        self.hideLottieLoading()
                        print("kamdksamd")

                    case ( .failure(let error)):
                        print(error)
                    }
                }
            
            }
        }
    }
    private func setTableView(){
        let cellNib = UINib(nibName: "ReadingTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ReadingCell")
    }
    
    @IBAction func checkButton(_ sender: Any) {
        self.showLottieLoading()
        guard let selectedIndexPath = tableView.indexPathForSelectedRow,
              let cell = tableView.cellForRow(at: selectedIndexPath) as? ReadingTableViewCell,
              let selectedText = cell.answerText.text
        else {
            self.hideLottieLoading()
            self.showAlert(title: "Error", message: "Choose one", lottieName: "error")
            return
        }

        let correctText = readingAnswer
        let currentQuestion = viewModel.questions[currentQuestionIndex]
        let passageText = currentQuestion.listeningSentence
        let questionText = currentQuestion.questionString
        let aiMessage = """
        The user read a short passage in Turkish and tried to understand its meaning by answering a question.
        passage: "\(passageText)"
        question: "\(questionText)"
        Correct answer: "\(correctText)"
        User's response: "\(selectedText)"

        Please evaluate the response:
        - If the answer is incorrect, say something like: "You selected '\(selectedText)', but the correct answer is '\(correctText)'." Avoid saying “wrong.” Then, briefly encourage the user by explaining that careful and focused reading can greatly improve understanding — Do not suggest trying again. Finish your explanation in one sentence.
        """
        
        checkButton.isHidden = true
        continueButton.isHidden = false
        if selectedText != correctText {
            viewModel?.sendMessage(aiMessage)
            continueButton.setWrongAnswer()
            cell.containerView.backgroundColor = .systemRed
        }
        else {
            hideLottieLoading()
            continueButton.setCorrectAnswer()
            cell.containerView.backgroundColor = .systemGreen
        }
        tableView.allowsSelection = false
        continueButton.animateIn()
        
        continueButton.continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    @objc func continueButtonTapped(){
        currentQuestionIndex += 1
            if currentQuestionIndex < viewModel.questions.count {
                loadQuestion()
            } else {
                let userID = UserDefaults.standard.string(forKey: "userID") ?? "Unknown"
                viewModel.completeLesson(studentId: userID, lessonId: viewModel.lessonId!) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let isCompleted):
                            if isCompleted {
                                self.showLottieLoadingWithDuration() {
                                    ApplicationCoordinator.getInstance().initTabBar()
                                    self.hideLottieLoading()
                                }
                            } else {
                                self.showAlert(title: "Error", message: "Failed to complete the lesson.", lottieName: "error")
                            }
                        case .failure(let error):
                            self.showAlert(title: "Hata", message: error.localizedDescription, lottieName: "error")
                        }
                    }
                }
            }
    }

    private func setNotification(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAIFinalMessage),
            name: .aiMessageFinished,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .aiMessageUpdated, object: nil)
    }

    @objc private func handleAIFinalMessage() {
        let message = AIAPIManager.shared.currentMessage.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let popup = AIRobotPopupViewController(message: message)
        DispatchQueue.main.async {
            self.present(popup, animated: true){
                self.hideLottieLoading()
            }
        }
    }
    
    private func loadQuestion() {
        let currentQuestion = viewModel.questions[currentQuestionIndex]
        passageLabel.text = currentQuestion.listeningSentence
        questionCount.text = "\(currentQuestionIndex + 1)/\(viewModel.questions.count)"
        questionLabel.text = viewModel.questions[currentQuestionIndex].questionString
        if let _correctAnswer = currentQuestion.correctAnswer{
            readingAnswer = _correctAnswer
        }
        tableView.allowsSelection = true
        checkButton.isHidden = false
        continueButton.isHidden = true
        tableView.reloadData()
    }

    
}

extension ReadingScreenViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard viewModel.questions.indices.contains(currentQuestionIndex) else { return 0 }
        return viewModel.questions[currentQuestionIndex].options.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReadingCell", for: indexPath) as! ReadingTableViewCell
        
        guard viewModel.questions.indices.contains(currentQuestionIndex),
              viewModel.questions[currentQuestionIndex].options.indices.contains(indexPath.row) else {
            return cell
        }

        let currentAnswers = viewModel.questions[currentQuestionIndex].options
        cell.answerText.text = currentAnswers[indexPath.row]
        return cell
    }

    
    
}






