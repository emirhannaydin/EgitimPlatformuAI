//
//  CustomAlertView.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 16.06.2025.
//

import UIKit
import Lottie

final class CustomAlertView: UIView {

    private let animationView = LottieAnimationView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let okButton = UIButton(type: .system)
    private var okAction: (() -> Void)?

    init(title: String, message: String, lottieName: String, okAction: (() -> Void)?) {
        super.init(frame: .zero)
        self.okAction = okAction
        setupView()
        configureLottie(named: lottieName)
        titleLabel.text = title
        messageLabel.text = message
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor.backDarkBlue
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 4)
        translatesAutoresizingMaskIntoConstraints = false

        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce

        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white

        messageLabel.font = .systemFont(ofSize: 16)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .paleGray

        okButton.setTitle("Okey", for: .normal)
        okButton.setTitleColor(.darkBlue, for: .normal)
        okButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        okButton.backgroundColor = UIColor.summer
        okButton.layer.cornerRadius = 8
        okButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        okButton.addTarget(self, action: #selector(okTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [titleLabel, animationView, messageLabel, okButton])
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalToConstant: 120),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }

    private func configureLottie(named name: String) {
        animationView.animation = LottieAnimation.named(name)
        animationView.play()
    }

    @objc private func okTapped() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            self.superview?.alpha = 0
        }) { _ in
            self.superview?.removeFromSuperview()
        }

        okAction?()
    }
}
