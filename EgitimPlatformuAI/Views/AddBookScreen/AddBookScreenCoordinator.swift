//
//  AddBookScreenCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 15.06.2025.
//


import Foundation
import UIKit

public final class AddBookScreenCoordinator: Coordinator {
    private static var instance: AddBookScreenCoordinator?
    
    static func getInstance() -> AddBookScreenCoordinator {
        if instance == nil {
            instance = AddBookScreenCoordinator()
        }
        return instance!
    }
    
    var navigationController = UINavigationController()
    
    func start() {
        let storyboard = UIStoryboard(name: "AddBook", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "AddBook")
                as? AddBookScreenViewController else {
            fatalError("Failed to instantiate AddBookViewController")
        }
        
        let viewModel = AddBookScreenViewModel(coordinator: self)
        viewController.viewModel = viewModel
        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func start(with viewModel: AddBookScreenViewModel) {
        let storyboard = UIStoryboard(name: "AddBook", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "AddBook")
                as? AddBookScreenViewController else {
            fatalError("Failed to instantiate WordPuzzleViewController")
        }

        viewController.viewModel = viewModel

        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        }
    }
}
