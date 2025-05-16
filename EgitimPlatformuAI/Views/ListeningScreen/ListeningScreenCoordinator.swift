//
//  ListeningScreenCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 28.04.2025.
//

import Foundation
import UIKit

public final class ListeningScreenCoordinator: Coordinator {
    private static var instance: ListeningScreenCoordinator?
    
    static func getInstance() -> ListeningScreenCoordinator {
        if instance == nil {
            instance = ListeningScreenCoordinator()
        }
        return instance!
    }
    
    var navigationController = UINavigationController()
    private var courseType: CourseType = .listening

        func setCourseType(_ type: CourseType) {
            self.courseType = type
        }
    
    func start() {
        let storyboard = UIStoryboard(name: "ListeningScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ListeningScreen")
                as? ListeningScreenViewController else {
            fatalError("Failed to instantiate ListeningScreenViewController")
        }
        
        let viewModel = ListeningScreenViewModel(coordinator: self)
        viewController.viewModel = viewModel
        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
