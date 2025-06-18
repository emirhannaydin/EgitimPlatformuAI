//
//  WritingScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 28.04.2025.
//

import Foundation
import UIKit

final class WritingScreenViewController: UIViewController {
    var viewModel: WritingScreenViewModel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var exampleLabelView: UIView!
    @IBOutlet var translatedLabelView: UIView!
    @IBOutlet var backButton: CustomBackButtonView!
    @IBOutlet var checkButton: UIButton!
    @IBOutlet var translatedText: UITextView!
    @IBOutlet var exampleLabel: UILabel!
    private var currentQuestionIndex = 0
    @IBOutlet var questionCount: UILabel!
    
    @IBOutlet var continueButton: CustomContinueView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLottieLoading()
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationController?.isNavigationBarHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setNotification()
        hideKeyboardWhenTappedAround()
        translatedText.delegate = self
        translatedText.text = "Enter your text here..."
        translatedText.textColor = .lightGray
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setLessonData()
    }
    
    private func configureView() {
        exampleLabelView.layer.borderColor = UIColor.mediumTurqoise.cgColor
        translatedLabelView.layer.borderColor = UIColor.mediumTurqoise.cgColor
        exampleLabelView.layer.borderWidth = 1.0
        translatedLabelView.layer.borderWidth = 1.0
        exampleLabelView.layer.cornerRadius = 8
        translatedLabelView.layer.cornerRadius = 8
        
        
    }

    private func setLessonData(){
        if let lessonId = viewModel.lessonId{
            viewModel.loadLessonData(lessonId: lessonId) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result{
                        
                    case(.success(_)):
                        self.loadQuestion()

                        self.hideLottieLoading()
                        

                    case ( .failure(let error)):
                        print(error)
                    }
                }
            
            }
        }
    }
    
    private func loadQuestion() {
        let currentQuestion = viewModel.questions[currentQuestionIndex]
        exampleLabel.text = currentQuestion.listeningSentence
        questionCount.text = "\(currentQuestionIndex + 1)/\(viewModel.questions.count)"
        checkButton.isHidden = false
        continueButton.isHidden = true
        self.configureView()

    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func checkButton(_ sender: Any) {
        if translatedText.text == "Enter your text here..."{
            showAlert(title: "Error", message: "You did not write anything", lottieName: "error")
            return
        }
        showLottieLoading()
        
        guard let userAnswer = translatedText.text,
              let originalSentence = exampleLabel.text,
              !userAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            hideLottieLoading()
            showAlert(title: "Error", message: "Please write your translation.", lottieName: "error")
            return
        }
        
        guard let viewModel = viewModel else {
            hideLottieLoading()
            showAlert(title: "Error", message: "AI services are currently unavailable.", lottieName: "error")
            return
        }
        
        let evaluationPrompt = """
        The user read an English sentence and tried to translate it into Turkish.
        Sentence: "\(originalSentence)"
        User's translation: "\(userAnswer)"
        
        Please evaluate the response:
        - If the answer is correct, just say: "Yes, your translation is correct!".
        - If the answer is incorrect, say something like: "You wrote '\(userAnswer)', but a more accurate translation would be '...'" (fill in the correct one).
        Encourage the user in one short sentence at the end. Avoid using the word “wrong” and do not suggest trying again.
        """
        
        checkButton.isHidden = true
        continueButton.isHidden = false
        translatedLabelView.backgroundColor = .clear
        viewModel.sendMessage(evaluationPrompt)
        
    }
    
    @objc func continueButtonTapped() {
        currentQuestionIndex += 1
            if currentQuestionIndex < viewModel.questions.count {
                translatedText.text = ""
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
                            self.showAlert(title: "Error", message: error.localizedDescription, lottieName: "error")
                        }
                    }
                }
            }
    }
    
    private func setNotification() {
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
        self.continueButton.animateIn()
        
        self.continueButton.continueButton.removeTarget(nil, action: nil, for: .allEvents)
        self.continueButton.continueButton.addTarget(self, action: #selector(self.continueButtonTapped), for: .touchUpInside)
        
        let lowercasedResponse = AIAPIManager.shared.currentMessage.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if lowercasedResponse.contains("your translation is correct") || lowercasedResponse.contains("yes") {
            self.continueButton.setCorrectAnswer()
        } else {
            self.continueButton.setWrongAnswer()
        }
        
        let popup = AIRobotPopupViewController(message: lowercasedResponse)
        DispatchQueue.main.async {
            self.present(popup, animated: true) {
                self.hideLottieLoading()
            }
        }
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
        
        if let activeField = findFirstResponder(in: self.view) {
            let activeFieldFrame = activeField.convert(activeField.bounds, to: scrollView)
            scrollView.scrollRectToVisible(activeFieldFrame, animated: true)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    private func findFirstResponder(in view: UIView) -> UIView? {
        if view.isFirstResponder {
            return view
        }
        for subview in view.subviews {
            if let responder = findFirstResponder(in: subview) {
                return responder
            }
        }
        return nil
    }
}

extension WritingScreenViewController: UITextViewDelegate {
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

