//
//  MainLoginScreenCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 22.04.2025.
//

import Foundation
import UIKit

public final class MainLoginScreenCoordinator: Coordinator {
    
    private static var instance : MainLoginScreenCoordinator?
    static func getInstance() -> MainLoginScreenCoordinator {
        if(instance == nil){
            instance = MainLoginScreenCoordinator()
        }
        return instance!
    }
    var navigationController = UINavigationController()

    func start() {
        let storyboard = UIStoryboard(name: "MainLogin", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "MainLogin")
                as? MainLoginScreenViewController else {
            fatalError("Failed  to instantiate HomeViewController")
        }
        
        
        let viewModel = MainLoginScreenViewModel(coordinator: self)
        viewController.viewModel = viewModel
        navigationController.viewControllers = [viewController]
    }

}
