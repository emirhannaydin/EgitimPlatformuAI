//
//  LoginScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 28.02.2025.
//
import UIKit
import Foundation
import Lottie

final class LoginScreenViewController: UIViewController {
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet var lottieView: LottieAnimationView!
    private var hamburgerMenuManager: HamburgerMenuManager!
    
    var viewModel: LoginScreenViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        applyGradientBackground()
        hamburgerMenuManager = HamburgerMenuManager(viewController: self)
        removeEdgePanGesture()
        setLoginButton()
        setRegisterButton()
        setLottieAnimation()
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            self.navigationController?.isNavigationBarHidden = true
        }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func removeEdgePanGesture() {
        if let window = hamburgerMenuManager.getKeyWindow() {
            window.gestureRecognizers?.removeAll(where: { $0 is UIScreenEdgePanGestureRecognizer })
        }
    }
    
    private func setLoginButton(){
        loginButton.layer.cornerRadius = 8
        loginButton.layer.masksToBounds = true
    }
    private func setRegisterButton(){
        registerButton.layer.cornerRadius = 8
        registerButton.layer.borderWidth = 1
        loginButton.layer.masksToBounds = true
    }
    private func setLottieAnimation(){
        let animation = LottieAnimation.named("loginAnimation")
        lottieView.animation = animation
        lottieView.contentMode = .scaleAspectFit
        lottieView.loopMode = .loop
        lottieView.play()
    }
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        ApplicationCoordinator.getInstance().navigateToMainLogin()
    }
   
    
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        ApplicationCoordinator.getInstance().navigateToRegister()
    }
    
}
