//
//  LetterCell.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.06.2025.
//

import UIKit

class LetterCell: UICollectionViewCell {
    
    private let letterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(letterLabel)
        letterLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            letterLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            letterLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with letter: String) {
        letterLabel.text = letter
        letterLabel.alpha = letter.isEmpty ? 0 : 1
    }
}
