//
//  R.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.06.2025.
//

import UIKit
import Foundation

final class ResetPasswordScreenViewController: UIViewController {
    
    @IBOutlet var passwordRulesView: PasswordRulesView!
    @IBOutlet var backButton: CustomBackButtonView!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var resetPasswordButton: UIButton!
    @IBOutlet var confirmPasswordTextField: UITextField!
    var viewModel: ResetPasswordScreenViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        applyGradientBackground()
        setupUI()
    }
    
    private func setupUI(){
        
        passwordTextField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        setupPasswordToggle(for: passwordTextField)
        setupPasswordToggle(for: confirmPasswordTextField)
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.systemGray.cgColor
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.layer.masksToBounds = true
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter your password",
            attributes: [.foregroundColor: UIColor.backDarkBlue.withAlphaComponent(0.5)]
        )
        
        confirmPasswordTextField.layer.borderWidth = 1
        confirmPasswordTextField.layer.borderColor = UIColor.systemGray.cgColor
        confirmPasswordTextField.layer.cornerRadius = 8
        confirmPasswordTextField.layer.masksToBounds = true
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(
            string: "Confirm your password",
            attributes: [.foregroundColor: UIColor.backDarkBlue.withAlphaComponent(0.5)]
        )
        
        passwordTextField.textContentType = .oneTimeCode
        passwordTextField.autocorrectionType = .no
        passwordTextField.autocapitalizationType = .none
        
        confirmPasswordTextField.textContentType = .oneTimeCode
        confirmPasswordTextField.autocorrectionType = .no
        confirmPasswordTextField.autocapitalizationType = .none
        
        backButton.backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        
        resetPasswordButton.layer.cornerRadius = 8
        resetPasswordButton.layer.masksToBounds = true
    }
    
    @objc func handleBackButton(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        
    }
    @IBAction func resetPassword(_ sender: Any) {
        guard let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all fields.", lottieName: "error")
            return
        }
        guard passwordTextField.text == confirmPasswordTextField.text else {
            showAlert(title: "Error", message: "Passwords do not match.", lottieName: "error")
            return
        }
        if password.isValidPassword{
            if let userID = viewModel?.userID, let password = passwordTextField.text{
                self.showLottieLoading()
                viewModel!.resetPassword(userID: userID, password: password) { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let success):
                            self?.hideLottieLoading()
                            self?.showAlert(title: "Success", message: "Your password has been changed successfully.", lottieName: "success"){
                                ApplicationCoordinator.getInstance().navigateToMainLogin()
                            }
                            
                        case .failure(let error):
                            self?.hideLottieLoading()
                            self?.showAlert(title: "Error", message: error.localizedDescription, lottieName: "error"){
                                
                            }
                        }
                    }
                }
            }
            
        }else{
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
        let password = passwordTextField.text ?? ""
        passwordRulesView.updateRules(for: password)
    }
}
