//
//  VerifyEmailScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.06.2025.
//

import UIKit
import Foundation

final class VerifyEmailScreenViewController: UIViewController{
    
    @IBOutlet var verifyButton: UIButton!
    @IBOutlet var backButton: CustomBackButtonView!
    @IBOutlet var otpField1: UITextField!
    @IBOutlet var otpField2: UITextField!
    @IBOutlet var otpField3: UITextField!
    @IBOutlet var otpField4: UITextField!
    @IBOutlet var otpField5: UITextField!
    @IBOutlet var otpField6: UITextField!
    var viewModel: VerifyEmailScreenViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setOTPFields()
        applyGradientBackground()
        self.navigationController?.isNavigationBarHidden = true
        backButton.backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        
        verifyButton.layer.cornerRadius = 8
        verifyButton.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false

    }
    
    func setOTPFields(){
        let otpFields = [otpField1, otpField2, otpField3, otpField4, otpField5, otpField6]
        
        otpFields.forEach {
            $0?.keyboardType = .numberPad
            $0?.delegate = self
            $0?.textAlignment = .center
            $0?.layer.cornerRadius = 8
            $0?.clipsToBounds = true
        }
        
        otpField1.becomeFirstResponder()
    }

    func getOTPCode() -> String {
        return [otpField1, otpField2, otpField3, otpField4, otpField5, otpField6]
            .compactMap { $0?.text }
            .joined()
    }
    @objc func handleBackButton(){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func handleVerifyButton(_ sender: Any) {
        if viewModel!.isPasswordVerify{
            checkPasswordCode()
        }else{
            verifyEmail()
        }
    }
    
    private func verifyEmail(){
        let code = getOTPCode()
        viewModel!.verifyEmail(otpCode: code) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.showAlert(title: "Success", message: "Email verified successfully.", lottieName: "success"){
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription, lottieName: "error")
                }
            }
        }
    }
    
    private func checkPasswordCode(){
        let code = getOTPCode()
        if let userID = viewModel?.userID{
            viewModel!.verifyForgotPasswordCode(userId: userID, otpCode: code) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self?.hideLottieLoading()
                        self?.showAlert(title: "Success", message: "Code verified successfully.", lottieName: "success"){
                            let viewModel = ResetPasswordScreenViewModel(coordinator: ResetPasswordScreenCoordinator.getInstance(), userID: userID)
                            ApplicationCoordinator.getInstance().pushToResetPasswordScreen(with: viewModel)
                            
                        }
                    case .failure(let error):
                        self?.hideLottieLoading()
                        self?.showAlert(title: "Error", message: error.localizedDescription, lottieName: "error"){
                        }
                    }
                }
            }
        }
    }
}

extension VerifyEmailScreenViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            textField.text = ""

            switch textField {
            case otpField6: otpField5.becomeFirstResponder()
            case otpField5: otpField4.becomeFirstResponder()
            case otpField4: otpField3.becomeFirstResponder()
            case otpField3: otpField2.becomeFirstResponder()
            case otpField2: otpField1.becomeFirstResponder()
            default: break
            }

            return false
        }

        guard string.count == 1 else { return false }

        textField.text = string

        switch textField {
        case otpField1: otpField2.becomeFirstResponder()
        case otpField2: otpField3.becomeFirstResponder()
        case otpField3: otpField4.becomeFirstResponder()
        case otpField4: otpField5.becomeFirstResponder()
        case otpField5: otpField6.becomeFirstResponder()
        case otpField6: otpField6.resignFirstResponder()
        default: break
        }

        return false
    }

}

