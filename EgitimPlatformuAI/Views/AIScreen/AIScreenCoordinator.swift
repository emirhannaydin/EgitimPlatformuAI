//
//  AIScreenCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 21.03.2025.
//

import Foundation
import UIKit

public final class AIScreenCoordinator: Coordinator{
    
    private static var instance : AIScreenCoordinator?
    static func getInstance() -> AIScreenCoordinator {
        if(instance == nil){
            instance = AIScreenCoordinator()
        }
        return instance!
    }
    
    var navigationController = UINavigationController()

    func start() {
        let storyboard = UIStoryboard(name: "AIScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "AIScreen")
                as? AIScreenViewController else {
            fatalError("Failed  to instantiate HomeViewController")
        }
        let viewModel = AIScreenViewModel(coordinator: self)
        viewController.viewModel = viewModel
        
        navigationController.isNavigationBarHidden = false
        navigationController.viewControllers = [viewController]

    }
}
