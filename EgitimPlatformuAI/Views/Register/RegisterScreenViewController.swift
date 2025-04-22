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
    @IBOutlet var roleTextField: UITextField!
    let pickerView = UIPickerView()
    let options = ["Student", "Teacher"]
    var viewModel: RegisterScreenViewModel?
    private var hamburgerMenuManager: HamburgerMenuManager!

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
        doneButton.setTitleTextAttributes([.foregroundColor: UIColor.customDarkBlue], for: .normal)
        toolbar.setItems([flexibleSpace, doneButton, flexibleSpace], animated: false)

        roleTextField.inputAccessoryView = toolbar
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setLabelBackground(){
        nameLabel.backgroundColor = .customPorcelain
        emailLabel.backgroundColor = .customPorcelain
        passwordLabel.backgroundColor = .customPorcelain
        confirmPasswordLabel.backgroundColor = .customPorcelain
        roleTextField.backgroundColor = .customPorcelain

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
    @objc func doneTapped() {
        roleTextField.resignFirstResponder()
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
