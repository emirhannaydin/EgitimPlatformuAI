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
    var navigationController: UINavigationController! = UINavigationController()
    let homeStoryboard = UIStoryboard(name: "ProfileScreen", bundle: nil).instantiateViewController(withIdentifier: "ProfileScreen")
    let selectedImage = UIImage(systemName: "person.fill")
    let unselectedImage = UIImage(systemName: "person")
    
    func start() {
        let storyboard = UIStoryboard(name: "ProfileScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ProfileScreen")
                as? ProfileScreenViewController else {
            fatalError("Failed  to instantiate HomeViewController")
        }
        
        let viewModel = ProfileScreenViewModel(coordinator: self)
        viewController.viewModel = viewModel
        
        let tabBarTitle = "Profile"
        navigationController.tabBarItem = UITabBarItem(title: tabBarTitle,
                                                       image: unselectedImage,
                                                       selectedImage: selectedImage)
        
        navigationController.isNavigationBarHidden = false
        navigationController.viewControllers = [viewController]
    }

}
