//
//  SocialButton.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 6.04.2025.
//

import UIKit

final class SocialButton: UIButton {
    
    init(iconName: String) {
        super.init(frame: .zero)
        setupUI(iconName: iconName)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI(iconName: "")
    }
    
    private func setupUI(iconName: String) {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        backgroundColor = .white
        clipsToBounds = true
        
        setImage(UIImage(named: iconName), for: .normal)
        imageView?.contentMode = .scaleAspectFit
    }
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.systemGray : .white
        }
    }

}
