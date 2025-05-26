//
//  AIChatTableViewCell.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 22.03.2025.
//

import UIKit
import SwiftOpenAI

class AIChatTableViewCell: UITableViewCell {
    static let identifier = "AIChatTableViewCell"

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .darkBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let typingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .darkBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var bubbleLeadingConstraint: NSLayoutConstraint!
    private var bubbleTrailingConstraint: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .backDarkBlue
        selectionStyle = .none
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        contentView.addSubview(typingIndicator)
        bubbleView.addSubview(timestampLabel)
        bubbleLeadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
        bubbleTrailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)

        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 250),

            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 15),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -15),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -10),
            
            typingIndicator.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor),
            typingIndicator.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor),
            
            timestampLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 5),
            timestampLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -2),
            timestampLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with message: MessageChatGPT) {
        if message.role == .user {
            bubbleView.backgroundColor = .summer
            messageLabel.textAlignment = .right
            messageLabel.textColor = .darkBlue
            bubbleTrailingConstraint.isActive = true
            bubbleLeadingConstraint.isActive = false
        } else {
            bubbleView.backgroundColor = .porcelain
            messageLabel.textAlignment = .left
            bubbleTrailingConstraint.isActive = false
            bubbleLeadingConstraint.isActive = true
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let timeString = dateFormatter.string(from: Date())
        timestampLabel.text = timeString

        if message.text.isEmpty {
            messageLabel.text = nil
            timestampLabel.isHidden = true
            typingIndicator.startAnimating()
        } else {
            messageLabel.text = message.text
            typingIndicator.stopAnimating()
            timestampLabel.isHidden = false

        }
    }
}


