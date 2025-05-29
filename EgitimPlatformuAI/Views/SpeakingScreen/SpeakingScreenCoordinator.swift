//
//  SpeakingScreenCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 28.04.2025.
//

import Foundation
import UIKit

public final class SpeakingScreenCoordinator: Coordinator {
    private static var instance: SpeakingScreenCoordinator?
    
    static func getInstance() -> SpeakingScreenCoordinator {
        if instance == nil {
            instance = SpeakingScreenCoordinator()
        }
        return instance!
    }
    
    var navigationController = UINavigationController()
    
    func start() {
        let storyboard = UIStoryboard(name: "SpeakingScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "SpeakingScreen")
                as? SpeakingScreenViewController else {
            fatalError("Failed to instantiate SpeakingScreenViewController")
        }
        
        let viewModel = SpeakingScreenViewModel(coordinator: self)
        viewController.viewModel = viewModel
        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func start(with viewModel: SpeakingScreenViewModel) {
        let storyboard = UIStoryboard(name: "SpeakingScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "SpeakingScreen") as? SpeakingScreenViewController else {
            fatalError("Failed to instantiate SpeakingScreenViewController")
        }

        viewController.viewModel = viewModel

        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        }
    }
}
