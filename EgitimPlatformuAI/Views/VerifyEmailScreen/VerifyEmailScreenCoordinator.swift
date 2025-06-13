//
//  VerifyEmailScreenCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.06.2025.
//

import Foundation
import UIKit

public final class VerifyEmailScreenCoordinator: Coordinator {
    private static var instance: VerifyEmailScreenCoordinator?
    
    static func getInstance() -> VerifyEmailScreenCoordinator {
        if instance == nil {
            instance = VerifyEmailScreenCoordinator()
        }
        return instance!
    }
    
    var navigationController = UINavigationController()
    
    func start() {
        let storyboard = UIStoryboard(name: "VerifyEmail", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "VerifyEmail")
                as? VerifyEmailScreenViewController else {
            fatalError("Failed to instantiate VerifyEmailViewController")
        }
        let viewModel = VerifyEmailScreenViewModel(coordinator: self, userID: "", isPasswordVerify: false)
        viewController.viewModel = viewModel
        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func start(with viewModel: VerifyEmailScreenViewModel) {
        let storyboard = UIStoryboard(name: "VerifyEmail", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "VerifyEmail")
                as? VerifyEmailScreenViewController else {
            fatalError("Failed to instantiate VerifyEmailViewController")
        }

        viewController.viewModel = viewModel

        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        }
    }
}
