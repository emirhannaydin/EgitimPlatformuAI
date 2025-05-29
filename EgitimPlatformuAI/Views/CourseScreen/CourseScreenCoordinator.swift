//
//  ListeningFirstScreenCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.05.2025.
//

import Foundation
import UIKit

final class CourseScreenCoordinator: Coordinator {
    private static var instance: CourseScreenCoordinator?
    static func getInstance() -> CourseScreenCoordinator {
        if instance == nil {
            instance = CourseScreenCoordinator()
        }
        return instance!
    }

    var navigationController = UINavigationController()
    var courseClasses: [CourseClass] = []

    func start() {
        let storyboard = UIStoryboard(name: "CourseScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "CourseScreen") as? CourseScreenViewController else {
            fatalError("Failed to instantiate CourseScreenViewController")
        }
        // default
        let viewModel = CourseScreenViewModel(
            coordinator: self,
            courseLevelName: "none",
            courseId: ""
        )

        viewController.viewModel = viewModel

        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        }
    }
    
    func start(with viewModel: CourseScreenViewModel) {
        let storyboard = UIStoryboard(name: "CourseScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "CourseScreen") as? CourseScreenViewController else {
            fatalError("Failed to instantiate CourseScreenViewController")
        }

        viewController.viewModel = viewModel

        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        }
    }

}


