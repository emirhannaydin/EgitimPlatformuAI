//
//  WritingScreenCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 28.04.2025.
//

import Foundation
import UIKit

public final class WritingScreenCoordinator: Coordinator {
    private static var instance: WritingScreenCoordinator?
    
    static func getInstance() -> WritingScreenCoordinator {
        if instance == nil {
            instance = WritingScreenCoordinator()
        }
        return instance!
    }
    
    var navigationController = UINavigationController()
    
    func start() {
        let storyboard = UIStoryboard(name: "WritingScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "WritingScreen")
                as? WritingScreenViewController else {
            fatalError("Failed to instantiate WritingScreenViewController")
        }
        
        let viewModel = WritingScreenViewModel(coordinator: self)
        viewController.viewModel = viewModel
        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func start(with viewModel: WritingScreenViewModel) {
        let storyboard = UIStoryboard(name: "WritingScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "WritingScreen") as? WritingScreenViewController else {
            fatalError("Failed to instantiate WritingScreenViewController")
        }

        viewController.viewModel = viewModel

        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        }
    }
}
