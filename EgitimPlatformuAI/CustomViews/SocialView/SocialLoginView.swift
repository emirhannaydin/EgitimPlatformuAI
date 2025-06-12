//
//  SocialLoginView.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 6.04.2025.
//

import UIKit

@IBDesignable
final class SocialLoginView: UIView {

    private let leftLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        return view
    }()
    
    private let rightLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Or Register with"
        label.textColor = .white
        label.font = UIFont(name: "Helvetica Neue Bold", size: 14.0)
        label.textAlignment = .center
        return label
    }()
    
    let facebookButton = SocialButton(iconName: "facebook")
    let googleButton = SocialButton(iconName: "google")
    let appleButton = SocialButton(iconName: "apple")
    
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [facebookButton, googleButton, appleButton])
        stack.axis = .horizontal
        stack.spacing = 2
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()
    
    private var topStackView = UIStackView()
    
    @IBInspectable var titleText: String = "Or Register with" {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        titleLabel.text = titleText
        setupTopStack()
        setupUI()
    }

    private func setupTopStack() {
        topStackView = UIStackView(arrangedSubviews: [leftLine, titleLabel, rightLine])
        topStackView.axis = .horizontal
        topStackView.spacing = 2
        topStackView.distribution = .fillEqually
        topStackView.alignment = .center
        
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        rightLine.translatesAutoresizingMaskIntoConstraints = false
        leftLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        rightLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private func setupUI() {
        addSubview(topStackView)
        addSubview(buttonsStack)
        
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: topAnchor),
            topStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            buttonsStack.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 24),
            buttonsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            buttonsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            buttonsStack.heightAnchor.constraint(equalToConstant: 50),
            buttonsStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
