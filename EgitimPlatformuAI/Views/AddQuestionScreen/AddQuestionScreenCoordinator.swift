//
//  AddQuestionScreenCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 9.06.2025.
//

import UIKit

public final class AddQuestionScreenCoordinator: Coordinator {
    private static var instance: AddQuestionScreenCoordinator?
    
    static func getInstance() -> AddQuestionScreenCoordinator {
        if instance == nil {
            instance = AddQuestionScreenCoordinator()
        }
        return instance!
    }
    
    var navigationController = UINavigationController()
    
    func start() {
        let storyboard = UIStoryboard(name: "AddQuestionScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "AddQuestionScreen")
                as? AddQuestionScreenViewController else {
            fatalError("Failed to instantiate TeacherScreenViewController")
        }
        
        let viewModel = AddQuestionScreenViewModel(
            coordinator: self,
            courseLevelName: "none",
            courseId: ""
        )
        
        viewController.viewModel = viewModel

        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        }
    }

    func start(with viewModel: AddQuestionScreenViewModel) {
        let storyboard = UIStoryboard(name: "AddQuestionScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "AddQuestionScreen") as? AddQuestionScreenViewController else {
            fatalError("Failed to instantiate AddQuestionScreenViewController")
        }

        viewController.viewModel = viewModel

        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        }
    }
    
}
