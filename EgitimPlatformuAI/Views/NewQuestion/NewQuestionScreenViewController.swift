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
}



