//
//  ResetPasswordScreen.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.06.2025.
//

import Foundation
import UIKit

public final class ResetPasswordScreenCoordinator: Coordinator {
    private static var instance: ResetPasswordScreenCoordinator?
    
    static func getInstance() -> ResetPasswordScreenCoordinator {
        if instance == nil {
            instance = ResetPasswordScreenCoordinator()
        }
        return instance!
    }
    
    var navigationController = UINavigationController()
    
    func start() {
        let storyboard = UIStoryboard(name: "ResetPassword", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ResetPassword")
                as? ResetPasswordScreenViewController else {
            fatalError("Failed to instantiate ResetPasswordViewController")
        }
        
        let viewModel = ResetPasswordScreenViewModel(coordinator: self, userID: "")
        viewController.viewModel = viewModel
        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func start(with viewModel: ResetPasswordScreenViewModel) {
        let storyboard = UIStoryboard(name: "ResetPassword", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ResetPassword")
                as? ResetPasswordScreenViewController else {
            fatalError("Failed to instantiate ResetPasswordScreenViewController")
        }

        viewController.viewModel = viewModel

        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        }
    }
}
