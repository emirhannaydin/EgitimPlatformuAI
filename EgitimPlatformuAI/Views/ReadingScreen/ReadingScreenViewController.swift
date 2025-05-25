//
//  ReadingScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 28.04.2025.
//

import Foundation
import UIKit

final class ReadingScreenViewController: UIViewController {
    var viewModel: ReadingScreenViewModel?
    var courseType: CourseType = .reading

    @IBOutlet var backButton: CustomBackButtonView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var checkButton: UIButton!
    @IBOutlet var passageLabel: UILabel!
    @IBOutlet var questionLabel: UILabel!
    private var currentQuestionIndex = 0
    private var readingAnswer = "cevap 1"
    private var selectedText = ""
    @IBOutlet var continueButton: CustomContinueView!
    
    public let readingQuestions: [ReadingQuestion] = [
        ReadingQuestion(
            passage: "Cats are small mammals known for their agility and independence.",
            question: "What are cats known for?",
            answers: ["Loyalty", "Flying", "Independence", "Swimming"],
            correctAnswerIndex: 2
        ),
        ReadingQuestion(
            passage: "The sun is the center of our solar system and provides energy to Earth.",
            question: "What is the sun's role in the solar system?",
            answers: ["A planet", "Center of the solar system", "Moon", "Comet"],
            correctAnswerIndex: 1
        ),
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let cellNib = UINib(nibName: "ReadingTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ReadingCell")
        setNotification()
        loadQuestion()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @objc func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkButton(_ sender: Any) {
        self.showLottieLoading()
        guard let selectedIndexPath = tableView.indexPathForSelectedRow,
              let cell = tableView.cellForRow(at: selectedIndexPath) as? ReadingTableViewCell,
              let selectedText = cell.answerText.text
        else {
            self.hideLottieLoading()
            self.showAlert(title: "Error", message: "Choose one")
            return
        }

        let correctText = readingAnswer
        let currentQuestion = readingQuestions[currentQuestionIndex]
        let passageText = currentQuestion.passage
        let questionText = currentQuestion.question
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
            if currentQuestionIndex < readingQuestions.count {
                loadQuestion()
            } else {
                showAlert(title: "Completed", message: "You have finished all questions.")
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
        let currentQuestion = readingQuestions[currentQuestionIndex]
        passageLabel.text = currentQuestion.passage
        questionLabel.text = currentQuestion.question
        readingAnswer = currentQuestion.answers[currentQuestion.correctAnswerIndex]
        tableView.allowsSelection = true
        checkButton.isHidden = false
        continueButton.isHidden = true
        tableView.reloadData()
    }

    
}

extension ReadingScreenViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReadingCell", for: indexPath) as! ReadingTableViewCell
        let currentAnswers = readingQuestions[currentQuestionIndex].answers
        cell.answerText.text = currentAnswers[indexPath.row]
        return cell
    }
    
    
}

extension ReadingScreenViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ReadingTableViewCell {
            }
    }
}
