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
    private var questions: [ListeningWord] = []
    private var currentIndex = 0
    private var listensLeft = 3
    private var correctText = ""
    private var levelStats: [String: (correct: Int, total: Int)] = [:]


    @IBOutlet var questionNumber: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        listensLeftLabel.text = "Listens Left: \(listensLeft)"
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
                hearingSound: "Kitap",
                options: ["Kalem", "Kitap", "Elma", "Ev"],
                correctAnswer: "Kitap",
                level: "A1"
            ),
            ListeningWord(
                question: "Which word matches the sound?",
                hearingSound: "Kapı",
                options: ["Kapı", "Masa", "Çanta", "Pencere"],
                correctAnswer: "Kapı",
                level: "A1"
            ),

            ListeningWord(
                question: "Who is being described?",
                hearingSound: "O bir öğretmen",
                options: ["Ben bir doktorum", "O bir öğretmen", "Sen öğrencisin", "Biz evdeyiz"],
                correctAnswer: "O bir öğretmen",
                level: "A2"
            ),
            ListeningWord(
                question: "What is the person doing?",
                hearingSound: "Kitap okuyorum",
                options: ["Oyun oynuyorum", "Kitap okuyorum", "Ders çalışıyorum", "Uyuyorum"],
                correctAnswer: "Kitap okuyorum",
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
                correctAnswer: "Yemekten sonra sinemaya gittik",
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
                correctAnswer: "Trafik yüzünden geç kaldım",
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
                correctAnswer: "Egzersiz yapmak sağlığımız için önemlidir",
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
                correctAnswer: "Yabancı dil öğrenmek kariyer için avantajlıdır",
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
                correctAnswer: "Eleştirel düşünmek",
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
                correctAnswer: "Kültürel zekâ geliştirmek",
                level: "C2"
            ),
            
        ]

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        self.navigationController?.isNavigationBarHidden = false

        }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        viewModel.stopAIListening()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .aiMessageUpdated, object: nil)
    }
    
    private func loadCurrentQuestion() {
        lottieView.isHidden = false
        tapToSoundImageLabel.isHidden = false
        cantListenLabel.isHidden = true
        guard currentIndex < questions.count else {
            let level = evaluateUserLevel()
            UserDefaults.standard.set(level, forKey: "listeningLevel")
            showAlert(title: "Test Bitti", message: "Tahmini seviyeniz: \(level)")
            courseType.markUserAsEnrolled()
            return
        }

        
        let currentQuestion = questions[currentIndex]
        questionNumber.text = "\(currentIndex + 1)/\(questions.count)"
        questionLabel.text = currentQuestion.question
        listensLeft = 3
        listensLeftLabel.text = "Listens Left: \(listensLeft)"
        listensLeftLabel.textColor = .lightGray
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

        DispatchQueue.main.async {
            self.hideLottieLoading()

            let popup = AIRobotPopupViewController(message: message)
            self.present(popup, animated: true)
            self.customContinueView.animateIn()
        }
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
            viewModel.startAIListening(text:questions[currentIndex].hearingSound)
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
        viewModel.stopAIListening()

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
        customContinueView.isHidden = false
        
        let level = currentQuestion.level
        if levelStats[level] == nil {
            levelStats[level] = (0, 0)
        }
        levelStats[level]?.total += 1

        if selectedText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ==
            currentQuestion.correctAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
            levelStats[level]?.correct += 1
            self.hideLottieLoading()
            cell.contentView.backgroundColor = .systemGreen
            customContinueView.setCorrectAnswer()

            customContinueView.animateIn()
            customContinueView.continueButton.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)

        } else {
            cell.contentView.backgroundColor = .systemRed
            customContinueView.setWrongAnswer()

            let aiMessage = """
            You are evaluating a listening comprehension question.

            Sound played to the user: "\(currentQuestion.hearingSound)"
            Question asked: "\(currentQuestion.question)"
            Answer options: \(currentQuestion.options)
            User's selected answer: "\(selectedText)"
            Correct answer: "\(currentQuestion.correctAnswer)"

            Your task:
            - Respond only if the user's answer is incorrect.
            - Format: "You selected 'USER_ANSWER', but the correct answer is 'CORRECT_ANSWER'. [One-sentence encouraging remark.]"
            """

            viewModel.sendMessage(aiMessage)
        }
    }

    private func evaluateUserLevel() -> String {
        let levelOrder = ["C2", "C1", "B2", "B1", "A2", "A1"]
        let maxAllowedLevel = "B2"
        
        // B2’den yüksek seviyeleri dışla
        let allowedLevels = levelOrder.drop { $0 > maxAllowedLevel }

        for level in allowedLevels {
            if let stats = levelStats[level], stats.total > 0 {
                let accuracy = Double(stats.correct) / Double(stats.total)
                if accuracy >= 0.8 {
                    return level
                }
            }
        }
        return "A1"
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
