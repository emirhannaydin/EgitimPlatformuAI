//
//  ListeningScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 28.04.2025.
//

import Foundation
import UIKit
import Lottie

final class ListeningScreenViewController: UIViewController {
    
    
    var viewModel: ListeningScreenViewModel!
    var courseType: CourseType = .listening

    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var listensLeftLabel: UILabel!
    @IBOutlet var lottieView: LottieAnimationView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var checkButton: UIButton!
    @IBOutlet var backButton: CustomBackButtonView!
    @IBOutlet var cantListenLabel: UILabel!
    @IBOutlet var cantHearButton: UIButton!
    @IBOutlet var tapToSoundImageLabel: UILabel!
    @IBOutlet var customContinueView: CustomContinueView!
    private var tts: TextToSpeech = TextToSpeech()
    private var questions: [ListeningWord] = []
    private var currentIndex = 0
    private var listensLeft = 3
    private var correctText = ""

    @IBOutlet var questionNumber: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        questionNumber.text = "\(currentIndex + 1)/\(questions.count)"
        setupQuestions()
        loadCurrentQuestion()
        setCollectionView()
        setTapGesture()
        setLottie()
        setNotification()

    }
    
    private func setupQuestions() {
        questions = [
            ListeningWord(
                question: "Which word did you hear?",
                hearingSound: "Elma",
                options: ["Kalem", "Kitap", "Elma", "Ev"],
                level: "A1"
            ),
            ListeningWord(
                question: "Which word matches the sound?",
                hearingSound: "Kapı",
                options: ["Kapı", "Masa", "Çanta", "Pencere"],
                level: "A1"
            ),

            ListeningWord(
                question: "Who is being described?",
                hearingSound: "O bir öğretmen",
                options: ["Ben bir doktorum", "O bir öğretmen", "Sen öğrencisin", "Biz evdeyiz"],
                level: "A2"
            ),
            ListeningWord(
                question: "What is the person doing?",
                hearingSound: "Kitap okuyorum",
                options: ["Oyun oynuyorum", "Kitap okuyorum", "Ders çalışıyorum", "Uyuyorum"],
                level: "A2"
            ),

            ListeningWord(
                question: "What happened before going to the cinema?",
                hearingSound: "Yemekten sonra sinemaya gittik",
                options: [
                    "Sinema iptal oldu",
                    "Önce ders çalıştık",
                    "Yemekten sonra sinemaya gittik",
                    "Sinema çok uzaktaydı"
                ],
                level: "B1"
            ),
            ListeningWord(
                question: "Why was the person late?",
                hearingSound: "Trafik yüzünden geç kaldım",
                options: [
                    "Otobüs erken geldi",
                    "Erken uyandım",
                    "Trafik yüzünden geç kaldım",
                    "Yürüyerek geldim"
                ],
                level: "B1"
            ),

            ListeningWord(
                question: "What is important for health?",
                hearingSound: "Egzersiz yapmak sağlığımız için önemlidir",
                options: [
                    "Film izlemek faydalıdır",
                    "Egzersiz yapmak sağlığımız için önemlidir",
                    "Tatlı yemek iyi gelir",
                    "Yalnız kalmak sağlıklıdır"
                ],
                level: "B2"
            ),
            ListeningWord(
                question: "What is useful for a career?",
                hearingSound: "Yabancı dil öğrenmek kariyer için avantajlıdır",
                options: [
                    "Tatilde dinlenmek önemlidir",
                    "Yabancı dil öğrenmek kariyer için avantajlıdır",
                    "Alışveriş yapmak güzeldir",
                    "Kitap okumak hobi olabilir"
                ],
                level: "B2"
            ),

            ListeningWord(
                question: "What does critical thinking involve?",
                hearingSound: "Eleştirel düşünme, problemi farklı açılardan değerlendirmeyi gerektirir",
                options: [
                    "Ezberlemek",
                    "Tek yönden bakmak",
                    "Eleştirel düşünmek",
                    "Yüzeysel düşünmek"
                ],
                level: "C1"
            ),
            ListeningWord(
                question: "What is necessary for academic success?",
                hearingSound: "Zaman yönetimi, akademik başarıyı etkileyen önemli bir beceridir",
                options: [
                    "Sabah uyanmak",
                    "Zaman yönetimi",
                    "Telefonla çalışmak",
                    "Kütüphane gezmek"
                ],
                level: "C1"
            ),

            ListeningWord(
                question: "What is essential in a globalized world?",
                hearingSound: "Globalleşme çağında, bireylerin kültürel zekâ geliştirmesi kaçınılmaz bir gereklilik haline gelmiştir",
                options: [
                    "Farklı dilleri bilmek",
                    "Kültürel zekâ geliştirmek",
                    "Evde çalışmak",
                    "Tatilde kitap okumak"
                ],
                level: "C2"
            ),
            ListeningWord(
                question: "What is the benefit of interdisciplinary thinking?",
                hearingSound: "Disiplinler arası çalışmalar, bilgiyi bütüncül bir yaklaşımla değerlendirme olanağı sağlar",
                options: [
                    "Çok kitap okumak",
                    "Yaratıcı çözümler üretmek",
                    "Yalnız çalışmak",
                    "Ders notlarını ezberlemek"
                ],
                level: "C2"
            )
        ]

    }

    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
        self.navigationController?.isNavigationBarHidden = false
        listensLeftLabel.text = viewModel?.listensLeftText

        }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .aiMessageUpdated, object: nil)
    }
    
    private func loadCurrentQuestion() {
        lottieView.isHidden = false
        tapToSoundImageLabel.isHidden = false
        cantListenLabel.isHidden = true
        guard currentIndex < questions.count else {
            showAlert(title: "Bitti", message: "Tüm sorular tamamlandı.")
            courseType.markUserAsEnrolled()
            return
        }
        
        let currentQuestion = questions[currentIndex]
        questionNumber.text = "\(currentIndex + 1)/\(questions.count)"
        questionLabel.text = currentQuestion.question
        listensLeft = 3
        listensLeftLabel.text = "Listens Left: \(listensLeft)"
        collectionView.reloadData()
    }

    

    private func setNotification(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAIFinalMessage),
            name: .aiMessageFinished,
            object: nil
        )
    }
    
    @objc private func handleAIFinalMessage() {
        let message = AIAPIManager.shared.currentMessage.text.trimmingCharacters(in: .whitespacesAndNewlines)
        print(message)
        if message.contains("Yes, this is the correct answer") {
            DispatchQueue.main.async {
                self.hideLottieLoading()
                self.customContinueView.setCorrectAnswer()
            }
        } else {
            DispatchQueue.main.async {
                let popup = AIRobotPopupViewController(message: message)
                self.hideLottieLoading()
                self.present(popup, animated: true)
                self.customContinueView.setWrongAnswer()
            }
        }

        self.collectionView.allowsSelection = false
        self.checkButton.isHidden = true
        self.cantHearButton.isHidden = true
        self.customContinueView.isHidden = false
        self.customContinueView.animateIn()
        self.customContinueView.continueButton.addTarget(self, action: #selector(self.nextQuestion), for: .touchUpInside)
    }


    
    private func setCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    private func setTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCollectionViewTap))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    private func setLottie(){
        let animation = LottieAnimation.named("listeningScreen")
        lottieView.animation = animation
        lottieView.contentMode = .scaleAspectFill
        lottieView.loopMode = .playOnce
        lottieView.backgroundColor = .clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLottieTap))
        lottieView.isUserInteractionEnabled = true
        lottieView.addGestureRecognizer(tapGesture)
    }
    @objc private func handleLottieTap() {
        if listensLeft > 0 {
            listensLeft -= 1
            listensLeftLabel.text = "Listens Left: \(listensLeft)"
            tts.speak(text:questions[currentIndex].hearingSound)
            tts.startSpeaking()
            lottieView.stop()
            lottieView.play()
        }else{
            listensLeftLabel.textColor = .systemRed
            animateLabelShake(listensLeftLabel)

        }
    }

    @objc private func handleCollectionViewTap() {
        for indexPath in collectionView.indexPathsForSelectedItems ?? [] {
            collectionView.deselectItem(at: indexPath, animated: true)
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.contentView.backgroundColor = UIColor.darkBlue
            }
        }
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
   
    @IBAction func checkButton(_ sender: Any) {
        self.showLottieLoading()

        guard let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first,
              let cell = collectionView.cellForItem(at: selectedIndexPath),
              let label = cell.contentView.subviews.first(where: { $0 is UILabel }) as? UILabel,
              let selectedText = label.text
        else {
            self.hideLottieLoading()
            self.showAlert(title: "Error", message: "Choose one")
            return
        }

        let currentQuestion = questions[currentIndex]
        collectionView.allowsSelection = false
        checkButton.isHidden = true
        cantHearButton.isHidden = true

        let aiMessage = """
        You are evaluating a listening comprehension question.

        Sound played to the user: "\(currentQuestion.hearingSound)"
        Question asked: "\(currentQuestion.question)"
        Answer options: \(currentQuestion.options)
        User's selected answer: "\(selectedText)"

        Your task:
        - First, identify the correct answer from the options based on the sound and the question.
        - Then compare it with the user's selection.
        - Respond with only the final evaluation — do not explain the correct answer selection logic.
        - Do not include any additional text before or after the response.

        Response format:
        - If correct: "Yes, this is the correct answer. Well done!"
        - If incorrect: "You selected 'USER_ANSWER', but the correct answer is 'CORRECT_ANSWER'. [One-sentence encouraging remark — different from earlier ones.]"
        """


        viewModel.sendMessage(aiMessage)
    }


    @IBAction func cantHearButton(_ sender: Any) {
        cantListenLabel.text = "\(questions[currentIndex].hearingSound)"
        lottieView.isHidden = true
        tapToSoundImageLabel.isHidden = true
        cantListenLabel.isHidden = false
        
    }
    
    @objc func nextQuestion(){
        collectionView.allowsSelection = true
        currentIndex += 1
        checkButton.isHidden = false
        cantHearButton.isHidden = false
        customContinueView.isHidden = true
        loadCurrentQuestion()

    }
    
}

