import UIKit

final class PasswordRulesView: UIView {
    
    private let titleLabel = UILabel()
    let uppercaseRuleLabel = UILabel()
    let lowercaseRuleLabel = UILabel()
    let specialCharRuleLabel = UILabel()
    let lengthRuleLabel = UILabel()
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.text = "Your password must include:"
        titleLabel.textColor = .summer
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        [uppercaseRuleLabel, lowercaseRuleLabel, specialCharRuleLabel, lengthRuleLabel].forEach {
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.textColor = .red
            stackView.addArrangedSubview($0)
        }

        addSubview(titleLabel)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        updateRules(for: "")
    }

    func updateRules(for password: String) {
        let hasUppercase = password.hasUppercase
        let hasLowercase = password.hasLowercase
        let hasSpecialChar = password.hasSpecialCharacter
        let hasMinLength = password.hasMinimumLength

        set(label: uppercaseRuleLabel, valid: hasUppercase, text: "At least 1 uppercase letter")
        set(label: lowercaseRuleLabel, valid: hasLowercase, text: "At least 1 lowercase letter")
        set(label: specialCharRuleLabel, valid: hasSpecialChar, text: "At least 1 special character (!@#$&*_.? -)")
        set(label: lengthRuleLabel, valid: hasMinLength, text: "At least 8 characters")

        if hasUppercase && hasLowercase && hasSpecialChar && hasMinLength {
            titleLabel.text = "Your password meets all requirements"
            titleLabel.textColor = .mintGreen
        } else {
            titleLabel.text = "Your password must include:"
            titleLabel.textColor = .summer
        }
    }

    private func set(label: UILabel, valid: Bool, text: String) {
        let symbol = valid ? "✔︎" : "✘"
        let color: UIColor = valid ? .mintGreen : .softRed
        let fullText = "\(symbol) \(text)"
        
        let attributedText = NSMutableAttributedString(string: fullText)
        attributedText.addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: 1))
        label.attributedText = attributedText
        label.textColor = color
    }
}
