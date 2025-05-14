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
            ListeningWord(options: ["Bir", "İki", "Üç", "Dört"]),
            ListeningWord(options: ["Elma", "Armut", "Çilek", "Karpuz"]),
            ListeningWord(options: ["Kedi", "Köpek", "Kuş", "Balık"]),
            ListeningWord(options: ["Mavi", "Kırmızı", "Yeşil", "Sarı"]),
            ListeningWord(options: ["Kalem", "Silgi", "Defter", "Kitap"]),
            ListeningWord(options: ["Araba", "Otobüs", "Tren", "Uçak"]),
            ListeningWord(options: ["Gece", "Sabah", "Öğle", "Akşam"]),
            ListeningWord(options: ["Göz", "Kulak", "Burun", "Yüz"]),
            ListeningWord(options: ["Tablet", "Telefon", "Televizyon", "Bilgisayar"]),
            ListeningWord(options: ["Su", "Süt", "Kola", "Meyve suyu"])
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

        let label = UILabel(frame: cell.contentView.bounds)
        label.text = questions[currentIndex].options[indexPath.item]
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white

        cell.contentView.layer.cornerRadius = 12
        cell.contentView.layer.borderWidth = 2
        cell.contentView.layer.borderColor = UIColor.paleGray.cgColor
        cell.contentView.clipsToBounds = true
        cell.contentView.backgroundColor = .darkBlue

        cell.contentView.addSubview(label)
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
