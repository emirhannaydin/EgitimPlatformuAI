//
//  ReadingBookCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.06.2025.
//

import Foundation
import UIKit

public final class ReadingBookCoordinator: Coordinator {
    private static var instance: ReadingBookCoordinator?
    
    static func getInstance() -> ReadingBookCoordinator {
        if instance == nil {
            instance = ReadingBookCoordinator()
        }
        return instance!
    }
    
    var navigationController = UINavigationController()
    
    func start() {
        let storyboard = UIStoryboard(name: "ReadingBook", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ReadingBook")
                as? ReadingBookViewController else {
            fatalError("Failed to instantiate ReadingBookViewController")
        }
        
        let viewModel = ReadingBookViewModel(coordinator: self)
        viewController.viewModel = viewModel
        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func start(with viewModel: ReadingBookViewModel) {
        let storyboard = UIStoryboard(name: "ReadingBook", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ReadingBook")
                as? ReadingBookViewController else {
            fatalError("Failed to instantiate ReadingBookViewController")
        }

        viewController.viewModel = viewModel

        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        }
    }
}
