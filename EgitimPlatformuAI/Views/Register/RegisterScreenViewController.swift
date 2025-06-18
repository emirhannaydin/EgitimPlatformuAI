//
//  RegisterScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 28.03.2025.
//

import UIKit
class RegisterScreenViewController: UIViewController {
    
    
    @IBOutlet var socialLoginView: SocialLoginView!
    @IBOutlet var backButton: CustomBackButtonView!
    @IBOutlet var loginNowButton: UIButton!
    @IBOutlet var nameLabel: UITextField!
    @IBOutlet var emailLabel: UITextField!
    @IBOutlet var passwordLabel: UITextField!
    @IBOutlet var confirmPasswordLabel: UITextField!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var passwordRulesView: PasswordRulesView!
    var viewModel: RegisterScreenViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setupUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
        nameLabel.text = ""
        emailLabel.text = ""
        passwordLabel.text = ""
        confirmPasswordLabel.text = ""
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        view.endEditing(true)
        
    }
    private func setupUI(){
        applyGradientBackground()
        hideKeyboardWhenTappedAround()
        passwordLabel.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        
        registerButton.layer.cornerRadius = 8
        registerButton.layer.masksToBounds = true
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        setupPasswordToggle(for: passwordLabel)
        setupPasswordToggle(for: confirmPasswordLabel)
        passwordLabel.textContentType = .oneTimeCode
        passwordLabel.autocorrectionType = .no
        passwordLabel.autocapitalizationType = .none
        
        confirmPasswordLabel.textContentType = .oneTimeCode
        confirmPasswordLabel.autocorrectionType = .no
        confirmPasswordLabel.autocapitalizationType = .none
        
        nameLabel.layer.borderWidth = 1
        nameLabel.layer.borderColor = UIColor.systemGray.cgColor
        nameLabel.layer.cornerRadius = 8
        nameLabel.layer.masksToBounds = true
        nameLabel.attributedPlaceholder = NSAttributedString(
            string: "Enter your name",
            attributes: [.foregroundColor: UIColor.backDarkBlue.withAlphaComponent(0.5)]
        )
        emailLabel.layer.borderWidth = 1
        emailLabel.layer.borderColor = UIColor.systemGray.cgColor
        emailLabel.layer.cornerRadius = 8
        emailLabel.layer.masksToBounds = true
        emailLabel.attributedPlaceholder = NSAttributedString(
            string: "Enter your email",
            attributes: [.foregroundColor: UIColor.backDarkBlue.withAlphaComponent(0.5)]
        )
        passwordLabel.layer.borderWidth = 1
        passwordLabel.layer.borderColor = UIColor.systemGray.cgColor
        passwordLabel.layer.cornerRadius = 8
        passwordLabel.layer.masksToBounds = true
        passwordLabel.attributedPlaceholder = NSAttributedString(
            string: "Enter your password",
            attributes: [.foregroundColor: UIColor.backDarkBlue.withAlphaComponent(0.5)]
        )
        confirmPasswordLabel.layer.borderWidth = 1
        confirmPasswordLabel.layer.borderColor = UIColor.systemGray.cgColor
        confirmPasswordLabel.layer.cornerRadius = 8
        confirmPasswordLabel.layer.masksToBounds = true
        confirmPasswordLabel.attributedPlaceholder = NSAttributedString(
            string: "Confirm your password",
            attributes: [.foregroundColor: UIColor.backDarkBlue.withAlphaComponent(0.5)]
        )
        
        let loginText = "Login Now"
        let fullText = "Already have an account? \(loginText)"
        let attributedText = NSMutableAttributedString(string: fullText)
        
        let fullRange = NSRange(location: 0, length: fullText.count)
        attributedText.addAttribute(.font, value: UIFont(name: "HelveticaNeue", size: 15)!, range: fullRange)
        
        let loginRange = (fullText as NSString).range(of: loginText)
        attributedText.addAttribute(.foregroundColor, value: UIColor.summer, range: loginRange)
        attributedText.addAttribute(.font, value: UIFont(name: "HelveticaNeue-Bold", size: 15)!, range: loginRange)
        
        loginNowButton.setAttributedTitle(attributedText, for: .normal)
        
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginNowButtonClicked(_ sender: Any) {
        ApplicationCoordinator.getInstance().navigateToMainLogin()
    }
    
    @IBAction func registerButton(_ sender: Any) {
        guard let name = nameLabel.text, !name.isEmpty,
              let email = emailLabel.text, !email.isEmpty,
              let password = passwordLabel.text, !password.isEmpty,
              let confirmPassword = confirmPasswordLabel.text, !confirmPassword.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all fields.", lottieName: "error")
            return
        }
        guard isValidEmail(email) else {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.", lottieName: "error")
            return
        }
        guard password == confirmPassword else {
            showAlert(title: "Error", message: "Passwords do not match.", lottieName: "error")
            return
        }
        
        if password.isValidPassword {
            
            self.showLottieLoading()
            let registerInfo = Register(name: name, email: email, password: password, userType: 1)
            
            viewModel?.register(user: registerInfo) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.hideLottieLoading()
                        self?.showAlert(title: "Success", message: "Registration completed successfully!", lottieName: "success") {
                            ApplicationCoordinator.getInstance().pushToMainLoginScreen()
                        }
                    case .failure(let error):
                        self?.hideLottieLoading()
                        self?.showAlert(title: "Registration Error", message: error.localizedDescription, lottieName: "error")
                    }
                }
            }
        } else {
            if !password.hasMinimumLength {
                animateLabelShake(passwordRulesView.lengthRuleLabel)
            }
            if !password.hasUppercase {
                animateLabelShake(passwordRulesView.uppercaseRuleLabel)
            }
            if !password.hasLowercase {
                animateLabelShake(passwordRulesView.lowercaseRuleLabel)
            }
            if !password.hasSpecialCharacter {
                animateLabelShake(passwordRulesView.specialCharRuleLabel)
            }
        }
        
    }
    
    @objc private func passwordChanged() {
        let password = passwordLabel.text ?? ""
        passwordRulesView.updateRules(for: password)
    }
    
    
    
}


