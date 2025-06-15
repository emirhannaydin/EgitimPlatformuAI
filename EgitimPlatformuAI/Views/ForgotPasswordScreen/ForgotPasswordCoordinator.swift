//
//  ForgotPasswordCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.06.2025.
//

import Foundation
import UIKit

public final class ForgotPasswordCoordinator: Coordinator {
    private static var instance: ForgotPasswordCoordinator?
    
    static func getInstance() -> ForgotPasswordCoordinator {
        if instance == nil {
            instance = ForgotPasswordCoordinator()
        }
        return instance!
    }
    
    var navigationController = UINavigationController()
    
    func start() {
        let storyboard = UIStoryboard(name: "ForgotPassword", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ForgotPassword")
                as? ForgotPasswordViewController else {
            fatalError("Failed to instantiate ForgotPasswordViewController")
        }
        
        
        let viewModel = ForgotPasswordViewModel(coordinator: self)
        viewController.viewModel = viewModel
        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func start(with viewModel: ForgotPasswordViewModel) {
        let storyboard = UIStoryboard(name: "ForgotPassword", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ForgotPassword")
                as? ForgotPasswordViewController else {
            fatalError("Failed to instantiate ForgotPasswordViewController")
        }

        viewController.viewModel = viewModel

        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        }
    }
}
