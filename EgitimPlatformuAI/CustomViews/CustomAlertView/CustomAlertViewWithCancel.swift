//
//  CustomAlertViewWithCancel.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 16.06.2025.
//

import UIKit

final class CustomAlertViewWithCancel: UIView {

    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let okButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private var okAction: (() -> Void)?

    init(title: String, message: String, okAction: (() -> Void)?) {
        super.init(frame: .zero)
        self.okAction = okAction
        setupView()
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

        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white

        messageLabel.font = .systemFont(ofSize: 16)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .paleGray

        okButton.setTitle("OK", for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        okButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        okButton.backgroundColor = UIColor.summer
        okButton.layer.cornerRadius = 8
        okButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        okButton.addTarget(self, action: #selector(okTapped), for: .touchUpInside)

        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16)
        cancelButton.layer.borderColor = UIColor.white.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 8
        cancelButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        let buttonStack = UIStackView(arrangedSubviews: [cancelButton, okButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually

        let stack = UIStackView(arrangedSubviews: [titleLabel, messageLabel, buttonStack])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }

    @objc private func okTapped() {
        dismiss()
        okAction?()
    }

    @objc private func cancelTapped() {
        dismiss()
    }

    private func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            self.superview?.alpha = 0
        }) { _ in
            self.superview?.removeFromSuperview()
        }
    }
}

