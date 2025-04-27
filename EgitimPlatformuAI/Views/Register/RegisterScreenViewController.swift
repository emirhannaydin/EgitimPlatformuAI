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
    @IBOutlet var roleTextField: UITextField!
    let pickerView = UIPickerView()
    let options = ["Student", "Teacher"]
    var viewModel: RegisterScreenViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        setLabelBackground()
        setRegisterButton()
        
        pickerView.delegate = self
        pickerView.dataSource = self
       
        roleTextField.inputView = pickerView
        roleTextField.delegate = self
        roleTextField.tintColor = .clear
        passwordLabel.isSecureTextEntry = true
        confirmPasswordLabel.isSecureTextEntry = true
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Tamam", style: .done, target: self, action: #selector(doneTapped))
        doneButton.setTitleTextAttributes([.foregroundColor: UIColor.darkBlue], for: .normal)
        toolbar.setItems([flexibleSpace, doneButton, flexibleSpace], animated: false)

        roleTextField.inputAccessoryView = toolbar
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
        roleTextField.backgroundColor = .porcelain

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
    @objc func doneTapped() {
        roleTextField.resignFirstResponder()
    }
    
    @IBAction func registerButton(_ sender: Any) {
        register()
    }
    func register() {
        var userType = Int()
        if roleTextField.text == "Teacher"{
            userType = 0
        }else{
            userType = 1
        }
        let registerInfo = Register(
            name: nameLabel.text!,
            email: emailLabel.text!,
            password: passwordLabel.text!,
            userType: userType
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

extension RegisterScreenViewController: UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        roleTextField.text = options[row]
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }


}
