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
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
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
                    guard let user = self?.viewModel?.user else { return }
                    self?.user = user
                    if let currentUserID = UserDefaults.standard.string(forKey: "userID") {
                        if self?.user?.userType == 0{
                            ApplicationCoordinator.getInstance().pushToTeacherScreen()
                        }else{
                            let hasSubmittedKey = "hasSubmittedLevels_\(currentUserID)"
                            let hasSubmitted = UserDefaults.standard.bool(forKey: hasSubmittedKey)
                            
                            if hasSubmitted {
                                ApplicationCoordinator.getInstance().initTabBar()
                            } else {
                                ApplicationCoordinator.getInstance().pushToLevelScreen()
                            }
                        }
                    } else {
                        self?.showAlert(title: "Error", message: "UserID not found.")
                    }

                case .failure(let error):
                    self?.showAlert(title: "Login Error", message: error.localizedDescription)
                }
            }
        }
    }


}
