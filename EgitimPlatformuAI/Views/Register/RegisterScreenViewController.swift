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
    var viewModel: RegisterScreenViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setupUI()
        setRegisterButton()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    private func setupUI(){
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        setupPasswordToggle(for: passwordLabel)
        setupPasswordToggle(for: confirmPasswordLabel)
        passwordLabel.textContentType = .oneTimeCode
        passwordLabel.autocorrectionType = .no
        passwordLabel.autocapitalizationType = .none

        confirmPasswordLabel.textContentType = .oneTimeCode
        confirmPasswordLabel.autocorrectionType = .no
        confirmPasswordLabel.autocapitalizationType = .none
        
        nameLabel.backgroundColor = .porcelain
        emailLabel.backgroundColor = .porcelain
        passwordLabel.backgroundColor = .porcelain
        confirmPasswordLabel.backgroundColor = .porcelain
    }
    
    private func setRegisterButton(){
        registerButton.backgroundColor = UIColor.darkBlue
        registerButton.layer.cornerRadius = 8
        registerButton.layer.masksToBounds = true
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginNowButtonClicked(_ sender: Any) {
        ApplicationCoordinator.getInstance().navigateToMainLogin()
    }
    
    @IBAction func registerButton(_ sender: Any) {
        self.showLottieLoading()
        register()
    }
    private func register() {
        guard let name = nameLabel.text, !name.isEmpty,
              let email = emailLabel.text, !email.isEmpty,
              let password = passwordLabel.text, !password.isEmpty,
              let confirmPassword = confirmPasswordLabel.text, !confirmPassword.isEmpty else {
            self.hideLottieLoading()
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }

        guard isValidEmail(email) else {
            self.hideLottieLoading()
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
            return
        }

        guard password == confirmPassword else {
            self.hideLottieLoading()
            showAlert(title: "Error", message: "Passwords do not match.")
            return
        }

        let registerInfo = Register(name: name, email: email, password: password, userType: 1)

        viewModel?.register(user: registerInfo) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.hideLottieLoading()
                    self?.showAlert(title: "Success", message: "Registration completed successfully!") {
                        ApplicationCoordinator.getInstance().pushToMainLoginScreen()
                    }
                case .failure(let error):
                    self?.showAlert(title: "Registration Error", message: error.localizedDescription)
                }
            }
        }
    }



}

extension RegisterScreenViewController{
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

}

