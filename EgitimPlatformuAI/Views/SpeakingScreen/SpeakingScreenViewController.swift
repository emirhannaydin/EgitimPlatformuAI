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
    @IBOutlet var speakingActivity: UIActivityIndicatorView!
    @IBOutlet var listeningButton: UIButton!
    
    private let recorder = AudioRecorderManager()
    var viewModel: SpeakingScreenViewModel!
    private var questions: [Speaking] = []
    private var isMicButtonClicked = false
    private var isListeningsButtonClicked = false
    private var speaksLeftCount: Int = 3
    private var isRecording = false
    private var currentIndex: Int = 0
    private var tts: TextToSpeech = TextToSpeech()


    override func viewDidLoad() {
        super.viewDidLoad()
        setLottie()
        setSpeakingButton()
        setListeningButton()
        setNotification()
        questions = [
            Speaking(
                question: "Please speak the text below",
                speakingLabel: "Bugün sabah erkenden uyandım ve kahvaltı hazırladım. Kahvemi içerken biraz kitap okumak istedim. Hava güneşli olduğu için dışarı çıkıp yürüyüş yapmaya karar verdim. Parkta yürürken kuş seslerini duymak beni çok rahatlattı. Eve dönerken markete uğrayıp birkaç alışveriş yaptım. Öğleden sonra bilgisayarımı açıp ders çalışmaya başladım. Yeni konuları öğrenmek hem heyecan verici hem de biraz zorlayıcıydı. Akşam yemeğini ailemle birlikte yedik ve günümüzü birbirimize anlattık. Yemeğin ardından biraz televizyon izledim ve dinlendim. Şimdi ise yatma vakti geldi, yarın için erken kalkmam gerekiyor.",
                level: "A1"
            ),
            Speaking(
                question: "Please speak the text below",
                speakingLabel: "Saat 7’de uyanırım. Kahvaltı yaparım, sonra okula giderim. Okuldan sonra ödevimi yapar ve televizyon izlerim.",
                level: "A1"
            ),
            Speaking(
                question: "Please speak the text below",
                speakingLabel: "Kitap okumaktan, müzik dinlemekten ve ailemle arkadaşlarımla vakit geçirmekten hoşlanırım.",
                level: "A2"
            ),
            Speaking(
                question: "Please speak the text below",
                speakingLabel: "En sevdiğim tatil Yılbaşı Gecesi. Genellikle aileyle bir araya geliriz, birlikte akşam yemeği yeriz ve gece yarısı havai fişek izleriz.",
                level: "A2"
            ),
            Speaking(
                question: "Please speak the text below",
                speakingLabel: "En unutulmaz deneyimlerimden biri ortaokulda bir bilim yarışmasını kazanmaktı. Bu bana özgüven verdi ve daha çok çalışmamı sağladı.",
                level: "B1"
            ),
            Speaking(
                question: "Please speak the text below",
                speakingLabel: "Sosyal medya insanların bağlantıda kalmasına ve fikirlerini paylaşmasına yardımcı olur. Ancak dikkat dağınıklığına ve yüz yüze iletişimin azalmasına da yol açabilir.",
                level: "B1"
            ),
            Speaking(
                question: "Please speak the text below",
                speakingLabel: "Teknoloji öğrenmeyi destekleyebilirken, öğretmenlerin öğrencileri yönlendirme ve motive etme konusunda çok önemli bir rolü olduğunu düşünüyorum; makineler bunu tamamen yerine getiremez.",
                level: "B2"
            ),
            Speaking(
                question: "Please speak the text below",
                speakingLabel: "Vejetaryen olmak karbon salımını azaltabilir, ancak herkes bu yaşam tarzını benimseyemez ya da istemeyebilir. Dengeli ve uygulanabilir çözümler bulmak önemlidir.",
                level: "B2"
            )
        ]
        loadCurrentQuestion()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopSpeaking()

    }
    
    private func setNotification(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onSpeechEnd),
            name: .aiSpeechFinished,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onSpeechReady),
            name: .aiSpeechDidStart,
            object: nil
        )
    }
    
    @objc private func onSpeechEnd() {
        listeningButton.setImage(UIImage(systemName: "speaker"), for: .normal)
        isListeningsButtonClicked = false
    }
    @objc private func onSpeechReady() {
        speakingActivity.stopAnimating()
        setSpeakingActivityHidden()
    }
    private func loadCurrentQuestion(){
        questionLabel.text = questions[currentIndex].question
        speakingLabel.text = questions[currentIndex].speakingLabel
    }
    private func setSpeakingActivityHidden(){
        speakingActivity.alpha = 0
        speakingActivity.isUserInteractionEnabled = false
    }
    
    private func setListeningButton(){
        listeningButton.setImage(UIImage(systemName: "speaker"), for: .normal)
        listeningButton.tintColor = .mintGreen
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
        isMicButtonClicked.toggle()
            if isMicButtonClicked {
                if speaksLeftCount > 0 {
                    let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular)
                    let micImage = UIImage(systemName: "microphone.fill", withConfiguration: largeConfig)
                    
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
        listeningButton.setImage(UIImage(systemName: "speaker"), for: .normal)
        speakingActivity.stopAnimating()
        setSpeakingActivityHidden()
        viewModel.stopSpeaking()

        customContinueView.animateIn()
        customContinueView.continueButton.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
    }
    
    @objc func nextQuestion(){
        customContinueView.isHidden = true
        checkButton.isHidden = false
        isListeningsButtonClicked = false
        isMicButtonClicked = false
        
        currentIndex += 1
        setListeningButton()
        loadCurrentQuestion()
        
        
    }
    @IBAction func listeningButtonClicked(_ sender: Any) {
        isListeningsButtonClicked.toggle()
        if isListeningsButtonClicked{
            listeningButton.setImage(UIImage(systemName: "speaker.fill"), for: .normal)
            speakingActivity.startAnimating()
            speakingActivity.alpha = 1
            
            viewModel.startSpeaking(text: questions[currentIndex].speakingLabel)
        }else{
            setListeningButton()
            speakingActivity.stopAnimating()
            setSpeakingActivityHidden()
            viewModel.stopSpeaking()

        }
    }
    
}