extension ListeningScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questions[currentIndex].options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let label = UILabel()
        label.text = questions[currentIndex].options[indexPath.item]
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        cell.contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 12),
            label.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -12),
            label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16)
        ])

        cell.contentView.layer.cornerRadius = 12
        cell.contentView.layer.borderWidth = 2
        cell.contentView.layer.borderColor = UIColor.paleGray.cgColor
        cell.contentView.clipsToBounds = true
        cell.contentView.backgroundColor = .darkBlue

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.lightGray

    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.darkBlue
    }

}

extension ListeningScreenViewController: UIGestureRecognizerDelegate{
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            if touch.view is UIButton {
                return false
            }
            return true
        }

}

extension ListeningScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let optionText = questions[currentIndex].options[indexPath.item]
        let maxWidth = collectionView.bounds.width - 32

        let font = UIFont.systemFont(ofSize: 16)
        let maxSize = CGSize(width: maxWidth - 32, height: .greatestFiniteMagnitude)
        let attributes = [NSAttributedString.Key.font: font]
        let boundingBox = NSString(string: optionText).boundingRect(with: maxSize,
                                                                    options: .usesLineFragmentOrigin,
                                                                    attributes: attributes,
                                                                    context: nil)

        let textHeight = ceil(boundingBox.height)
        let baseHeight: CGFloat = 50

        let finalHeight = max(baseHeight, textHeight + 24)

        return CGSize(width: maxWidth, height: finalHeight)
    }
}
