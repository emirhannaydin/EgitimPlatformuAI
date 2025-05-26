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
    @IBOutlet var backButton: CustomBackButtonView!
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerNowButton(_ sender: Any) {
        ApplicationCoordinator.getInstance().navigateToRegister()
    }
    
    @IBAction func loginButton(_ sender: Any) {
        login()
    }
    
    func login() {
        guard let email = emailText.text, !email.isEmpty,
              let password = passwordText.text, !password.isEmpty else {
            self.showAlert(title: "Error", message: "Email or password is empty.")
            return
        }
        
        viewModel?.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    ApplicationCoordinator.getInstance().pushToLevelScreen()
                case .failure(let error):
                    self?.showAlert(title: "Login Error", message: error.localizedDescription)
                }
            }
        }
    }

}
