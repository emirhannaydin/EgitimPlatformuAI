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
    var window : UIWindow?
    var navigationController: UINavigationController! = UINavigationController()
    let homeStoryboard = UIStoryboard(name: "MainScreen", bundle: nil).instantiateViewController(withIdentifier: "MainScreen")
    let selectedImage = UIImage(systemName: "person.fill")
    let unselectedImage = UIImage(systemName: "person")
    
    func start() {
        let storyboard = UIStoryboard(name: "MainScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "MainScreen")
                as? MainScreenViewController else {
            fatalError("Failed  to instantiate HomeViewController")
        }
        
        
        let viewModel = MainScreenViewModel(coordinator: self)
        viewController.viewModel = viewModel
        
        let tabBarTitle = "Home"
        navigationController.tabBarItem = UITabBarItem(title: tabBarTitle,
                                                       image: unselectedImage,
                                                       selectedImage: selectedImage)
        
        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [viewController]
    }

}
