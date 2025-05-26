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
    @IBOutlet var questionLabel: UILabel!
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
    private var questions: [Speaking] = []
    private var isMicButtonClicked = false
    private var isListeningsButtonClicked = false
    private var speaksLeftCount: Int = 3
    private var currentIndex: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNotifications()
        loadQuestions()
        loadCurrentQuestion()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopAISpeaking()
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
    
    private func loadQuestions() {
        questions = [
            Speaking(question: "Please speak the text below", speakingLabel: "Saat 7’de uyanırım. Kahvaltı yaparım, sonra okula giderim. Okuldan sonra ödevimi yapar ve televizyon izlerim.", level: "A1"),
            Speaking(question: "Please speak the text below", speakingLabel: "Kitap okumaktan, müzik dinlemekten ve ailemle arkadaşlarımla vakit geçirmekten hoşlanırım.", level: "A2"),
            Speaking(question: "Please speak the text below", speakingLabel: "En sevdiğim tatil Yılbaşı Gecesi. Genellikle aileyle bir araya geliriz, birlikte akşam yemeği yeriz ve gece yarısı havai fişek izleriz.", level: "A2"),
            Speaking(question: "Please speak the text below", speakingLabel: "En unutulmaz deneyimlerimden biri ortaokulda bir bilim yarışmasını kazanmaktı. Bu bana özgüven verdi ve daha çok çalışmamı sağladı.", level: "B1"),
            Speaking(question: "Please speak the text below", speakingLabel: "Sosyal medya insanların bağlantıda kalmasına ve fikirlerini paylaşmasına yardımcı olur. Ancak dikkat dağınıklığına ve yüz yüze iletişimin azalmasına da yol açabilir.", level: "B1"),
            Speaking(question: "Please speak the text below", speakingLabel: "Teknoloji öğrenmeyi destekleyebilirken, öğretmenlerin öğrencileri yönlendirme ve motive etme konusunda çok önemli bir rolü olduğunu düşünüyorum; makineler bunu tamamen yerine getiremez.", level: "B2"),
            Speaking(question: "Please speak the text below", speakingLabel: "Vejetaryen olmak karbon salımını azaltabilir, ancak herkes bu yaşam tarzını benimseyemez ya da istemeyebilir. Dengeli ve uygulanabilir çözümler bulmak önemlidir.", level: "B2")
        ]
    }
    
    private func loadCurrentQuestion() {
        guard currentIndex < questions.count else {
            showAlert(title: "Test Bitti", message: "")
            return
        }
        let current = questions[currentIndex]
        questionCount.text = "\(currentIndex + 1)/\(questions.count)"
        questionLabel.text = current.question
        speakingLabel.text = current.speakingLabel
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
            
            viewModel.expectedText = questions[currentIndex].speakingLabel
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
                if score > 50 {
                    self?.customContinueView.setCorrectAnswer("Great Speech!")
                } else {
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
            viewModel.startAISpeaking(text: questions[currentIndex].speakingLabel)
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
    

