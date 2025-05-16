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
    private var listeningLabel: String = ""
    private var listensLeft = 3
    
    @IBOutlet var questionNumber: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        questionNumber.text = "\(currentIndex + 1)/\(questions.count)"
        setRandomListeningLabel()
        setupQuestions()
        loadCurrentQuestion()
        setCollectionView()
        setTapGesture()
        setLottie()
        setNotification()

    }
    
    private func setupQuestions() {
        questions = [
            // A1 - Basit nesneler ve temel kelimeler
            ListeningWord(options: ["Elma", "Kalem", "Kitap", "Ev"], level: "A1"),
            ListeningWord(options: ["Masa", "Kapı", "Sandalye", "Pencere"],level: "A1"),
            
            // A2 - Temel cümleler ve günlük ifadeler
            ListeningWord(options: ["Benim adım Ali", "O bir öğretmen", "Bu bir kalemdir", "Annem evde"],level: "A2"),
            ListeningWord(options: ["Okula gidiyorum", "Kardeşim oyun oynuyor", "Kitap okuyorum", "Arkadaşım sinemaya gitti"],level: "A2"),
            
            // B1 - Bağlaçlı ve basit yapılı cümleler
            ListeningWord(options: ["Yemekten sonra sinemaya gittik", "Hava güzeldi, dışarı çıktık", "Yeni bir telefon aldım", "Kitabı çok beğendim"],level: "B1"),
            ListeningWord(options: ["Sabah erken kalkıp yürüyüş yaptım", "Trafik yüzünden geç kaldım", "Film beklediğimden güzeldi", "Misafirler geldiğinde ev hazırdı"],level: "B1"),
            
            // B2 - Sebep-sonuç ve açıklayıcı cümleler
            ListeningWord(options: ["Egzersiz yapmak sağlığımız için önemlidir", "Teknoloji hayatımızı kolaylaştırıyor", "Düzenli uyku verimli çalışmayı sağlar", "Gürültü yüzünden odaklanamıyorum"],level: "B2"),
            ListeningWord(options: ["Yabancı dil öğrenmek kariyer için avantajlıdır", "İyi bir sunum hazırlık gerektirir", "Sosyal medya dikkat dağıtabilir", "Kitap okumak kelime dağarcığını geliştirir"],level: "B2"),
            
            // C1 - Akademik ve soyut içerikli cümleler
            ListeningWord(options: ["Eleştirel düşünme, problemi farklı açılardan değerlendirmeyi gerektirir", "Zaman yönetimi, akademik başarıyı etkileyen önemli bir beceridir", "Karmaşık metinleri anlamak ileri düzey okuryazarlık ister", "İletişim becerileri, iş hayatında büyük rol oynar"],level: "C1"),
            ListeningWord(options: ["Disiplinler arası düşünce yapısı, yaratıcı çözümler üretmeyi sağlar", "Kültürel farklılıkları anlamak empatiyi artırır", "Yapay zekâ etik soruları da beraberinde getirir", "Globalleşme çok yönlü düşünmeyi zorunlu kılar"],level: "C1")
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
        listeningLabel = currentQuestion.options.randomElement() ?? ""
        listensLeft = 3
        listensLeftLabel.text = "Listens Left: \(listensLeft)"
        setRandomListeningLabel()
        collectionView.reloadData()
    }

    private func setRandomListeningLabel() {
        guard currentIndex < questions.count else { return }
        if let randomWord = questions[currentIndex].options.randomElement() {
            listeningLabel = randomWord
        }
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
        let popup = AIRobotPopupViewController(message: message)
        DispatchQueue.main.async {
            self.hideLottieLoading()
            self.present(popup, animated: true)
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
            tts.speak(text:listeningLabel)
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
              let selectedText = label.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            else {
            self.hideLottieLoading()
            self.showAlert(title: "Error", message: "Choose one")
            return
        }
        let correctText = listeningLabel.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let aiMessage = """
        The user listened to a word and tried to understand its meaning.
        Correct answer: "\(correctText)"
        User's response: "\(selectedText)"

        Please evaluate the response:
        - If the user's choice is correct, clearly confirm it and provide a short, encouraging remark such as "Yes, this is the correct answer. Well done!" End your sentence there.
        - If the answer is incorrect, say something like: "You selected '\(selectedText)', but the correct answer is '\(correctText)'."  Instead, provide a new, one-sentence encouraging remark that is different from any previous messages. Gently highlight that focused listening helps. Avoid repeating phrases or structures.

        """
        
        checkButton.isHidden = true
        cantHearButton.isHidden = true
        customContinueView.isHidden = false
        if selectedText == correctText {
            self.hideLottieLoading()
            cell.contentView.backgroundColor = .systemGreen
            customContinueView.setCorrectAnswer()
            
        }else{
            viewModel.sendMessage(aiMessage)
            cell.contentView.backgroundColor = .systemRed
            customContinueView.setWrongAnswer()
        }
        collectionView.allowsSelection = false
        customContinueView.animateIn()
        customContinueView.continueButton.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
        
        
    }
    
    @IBAction func cantHearButton(_ sender: Any) {
        cantListenLabel.text = listeningLabel
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
