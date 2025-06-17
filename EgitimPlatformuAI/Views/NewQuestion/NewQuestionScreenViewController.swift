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
    var addQuestionViewController: AddQuestionScreenViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(viewModel.selectedLessonId!)
        setLottieAnimation()
        configure()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let presentingVC = presentingViewController {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
            tapGesture.cancelsTouchesInView = false
            presentingVC.view.addGestureRecognizer(tapGesture)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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
            questionLabel.isHidden = false
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
    }
    
    
    private func setLottieAnimation(){
        let animation = LottieAnimation.named("questionAnimation")
        lottieView.animation = animation
        lottieView.contentMode = .scaleAspectFit
        lottieView.loopMode = .loop
        lottieView.play()
    }
    
    @objc func handleBackgroundTap() {
        self.dismiss(animated: true)
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
        NotificationCenter.default.post(name: .questionScreenDismissed, object: nil)
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
