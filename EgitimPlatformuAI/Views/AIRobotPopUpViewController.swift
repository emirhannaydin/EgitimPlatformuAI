//
//  AIRobotPopUpViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 7.05.2025.
//

import UIKit

final class AIRobotPopupViewController: UIViewController {
    
    private let message: String
    private let imageName: String
    private var typingTimer: Timer?
    private var isTypingInterrupted = false

    init(message: String, imageName: String = "robot_ai") {
        self.message = message
        self.imageName = imageName
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
    
    private let robotImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 40
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
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
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        robotImageView.image = UIImage(named: imageName)
        animateMessageTyping(text: message)
        okButton.alpha = 0
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
        backgroundView.frame = view.bounds
        
        view.addSubview(robotImageView)
        view.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        view.addSubview(okButton)

        NSLayoutConstraint.activate([
            robotImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            robotImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -140),
            robotImageView.widthAnchor.constraint(equalToConstant: 80),
            robotImageView.heightAnchor.constraint(equalToConstant: 80),

            bubbleView.topAnchor.constraint(equalTo: robotImageView.bottomAnchor, constant: 20),
            bubbleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bubbleView.widthAnchor.constraint(equalToConstant: 280),
            
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -16),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -16),

            okButton.topAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 20),
            okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        okButton.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
    }

    @objc private func dismissPopup() {
        dismiss(animated: true)
    }
}
