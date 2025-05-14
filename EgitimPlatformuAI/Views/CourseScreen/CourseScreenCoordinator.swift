//
//  ListeningFirstScreenCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.05.2025.
//

import Foundation
import UIKit

public final class CourseScreenCoordinator: Coordinator {
    private static var instance: CourseScreenCoordinator?
    private var pendingCourseName: String?

    static func getInstance() -> CourseScreenCoordinator {
        if instance == nil {
            instance = CourseScreenCoordinator()
        }
        return instance!
    }
    private(set) var courseViewController: CourseScreenViewController?
    var navigationController = UINavigationController()
    
    func setCourseName(_ name: String) {
        pendingCourseName = name
    }

    func start() {
        let storyboard = UIStoryboard(name: "CourseScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "CourseScreen")
                as? CourseScreenViewController else {
            fatalError("Failed to instantiate ListeningFirstScreenViewController")
        }
        
        let viewModel = CourseScreenViewModel(coordinator: self)
        viewController.viewModel = viewModel
        if let name = pendingCourseName {
            viewController.courseName.text = name
        }

        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}

