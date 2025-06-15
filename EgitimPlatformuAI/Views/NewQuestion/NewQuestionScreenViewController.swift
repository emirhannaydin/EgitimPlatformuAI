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
            questionLabel.text = "Enter Listening text"
        case "Writing":
            break
        case "Speaking":
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
    
}



