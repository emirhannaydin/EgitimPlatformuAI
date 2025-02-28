//
//  LoginScreenCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 28.02.2025.
//
import Foundation
import UIKit

public final class LoginScreenCoordinator: Coordinator {
    
    private static var instance : LoginScreenCoordinator?
    static func getInstance() -> LoginScreenCoordinator {
        if(instance == nil){
            instance = LoginScreenCoordinator()
        }
        return instance!
    }
    var navigationController: UINavigationController! = UINavigationController()
    let homeStoryboard = UIStoryboard(name: "LoginScreen", bundle: nil).instantiateViewController(withIdentifier: "LoginScreen")
    
    func start() {
        let storyboard = UIStoryboard(name: "LoginScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "LoginScreen")
                as? LoginScreenViewController else {
            fatalError("Failed  to instantiate HomeViewController")
        }
        
        let viewModel = LoginScreenViewModel(coordinator: self)
        viewController.viewModel = viewModel
        
        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [viewController]    }

}
