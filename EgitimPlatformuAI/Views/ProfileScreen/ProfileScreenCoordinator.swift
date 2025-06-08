//
//  ProfileScreenCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 16.01.2025.
//

import Foundation
import UIKit

public final class ProfileScreenCoordinator: Coordinator {
    
    private static var instance : ProfileScreenCoordinator?
    static func getInstance() -> ProfileScreenCoordinator {
        if(instance == nil){
            instance = ProfileScreenCoordinator()
        }
        return instance!
    }
    var navigationController = UINavigationController()
    var courseClasses: [CourseClass] = []

    func start() {
        let storyboard = UIStoryboard(name: "ProfileScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ProfileScreen")
                as? ProfileScreenViewController else {
            fatalError("Failed  to instantiate HomeViewController")
        }
        
        let viewModel = ProfileScreenViewModel(coordinator: self, courseClasses: courseClasses)
        viewController.viewModel = viewModel
        
        navigationController.isNavigationBarHidden = false
        navigationController.viewControllers = [viewController]
    }

}
