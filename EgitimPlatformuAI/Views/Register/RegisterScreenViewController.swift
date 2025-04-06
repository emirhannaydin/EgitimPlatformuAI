//
//  RegisterScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 28.03.2025.
//

import UIKit
class RegisterScreenViewController: UIViewController {

    @IBOutlet var backButton: CustomBackButtonView!
    @IBOutlet var loginNowButton: UIButton!
    @IBOutlet var nameLabel: UITextField!
    @IBOutlet var emailLabel: UITextField!
    @IBOutlet var passwordLabel: UITextField!
    @IBOutlet var confirmPasswordLabel: UITextField!
    @IBOutlet var registerButton: UIButton!
    var viewModel: RegisterScreenViewModel?
    private var hamburgerMenuManager: HamburgerMenuManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        setLabelBackground()
        setRegisterButton()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setLabelBackground(){
        nameLabel.backgroundColor = .customPorcelain
        emailLabel.backgroundColor = .customPorcelain
        passwordLabel.backgroundColor = .customPorcelain
        confirmPasswordLabel.backgroundColor = .customPorcelain

    }
    private func setRegisterButton(){
        registerButton.backgroundColor = UIColor.customDarkBlue
        registerButton.layer.cornerRadius = 8
        registerButton.layer.masksToBounds = true
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)

    }
    
    @IBAction func loginNowButtonClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
}
