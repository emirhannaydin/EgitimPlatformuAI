//
//  LoginScreenCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 28.02.2025.
//
import Foundation
import UIKit

public final class LoginScreenCoordinator: Coordinator {
    
    private static var instance: LoginScreenCoordinator?
    
    static func getInstance() -> LoginScreenCoordinator {
        if instance == nil {
            instance = LoginScreenCoordinator()
        }
        return instance!
    }
    
    var navigationController = UINavigationController()

    func start() {
        let storyboard = UIStoryboard(name: "LoginScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "LoginScreen")
                as? LoginScreenViewController else {
            fatalError("Failed to instantiate LoginScreenViewController")
        }
        
        let viewModel = LoginScreenViewModel(coordinator: self)
        viewController.viewModel = viewModel
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
