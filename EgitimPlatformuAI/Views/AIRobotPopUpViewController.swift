//
//  AIRobotPopUpViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 7.05.2025.
//

import UIKit
import Lottie

final class AIRobotPopupViewController: UIViewController {
    
    private let message: String
    private var typingTimer: Timer?
    private var isTypingInterrupted = false

    init(message: String) {
        self.message = message
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let robotLottieView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "robot")
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        return animation
    }()

    
    private let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkBlue
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let okButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("I got it!", for: .normal)
        button.setTitleColor(.mintGreen, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        animateMessageTyping(text: message)
        okButton.alpha = 0
        robotLottieView.play()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userInterruptedTyping))
        view.addGestureRecognizer(tapGesture)

    }
    @objc private func userInterruptedTyping() {
        if typingTimer != nil {
            isTypingInterrupted = true
        }
    }

    private func animateMessageTyping(text: String) {
        messageLabel.text = ""
        var currentIndex = 0
        let characters = Array(text)
        
        typingTimer?.invalidate()
        isTypingInterrupted = false

        typingTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
            if self.isTypingInterrupted {
                timer.invalidate()
                self.messageLabel.text = text
                UIView.animate(withDuration: 0.3) {
                    self.okButton.alpha = 1
                }
                return
            }
            
            if currentIndex < characters.count {
                self.messageLabel.text?.append(characters[currentIndex])
                currentIndex += 1
            } else {
                timer.invalidate()
                UIView.animate(withDuration: 0.3) {
                    self.okButton.alpha = 1
                }
            }
        }
    }

    private func setupLayout() {
        view.addSubview(backgroundView)

        let contentStack = UIStackView(arrangedSubviews: [robotLottieView, bubbleView])
        contentStack.axis = .horizontal
        contentStack.spacing = 12
        contentStack.alignment = .center
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(contentStack)
        bubbleView.addSubview(messageLabel)
        view.addSubview(okButton)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            robotLottieView.widthAnchor.constraint(equalToConstant: 100),
            robotLottieView.heightAnchor.constraint(equalToConstant: 100),
            
            bubbleView.widthAnchor.constraint(equalToConstant: 240),

            contentStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),

            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -16),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -16),

            okButton.topAnchor.constraint(equalTo: contentStack.bottomAnchor, constant: 20),
            okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        okButton.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
    }


    @objc private func dismissPopup() {
        dismiss(animated: true)
    }
    
}
