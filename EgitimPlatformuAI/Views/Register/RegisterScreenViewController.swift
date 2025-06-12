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
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        setLabelBackground()
        setRegisterButton()
       
        passwordLabel.isSecureTextEntry = true
        confirmPasswordLabel.isSecureTextEntry = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setLabelBackground(){
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
        register()
    }
    func register() {
        let registerInfo = Register(
            name: nameLabel.text!,
            email: emailLabel.text!,
            password: passwordLabel.text!,
            userType: 1
        )
        viewModel?.register(user: registerInfo) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.showAlert(title: "Success", message: "Registration completed successfully!") {
                            ApplicationCoordinator.getInstance().pushToMainLoginScreen()
                        }
                    case .failure(let error):
                        self?.showAlert(title: "Login Error", message: error.localizedDescription)
                    }
                }
            }
    }


}

