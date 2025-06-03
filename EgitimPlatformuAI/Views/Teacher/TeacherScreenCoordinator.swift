//
//  TeacherScreenCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 3.06.2025.
//

import UIKit

public final class TeacherScreenCoordinator: Coordinator {
    private static var instance: TeacherScreenCoordinator?
    
    static func getInstance() -> TeacherScreenCoordinator {
        if instance == nil {
            instance = TeacherScreenCoordinator()
        }
        return instance!
    }
    
    var navigationController = UINavigationController()
    
    func start() {
        let storyboard = UIStoryboard(name: "TeacherScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "TeacherScreen")
                as? TeacherScreenViewController else {
            fatalError("Failed to instantiate TeacherScreenViewController")
        }
        
        let viewModel = TeacherScreenViewModel(coordinator: self)
        viewController.viewModel = viewModel
        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
