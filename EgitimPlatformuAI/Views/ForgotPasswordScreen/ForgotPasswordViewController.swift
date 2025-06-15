//
//  ForgotPasswordViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.06.2025.
//

import UIKit
import Foundation

final class ForgotPasswordViewController: UIViewController{
    
    var viewModel: ForgotPasswordViewModel?
    
    @IBOutlet var backButton: CustomBackButtonView!
    @IBOutlet var sendCodeButton: UIButton!
    @IBOutlet var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setupUI()
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
        applyGradientBackground()

        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.systemGray.cgColor
        emailTextField.layer.cornerRadius = 8
        emailTextField.layer.masksToBounds = true
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter your email",
            attributes: [.foregroundColor: UIColor.backDarkBlue.withAlphaComponent(0.5)]
        )
        
        backButton.backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        
        sendCodeButton.layer.cornerRadius = 8
        sendCodeButton.layer.masksToBounds = true
    }
    @objc func handleBackButton(){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func sendCodeButton(_ sender: Any) {
        self.showLottieLoading()
        if let text = emailTextField.text{
            guard isValidEmail(text) else {
                self.hideLottieLoading()
                self.showAlert(title: "Error", message: "Enter a valid email", lottieName: "error")
                return
            }
                viewModel!.requestUserId(email: text) { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let userId):
                            self?.hideLottieLoading()
                            self?.showAlert(title: "Success", message: "Code sent", lottieName: "success"){
                                
                                let viewModel = VerifyEmailScreenViewModel(coordinator:         VerifyEmailScreenCoordinator.getInstance(),
                                    userID: userId,
                                    isPasswordVerify: true)
                                ApplicationCoordinator.getInstance().pushToVerifyEmailScreen(with: viewModel)
                            }
                        case .failure(let error):
                            self?.hideLottieLoading()
                            self?.showAlert(title: "Error", message: error.localizedDescription, lottieName: "error")
                        }
                    }
                }
            }
        }
    }
