//
//  WordPuzzleCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.06.2025.
//

import Foundation
import UIKit

public final class WordPuzzleCoordinator: Coordinator {
    private static var instance: WordPuzzleCoordinator?
    
    static func getInstance() -> WordPuzzleCoordinator {
        if instance == nil {
            instance = WordPuzzleCoordinator()
        }
        return instance!
    }
    
    var navigationController = UINavigationController()
    
    func start() {
        let storyboard = UIStoryboard(name: "WordPuzzle", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "WordPuzzle")
                as? WordPuzzleViewController else {
            fatalError("Failed to instantiate WordPuzzleViewController")
        }
        
        let viewModel = WordPuzzleViewModel(coordinator: self)
        viewController.viewModel = viewModel
        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func start(with viewModel: WordPuzzleViewModel) {
        let storyboard = UIStoryboard(name: "WordPuzzle", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "WordPuzzle")
                as? WordPuzzleViewController else {
            fatalError("Failed to instantiate WordPuzzleViewController")
        }

        viewController.viewModel = viewModel

        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        }
    }
}
