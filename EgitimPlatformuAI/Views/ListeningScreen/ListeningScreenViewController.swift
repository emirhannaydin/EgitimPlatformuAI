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
    @IBOutlet var tapToSoundImageLabel: UILabel!
    private var tts: TextToSpeech = TextToSpeech()
    private var listeningLabel = "Bir "
    private let data = ["Bir", "İki", "Üç", "Dört"]
    private var listensLeft = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        setCollectionView()
        setTapGesture()
        setLottie()
        setNotification()
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
        self.navigationController?.isNavigationBarHidden = false
        }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .aiMessageUpdated, object: nil)
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
            self.present(popup, animated: true){
                self.hideLottieLoading()
            }
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
        lottieView.layer.borderWidth = 1
        lottieView.layer.cornerRadius = 12
        lottieView.backgroundColor = .black
        
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
        - If the answer is incorrect, say something like: "You selected '\(selectedText)', but the correct answer is '\(correctText)'." Avoid saying “wrong.” Then, briefly encourage the user by explaining that careful and focused listening can greatly improve understanding — for example, "With a bit more focus during listening, you'll catch it more easily next time." Do not suggest trying again. Finish your explanation in one sentence.
        """
        viewModel.sendMessage(aiMessage)
    }
    
    @IBAction func cantHearButton(_ sender: Any) {
        cantListenLabel.text = listeningLabel
        lottieView.isHidden = true
        tapToSoundImageLabel.isHidden = true
        cantListenLabel.isHidden = false
        
    }
    
}

extension ListeningScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let label = UILabel(frame: cell.contentView.bounds)
        label.text = data[indexPath.item]
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white

        cell.contentView.layer.cornerRadius = 12
        cell.contentView.layer.borderWidth = 1
        cell.contentView.clipsToBounds = true
        cell.contentView.backgroundColor = .darkBlue

        cell.contentView.addSubview(label)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.mintGreen

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
