//
//  NewQuestionScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 12.06.2025.
//

import Foundation
import UIKit
import Lottie

final class NewQuestionScreenViewController: UIViewController {
    var viewModel: NewQuestionScreenViewModel!
    @IBOutlet var lottieView: LottieAnimationView!
    @IBOutlet var questionLabel: UITextField!
    @IBOutlet var answer1Label: UITextField!
    @IBOutlet var answer2Label: UITextField!
    @IBOutlet var answer3Label: UITextField!
    @IBOutlet var answer4Label: UITextField!
    @IBOutlet var correctAnswerLabel: UITextField!
    @IBOutlet var passageTextView: UITextView!
    
    @IBOutlet var questionNumberLabel: UILabel!
    @IBOutlet var buttonStackView: UIStackView!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var trashButton: UIButton!
    @IBOutlet var addQuestionButton: UIButton!
    var addQuestionViewController: AddQuestionScreenViewController?
    var currentIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        print(viewModel.selectedLessonId!)
        setLottieAnimation()
        configure()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.isUpdate{
            setLessonData()
        }
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: .questionScreenDismissed, object: nil)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func configure(){
        switch viewModel.selectedCourseName{
        case "Reading":
            break
        case "Listening":
            questionLabel.isHidden = false
            passageTextView.isHidden = false
            answer1Label.isHidden = false
            answer2Label.isHidden = false
            answer3Label.isHidden = false
            answer4Label.isHidden = false
            correctAnswerLabel.isHidden = false
            break
        case "Writing":
            questionLabel.isHidden = true
            passageTextView.isHidden = false
            answer1Label.isHidden = true
            answer2Label.isHidden = true
            answer3Label.isHidden = true
            answer4Label.isHidden = true
            correctAnswerLabel.isHidden = true
            break
        case "Speaking":
            questionLabel.isHidden = true
            passageTextView.isHidden = false
            answer1Label.isHidden = true
            answer2Label.isHidden = true
            answer3Label.isHidden = true
            answer4Label.isHidden = true
            correctAnswerLabel.isHidden = true
            break
        default:
            print("error configuring UI")
        }
        passageTextView.delegate = self
        passageTextView.text = "Enter your text here..."
        passageTextView.textColor = .lightGray
        
        rightButton.setImage(UIImage(systemName: "arrow.right.circle"), for: .normal)
        leftButton.setImage(UIImage(systemName: "arrow.left.circle"), for: .normal)
        
        DispatchQueue.main.async { [self] in
            if viewModel.isUpdate{
                addQuestionButton.setTitle("Edit Question", for: .normal)
                trashButton.isHidden = false
                buttonStackView.isHidden = false
                questionNumberLabel.isHidden = false
                
            }else{
                addQuestionButton.setTitle("Add Question", for: .normal)
                trashButton.isHidden = true
                buttonStackView.isHidden = true
                questionNumberLabel.isHidden = true
            }
        }
    }
    
    
    private func setLottieAnimation(){
        let animation = LottieAnimation.named("questionAnimation")
        lottieView.animation = animation
        lottieView.contentMode = .scaleAspectFit
        lottieView.loopMode = .loop
        lottieView.play()
    }
    
    @IBAction func addQuestionButtonTapped(_ sender: Any) {
        
        guard let passage = passageTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !passage.isEmpty,
              passage != "Enter your text here..." else {
            showAlert(title: "Error", message: "Passage cannot be empty.", lottieName: "error") {
                self.passageTextView.becomeFirstResponder()
            }
            return
        }
        
        if !correctAnswerLabel.isHidden {
            
            guard let correctAnswer = correctAnswerLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let question = questionLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let answer1 = answer1Label.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let answer2 = answer2Label.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let answer3 = answer3Label.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let answer4 = answer4Label.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !question.isEmpty ,!answer1.isEmpty, !answer2.isEmpty, !answer3.isEmpty, !answer4.isEmpty else {
                showAlert(title: "Error", message: "All fields must be filled.", lottieName: "error")
                return
            }
            let allAnswers = [answer1, answer2, answer3, answer4]
            
            if !allAnswers.contains(correctAnswer) {
                showAlert(title: "Error", message: "Correct answer must be one of the following answers", lottieName: "error"){
                    self.correctAnswerLabel.becomeFirstResponder()
                }
                return
            }
        }
        
        if !viewModel.isUpdate{
            let questions: [LessonQuestionRequest] = [
                LessonQuestionRequest(
                    id: UUID().uuidString,
                    questionString: questionLabel.text ?? "",
                    answerOne: answer1Label.text ?? "",
                    answerTwo: answer2Label.text ?? "",
                    answerThree: answer3Label.text ?? "",
                    answerFour: answer4Label.text ?? "",
                    correctAnswer: correctAnswerLabel.text ?? "",
                    listeningSentence: passageTextView.text
                )
            ]
            
            
            viewModel.submitQuestions(questions) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.showAlert(title: "Success", message: "The question has been uploaded to the system.", lottieName: "success")
                    case .failure(let error):
                        self.showAlert(title: "Error", message: error.localizedDescription, lottieName: "error")
                    }
                }
            }
        }else{
            let questions = LessonQuestionRequest(
                id: viewModel.questions[0].id,
                questionString: questionLabel.text ?? "",
                answerOne: answer1Label.text ?? "",
                answerTwo: answer2Label.text ?? "",
                answerThree: answer3Label.text ?? "",
                answerFour: answer4Label.text ?? "",
                correctAnswer: correctAnswerLabel.text ?? "",
                listeningSentence: passageTextView.text
            )
            
            
            viewModel.editQuestions(questions) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.showAlert(title: "Success", message: "The question changes have been saved.", lottieName: "success")
                    case .failure(let error):
                        self.showAlert(title: "Error", message: error.localizedDescription, lottieName: "error")
                    }
                }
            }
        }

    }
    
    private func setLessonData() {
        viewModel.loadLessonData { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success:
                    guard self.currentIndex < self.viewModel.questions.count else {
                        print("Index out of bounds: \(self.currentIndex)")
                        return
                    }
                    let question = self.viewModel.questions[self.currentIndex]
                    self.questionLabel.text = question.questionString
                    self.answer1Label.text = question.answerOne
                    self.answer2Label.text = question.answerTwo
                    self.answer3Label.text = question.answerThree
                    self.answer4Label.text = question.answerFour
                    self.correctAnswerLabel.text = question.correctAnswer
                    self.passageTextView.text = question.listeningSentence
                    self.passageTextView.textColor = .porcelain
                    self.questionNumberLabel.text = "\(self.currentIndex + 1) / \(self.viewModel.questions.count)"
                    self.leftButton.isHidden = (self.currentIndex <= 0)
                    self.rightButton.isHidden = (self.currentIndex >= (self.viewModel.questions.count - 1))
                    
                    
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription, lottieName: "error")
                }
            }
        }
    }
    
    
    
    @IBAction func trashButtonClicked(_ sender: Any) {
        showAlertWithAction(
            title: "Delete Question",
            message: "Are you sure you want to delete this question? This action cannot be undone."
        ) { [weak self] in
            guard let self = self else { return }
            let id = self.viewModel.questions[self.currentIndex].id
            
            self.viewModel.deleteQuestion(id: id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.viewModel.questions.remove(at: self.currentIndex)
                        
                        if self.viewModel.questions.isEmpty {
                            self.showAlert(title: "No Questions Left",
                                           message: "All questions have been deleted. You will be redirected to the previous screen.",
                                           lottieName: "error") {
                                self.dismiss(animated: true)
                            }
                            return
                        }
                        if self.currentIndex >= self.viewModel.questions.count {
                            self.currentIndex = max(0, self.viewModel.questions.count - 1)
                        }
                        
                        self.setLessonData()
                        self.showAlert(title: "Success", message: "The question has been successfully deleted.", lottieName: "success")
                        
                    case .failure(let error):
                        self.showAlert(title: "Error", message: error.localizedDescription, lottieName: "error")
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func rightButtonClicked(_ sender: Any) {
        currentIndex += 1
        setLessonData()
    }
    
    @IBAction func leftButtonClicked(_ sender: Any) {
        currentIndex -= 1
        setLessonData()
    }
}

extension NewQuestionScreenViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter your text here..." {
            textView.text = ""
            textView.textColor = .porcelain
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "Enter your text here..."
            textView.textColor = .lightGray
        }
    }
}
