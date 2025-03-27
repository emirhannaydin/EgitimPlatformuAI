//
//  RegisterScreenCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 28.03.2025.
//

import Foundation
import UIKit

public final class RegisterScreenCoordinator: Coordinator {
    
    private static var instance : RegisterScreenCoordinator?
    static func getInstance() -> RegisterScreenCoordinator {
        if(instance == nil){
            instance = RegisterScreenCoordinator()
        }
        return instance!
    }
    var navigationController = UINavigationController()

    func start() {
        let storyboard = UIStoryboard(name: "Register", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "Register")
                as? RegisterScreenViewController else {
            fatalError("Failed  to instantiate HomeViewController")
        }
        
        
        let viewModel = RegisterScreenViewModel(coordinator: self)
        viewController.viewModel = viewModel
        navigationController.viewControllers = [viewController]
    }

}
