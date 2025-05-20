//
//  SpeakingScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 28.04.2025.
//

import UIKit
import AVFoundation
import Lottie

final class SpeakingScreenViewController: UIViewController {
    
    var viewModel: SpeakingScreenViewModel!

    @IBOutlet var backButton: CustomBackButtonView!
    @IBOutlet var speakingLottie: LottieAnimationView!
    @IBOutlet var questionCount: UILabel!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var speakingLabel: UILabel!
    @IBOutlet var speakButton: UIButton!
    @IBOutlet var hearingYouLabel: UILabel!
    @IBOutlet var successRateLabel: UILabel!
    @IBOutlet var speaksView: UIView!
    @IBOutlet var speaksLeftLabel: UILabel!
    @IBOutlet var checkButton: UIButton!
    @IBOutlet var customContinueView: CustomContinueView!
    private let recorder = AudioRecorderManager()
    
    @IBOutlet var iconImageView: UIImageView!
    
    private var isButtonClicked = false
    private var speaksLeftCount: Int = 3
    private var isRecording = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setLottie()
        setSpeakingButton()
        speakingLabel.text = """
    In recent years, the rapid advancement of technology has significantly transformed the way we communicate. While digital platforms such as social media, instant messaging, and video calls have made it easier to stay in touch with people across the globe, they have also changed the nature of human interaction.

    Face-to-face conversations, once considered essential for building trust and emotional connection, are now often replaced by text messages or online meetings. Although these tools offer convenience and speed, some argue that they contribute to a decline in the quality of our relationships. Emotional cues such as tone of voice, facial expressions, and body language are frequently lost in digital communication, leading to misunderstandings and a sense of detachment.

    On the other hand, digitalization has provided new opportunities for people with disabilities, those living in remote areas, or individuals with social anxiety, enabling them to connect with others more comfortably. Online platforms have also encouraged cross-cultural dialogue and global collaboration, enriching our understanding of different perspectives.

    In conclusion, while digital communication has its drawbacks, it also offers significant advantages. The key lies in finding a balance—using technology to enhance our interactions without letting it replace the human touch.
    """
    }
    
    private func setLottie(){
        let animation = LottieAnimation.named("speakingScreenGreen")
        speakingLottie.animation = animation
        speakingLottie.contentMode = .scaleAspectFit
        speakingLottie.loopMode = .loop
        speakingLottie.stop()
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(speaksViewTapped))
        speaksView.addGestureRecognizer(tapGesture)

    }
    
    private func setSpeakingButton(){
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular)
        let micImage = UIImage(systemName: "microphone", withConfiguration: largeConfig)
        speakButton.setImage(micImage, for: .normal)
        speakButton.tintColor = .mintGreen
        
    }
    
    @objc func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }

    @objc func speaksViewTapped(){
        handleSpeaks()
    }

    @IBAction func speakButton(_ sender: Any) {
        handleSpeaks()
    }
    
    private func handleSpeaks(){
        isButtonClicked.toggle()
            if isButtonClicked {
                if speaksLeftCount > 0 {
                    let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular)
                    let micImage = UIImage(systemName: "microphone.fill", withConfiguration: largeConfig)
                    
                    speaksView.layer.borderColor = UIColor.summer.cgColor
                    speakButton.setImage(micImage, for: .normal)
                    speakButton.tintColor = .summer
                    hearingYouLabel.text = "🎤 We're listening... keep going!"
                    hearingYouLabel.textColor = .summer
                    speaksLeftCount -= 1
                    speaksLeftLabel.text = "Speaks Left:\(speaksLeftCount)"
                    let animation = LottieAnimation.named("speakingScreen")
                    speakingLottie.animation = animation
                    speakingLottie.play()
                }else{
                    speaksLeftLabel.textColor = .red
                    animateLabelShake(speaksLeftLabel)
                }
            }else{
                setSpeakingButton()
                hearingYouLabel.text = "Tap to speaking..."
                speakButton.tintColor = .mintGreen
                hearingYouLabel.textColor = .mintGreen
                setLottie()

            }
    }
    @IBAction func checkButton(_ sender: Any) {
        customContinueView.isHidden = false
        checkButton.isHidden = true
        
        customContinueView.animateIn()
    }
    
}
