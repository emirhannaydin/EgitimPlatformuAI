//
//  LevelScreenCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 24.05.2025.
//

import Foundation
import UIKit

public final class LevelScreenCoordinator: Coordinator {
    
    private static var instance : LevelScreenCoordinator?
    static func getInstance() -> LevelScreenCoordinator {
        if(instance == nil){
            instance = LevelScreenCoordinator()
        }
        return instance!
    }
    var navigationController = UINavigationController()

    func start() {
        let storyboard = UIStoryboard(name: "LevelScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "LevelScreen")
                as? LevelScreenViewController else {
            fatalError("Failed  to instantiate HomeViewController")
        }
        
        
        let viewModel = LevelScreenViewModel(coordinator: self)
        viewController.viewModel = viewModel
        navigationController.viewControllers = [viewController]
    }

}

