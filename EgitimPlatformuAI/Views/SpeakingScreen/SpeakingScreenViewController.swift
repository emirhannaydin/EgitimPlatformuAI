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
    
    
    @IBOutlet var backButton: CustomBackButtonView!
    @IBOutlet var speakingLottie: LottieAnimationView!
    @IBOutlet var questionCount: UILabel!
    @IBOutlet var speakingLabel: UILabel!
    @IBOutlet var speakButton: UIButton!
    @IBOutlet var hearingYouLabel: UILabel!
    @IBOutlet var successRateLabel: UILabel!
    @IBOutlet var speaksView: UIView!
    @IBOutlet var speaksLeftLabel: UILabel!
    @IBOutlet var checkButton: UIButton!
    @IBOutlet var customContinueView: CustomContinueView!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var listeningActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var listeningButton: UIButton!
    
    var viewModel: SpeakingScreenViewModel!
    private var isMicButtonClicked = false
    private var isListeningsButtonClicked = false
    private var speaksLeftCount: Int = 3
    private var currentIndex: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLottieLoading()
        setupUI()
        setupNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopAISpeaking()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setLessonData()
    }
    
    private func setupUI() {
        configureLottie(named: "speakingScreenGreen")
        setSpeakingButton()
        setListeningButton()
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(speaksViewTapped))
        speaksView.addGestureRecognizer(tapGesture)
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onSpeechEnd), name: .aiSpeechFinished, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onSpeechReady), name: .aiSpeechDidStart, object: nil)
    }
    
    private func setLessonData(){
        if let lessonId = viewModel.lessonId{
            viewModel.loadLessonData(lessonId: lessonId) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result{
                        
                    case(.success(_)):
                        self.loadCurrentQuestion()
                        self.hideLottieLoading()

                    case ( .failure(let error)):
                        print(error)
                    }
                }
            
            }
        }
    }
    
    private func loadCurrentQuestion() {
        guard currentIndex < viewModel.questions.count else {
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
            return
        }
        viewModel.expectedText = ""

        let current = viewModel.questions[currentIndex]
        questionCount.text = "\(currentIndex + 1)/\(viewModel.questions.count)"
        speakingLabel.text = current.listeningSentence
    }

    
    @objc private func onSpeechEnd() {
        listeningButton.setImage(UIImage(systemName: "speaker"), for: .normal)
        isListeningsButtonClicked = false
    }
    
    @objc private func onSpeechReady() {
        listeningActivityIndicator.stopAnimating()
        setSpeakingActivityHidden()
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func speaksViewTapped() {
        handleSpeaks()
    }
    
    @IBAction private func speakButton(_ sender: Any) {
        handleSpeaks()
    }
    
    private func handleSpeaks() {
        isMicButtonClicked.toggle()
        if isMicButtonClicked {
            guard speaksLeftCount > 0 else {
                speaksLeftLabel.textColor = .red
                animateLabelShake(speaksLeftLabel)
                return
            }
            
            viewModel.stopAISpeaking()
            listeningActivityIndicator.stopAnimating()
            setSpeakingActivityHidden()
            listeningButton.alpha = 0
            listeningButton.isUserInteractionEnabled = false
            
            updateMicButtonImage(filled: true, color: .summer)
            updateHearingLabel("🎤 We're listening... keep going!", color: .summer)
            speaksLeftCount -= 1
            speaksLeftLabel.text = "Speaks Left:\(speaksLeftCount)"
            configureLottie(named: "speakingScreen", play: true)
            listeningButton.setImage(UIImage(systemName: "speaker"), for: .normal)
            viewModel.expectedText = viewModel.questions[currentIndex].listeningSentence ?? ""
            viewModel.startRecording()
            successRateLabel.text = "Evaluating your speech..."
        } else {
            resetAfterSpeaking()
        }
    }
    
    @IBAction func checkButton(_ sender: Any) {
        guard !isMicButtonClicked else {
            showWarning("You need to stop the speech before checking.")
            return
        }
        
        guard !viewModel.expectedText.isEmpty else {
            showWarning("Please start the speaking task before checking.")
            return
        }
        
        showLottieLoading()
        customContinueView.isHidden = false
        checkButton.isHidden = true
        listeningButton.setImage(UIImage(systemName: "speaker"), for: .normal)
        listeningActivityIndicator.stopAnimating()
        setSpeakingActivityHidden()
        viewModel.stopAISpeaking()
        
        viewModel.stopRecordingAndEvaluate { [weak self] text, similarity in
            DispatchQueue.main.async {
                self?.hideLottieLoading()
                let score = Int(similarity * 100)
                self?.successRateLabel.text = "🎯 Score: %\(score)"
                if score > 75 {
                    self?.customContinueView.setCorrectAnswer("Great Speech!")
                } else if score >= 50 && score <= 75 {
                    self?.customContinueView.setMedLevelAnswer()
                }
                else {
                    self?.customContinueView.setWrongAnswer("Wrong Speech")
                }
                self?.customContinueView.animateIn()
            }
        }
        
        customContinueView.continueButton.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
    }
    
    @objc private func nextQuestion() {
        customContinueView.isHidden = true
        checkButton.isHidden = false
        isListeningsButtonClicked = false
        isMicButtonClicked = false
        speaksLeftCount = 3
        speaksLeftLabel.text = "Speaks Left:\(speaksLeftCount)"
        successRateLabel.text = ""
        currentIndex += 1
        setListeningButton()
        loadCurrentQuestion()
    }
    
    @IBAction func listeningButtonClicked(_ sender: Any) {
        isListeningsButtonClicked.toggle()
        if isListeningsButtonClicked {
            listeningButton.setImage(UIImage(systemName: "speaker.fill"), for: .normal)
            listeningActivityIndicator.startAnimating()
            listeningActivityIndicator.alpha = 1
            viewModel.startAISpeaking(text: viewModel.questions[currentIndex].listeningSentence ?? "")
        } else {
            setListeningButton()
            listeningActivityIndicator.stopAnimating()
            setSpeakingActivityHidden()
            viewModel.stopAISpeaking()
        }
    }
    
    // MARK: - Helpers
    
    private func setListeningButton() {
        listeningButton.setImage(UIImage(systemName: "speaker"), for: .normal)
        listeningButton.tintColor = .mintGreen
    }
    
    private func setSpeakingButton() {
        updateMicButtonImage(filled: false, color: .mintGreen)
    }
    
    private func setSpeakingActivityHidden() {
        listeningActivityIndicator.alpha = 0
        listeningActivityIndicator.isUserInteractionEnabled = false
    }
    
    private func configureLottie(named name: String, play: Bool = false) {
        let animation = LottieAnimation.named(name)
        speakingLottie.animation = animation
        speakingLottie.contentMode = .scaleAspectFit
        speakingLottie.loopMode = .loop
        play ? speakingLottie.play() : speakingLottie.stop()
    }
    
    private func updateMicButtonImage(filled: Bool, color: UIColor) {
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular)
        let imageName = filled ? "microphone.fill" : "microphone"
        let image = UIImage(systemName: imageName, withConfiguration: config)
        speakButton.setImage(image, for: .normal)
        speakButton.tintColor = color
    }
    
    private func updateHearingLabel(_ text: String, color: UIColor) {
        hearingYouLabel.text = text
        hearingYouLabel.textColor = color
    }
    
    private func showWarning(_ message: String) {
        animateViewShake(speaksView)
        updateHearingLabel(message, color: .softRed)
    }
    
    private func resetAfterSpeaking() {
        viewModel.stopAISpeaking()
        listeningButton.alpha = 1
        listeningButton.isUserInteractionEnabled = true
        updateMicButtonImage(filled: false, color: .mintGreen)
        updateHearingLabel("Tap to speaking...", color: .mintGreen)
        successRateLabel.text = "You can press the Check button to see how accurate your speech was."
        configureLottie(named: "speakingScreenGreen")
    }
    
}
    

