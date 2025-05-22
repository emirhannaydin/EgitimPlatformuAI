//
//  WritingScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 28.04.2025.
//

import Foundation
import UIKit

final class WritingScreenViewController: UIViewController {
    var viewModel: WritingScreenViewModel?
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var exampleLabelView: UIView!
    @IBOutlet var translatedLabelView: UIView!
    @IBOutlet var backButton: CustomBackButtonView!
    @IBOutlet var checkButton: UIButton!
    @IBOutlet var continueButton: CustomContinueView!
    @IBOutlet var translatedText: UITextView!
    @IBOutlet var exampleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationController?.isNavigationBarHidden = false
        configureView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tapGesture.cancelsTouchesInView = false // Eğer butonlar veya başka kontroller varsa dokunmayı engellemesin diye
            view.addGestureRecognizer(tapGesture)
        setNotification()

    }
    private func configureView() {
        exampleLabelView.layer.borderColor = UIColor.mediumTurqoise.cgColor
        translatedLabelView.layer.borderColor = UIColor.mediumTurqoise.cgColor
    }

    @objc func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }

    @IBAction func checkButton(_ sender: Any) {
        print("check button pressed")
        self.showLottieLoading()
        
        guard let userAnswer = translatedText.text,
              let originalSentence = exampleLabel.text,
              !userAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.hideLottieLoading()
            self.showAlert(title: "Error", message: "Please write your translation.")
            return
        }
        print(originalSentence)
        print(userAnswer)
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

        viewModel?.sendMessage(evaluationPrompt, completion: { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.hideLottieLoading()

                switch result {
                case .success(let response):
                    self.continueButton.animateIn()
                    self.continueButton.continueButton.addTarget(self, action: #selector(self.continueButtonTapped), for: .touchUpInside)

                    if response.contains("Yes") {
                        self.continueButton.setCorrectAnswer()
                        self.translatedLabelView.backgroundColor = .systemGreen
                    } else {
                        self.continueButton.setWrongAnswer()
                        self.translatedLabelView.backgroundColor = .systemRed
                    }

                    self.showAlert(title: "Feedback", message: response)

                case .failure(let error):
                    self.showAlert(title: "Error", message: "AI response failed: \(error.localizedDescription)")
                }
            }
        })
    }


    
    @objc func continueButtonTapped(){
//        currentQuestionIndex += 1
//            if currentQuestionIndex < readingQuestions.count {
//                loadQuestion()
//            } else {
//                showAlert(title: "Completed", message: "You have finished all questions.")
//                courseType.markUserAsEnrolled()
//            }
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
