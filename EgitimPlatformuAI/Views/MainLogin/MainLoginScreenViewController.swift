//
//  MainLoginViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 22.04.2025.
//

import UIKit

class MainLoginScreenViewController: UIViewController {
    
    var viewModel: MainLoginScreenViewModel?
    
    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var registerNowButton: UIButton!
    @IBOutlet var backButton: CustomBackButtonView!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
        emailText.text = ""
        passwordText.text = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        view.endEditing(true)
        
    }
    
    private func setupUI(){
        applyGradientBackground()
        hideKeyboardWhenTappedAround()
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        setupPasswordToggle(for: passwordText)
        loginButton.layer.cornerRadius = 8
        loginButton.layer.masksToBounds = true
        
        emailText.layer.borderWidth = 1
        emailText.layer.borderColor = UIColor.systemGray.cgColor
        emailText.layer.cornerRadius = 8
        emailText.layer.masksToBounds = true
        emailText.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [.foregroundColor: UIColor.backDarkBlue.withAlphaComponent(0.5)]
        )
        passwordText.layer.borderWidth = 1
        passwordText.layer.borderColor = UIColor.systemGray.cgColor
        passwordText.layer.cornerRadius = 8
        passwordText.layer.masksToBounds = true
        passwordText.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [.foregroundColor: UIColor.backDarkBlue.withAlphaComponent(0.5)]
        )
        
        let registerText = "Register Now"
        let fullText = "Don't have an account? \(registerText)"
        let attributedText = NSMutableAttributedString(string: fullText)
        
        let fullRange = NSRange(location: 0, length: fullText.count)
        attributedText.addAttribute(.font, value: UIFont(name: "HelveticaNeue", size: 15)!, range: fullRange)
        
        let registerRange = (fullText as NSString).range(of: registerText)
        attributedText.addAttribute(.foregroundColor, value: UIColor.summer, range: registerRange)
        attributedText.addAttribute(.font, value: UIFont(name: "HelveticaNeue-Bold", size: 15)!, range: registerRange)
        
        registerNowButton.setAttributedTitle(attributedText, for: .normal)
        
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerNowButton(_ sender: Any) {
        ApplicationCoordinator.getInstance().navigateToRegister()
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        ApplicationCoordinator.getInstance().pushToForgotPasswordScreen()
    }
    
    @IBAction func loginButton(_ sender: Any) {
        login()
    }
    
    func login() {
        guard let email = emailText.text, !email.isEmpty,
              let password = passwordText.text, !password.isEmpty else {
            self.showAlert(title: "Error", message: "Email or password is empty.", lottieName: "error")
            return
        }
        
        viewModel?.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    guard let user = self?.viewModel?.user else { return }
                    self?.user = user
                    
                    if self?.user?.userType == 0{
                        ApplicationCoordinator.getInstance().initTeacherScreen()
                    }else{
                        if self?.user?.isEmailActivated == false{
                            ApplicationCoordinator.getInstance().pushToVerifyEmailScreen()
                        }else{
                            if let classes = self?.user?.classes {
                                if classes.isEmpty{
                                    ApplicationCoordinator.getInstance().pushToLevelScreen()
                                }else {
                                    ApplicationCoordinator.getInstance().initTabBar()
                                }
                            }
                        }
                        
                    }
                    
                    
                case .failure(let error):
                    self?.showAlert(title: "Login Error", message: error.localizedDescription, lottieName: "error")
                }
            }
        }
    }
    
    
}
