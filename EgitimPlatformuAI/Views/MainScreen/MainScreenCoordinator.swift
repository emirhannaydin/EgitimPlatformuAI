//
//  MainScreenCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 16.01.2025.
//

import Foundation
import UIKit

public final class MainScreenCoordinator: Coordinator {
    
    private static var instance : MainScreenCoordinator?
    static func getInstance() -> MainScreenCoordinator {
        if(instance == nil){
            instance = MainScreenCoordinator()
        }
        return instance!
    }
    var navigationController = UINavigationController()

    func start() {
        let storyboard = UIStoryboard(name: "MainScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "MainScreen")
                as? MainScreenViewController else {
            fatalError("Failed  to instantiate HomeViewController")
        }
        
        
        let viewModel = MainScreenViewModel(coordinator: self)
        viewController.viewModel = viewModel
        navigationController.isNavigationBarHidden = false
        navigationController.viewControllers = [viewController]
    }

}
