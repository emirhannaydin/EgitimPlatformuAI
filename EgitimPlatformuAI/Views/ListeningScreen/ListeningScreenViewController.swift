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
    private var currentIndex = 0
    private var listensLeft = 3
    private var correctText = ""


    @IBOutlet var questionNumber: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.showLottieLoading()
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        listensLeftLabel.text = "Listens Left: \(listensLeft)"
        setTapGesture()
        setLottie()
        setNotification()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        self.navigationController?.isNavigationBarHidden = false

        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setLessonData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        viewModel.stopAIListening()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .aiMessageUpdated, object: nil)
    }
    
    private func setLessonData(){
        if let lessonId = viewModel.lessonId{
            viewModel.loadLessonData(lessonId: lessonId) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result{
                        case(.success(_)):
                        self.questionNumber.text = "\(self.currentIndex + 1)/\(self.viewModel.questions.count)"
                        self.loadCurrentQuestion()
                        self.setCollectionView()
                        self.collectionView.reloadData()
                        self.hideLottieLoading()
                        case ( .failure(let error)):
                        print(error)
                        
                    }
                }
            
            }
        }
    }
    
    private func loadCurrentQuestion() {
        lottieView.isHidden = false
        tapToSoundImageLabel.isHidden = false
        cantListenLabel.isHidden = true
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
                        self.showAlert(title: "Hata", message: error.localizedDescription, lottieName: "error")
                    }
                }
            }
            return
        }
        let currentQuestion = viewModel.questions[currentIndex]
        questionNumber.text = "\(currentIndex + 1)/\(viewModel.questions.count)"
        questionLabel.text = currentQuestion.questionString
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
            let listeningText = viewModel.questions[currentIndex].listeningSentence
            viewModel.startAIListening(text: listeningText)
            
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
            self.showAlert(title: "Error", message: "Choose one", lottieName: "error")
            return
        }

        let currentQuestion = viewModel.questions[currentIndex]
        collectionView.allowsSelection = false
        checkButton.isHidden = true
        cantHearButton.isHidden = true
        customContinueView.isHidden = false

        if selectedText.cleanedForComparison() == currentQuestion.correctAnswer?.cleanedForComparison() {
            self.hideLottieLoading()
            cell.contentView.backgroundColor = .systemGreen
            customContinueView.setCorrectAnswer()
            
        } else {
            cell.contentView.backgroundColor = .systemRed
            customContinueView.setWrongAnswer()

            let aiMessage = """
            You are evaluating a listening comprehension question.

            Sound played to the user: "\(currentQuestion.listeningSentence)"
            Question asked: "\(currentQuestion.questionString)"
            Answer options: \(currentQuestion.options)
            User's selected answer: "\(selectedText)"
            Correct answer: "\(currentQuestion.correctAnswer)"

            Your task:
            - Respond only if the user's answer is incorrect.
            - Format: "You selected 'USER_ANSWER', but the correct answer is 'CORRECT_ANSWER'. [One-sentence encouraging remark.]"
            """

            viewModel.sendMessage(aiMessage)
        }
        customContinueView.animateIn()
        customContinueView.continueButton.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
    }

    @IBAction func cantHearButton(_ sender: Any) {
        let listeningText = viewModel.questions[currentIndex].listeningSentence
        cantListenLabel.text = "\(listeningText)"
        
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
        return viewModel.questions[currentIndex].options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let label = UILabel()
        label.text = viewModel.questions[currentIndex].options[indexPath.item]
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

        let optionText = "asd"
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
