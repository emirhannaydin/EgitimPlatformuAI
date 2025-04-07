//
//  SocialLoginView.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 6.04.2025.
//

import UIKit

final class SocialLoginView: UIView {
    
    // MARK: - UI Elements
    var stackView = UIStackView()
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
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14, weight: .medium)
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
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStackView()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setStackView()
        setupUI()
    }
    
    // MARK: - Layout
    private func setStackView() {
        stackView = UIStackView(arrangedSubviews: [leftLine, titleLabel, rightLine])
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        stackView.alignment = .center
    
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        rightLine.translatesAutoresizingMaskIntoConstraints = false
        leftLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        rightLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    private func setupUI() {
        addSubview(stackView)
        addSubview(buttonsStack)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            buttonsStack.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 24),
            buttonsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            buttonsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            buttonsStack.heightAnchor.constraint(equalToConstant: 50),
            buttonsStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
