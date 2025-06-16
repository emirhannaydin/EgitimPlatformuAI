//
//  StudentsScreenCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 16.06.2025.
//

import Foundation
import UIKit

public final class StudentsScreenCoordinator: Coordinator {
    private static var instance: StudentsScreenCoordinator?
    
    static func getInstance() -> StudentsScreenCoordinator {
        if instance == nil {
            instance = StudentsScreenCoordinator()
        }
        return instance!
    }
    
    var navigationController = UINavigationController()
    
    func start() {
        let storyboard = UIStoryboard(name: "StudentsScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "StudentsScreen")
                as? StudentsScreenViewController else {
            fatalError("Failed to instantiate StudentsScreenViewController")
        }
        
        let viewModel = StudentsScreenViewModel(coordinator: self)
        viewController.viewModel = viewModel
        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func start(with viewModel: StudentsScreenViewModel) {
        let storyboard = UIStoryboard(name: "StudentsScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "StudentsScreen")
                as? StudentsScreenViewController else {
            fatalError("Failed to instantiate StudentsScreenViewController")
        }

        viewController.viewModel = viewModel

        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        }
    }
}
