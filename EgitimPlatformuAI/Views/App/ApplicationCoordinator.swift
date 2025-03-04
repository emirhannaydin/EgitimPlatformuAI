//
//  ApplicationCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 1.03.2025.
//

import UIKit

final class ApplicationCoordinator: Coordinator {
    private static var instance: ApplicationCoordinator?
    static func getInstance() -> ApplicationCoordinator {
        if instance == nil {
            instance = ApplicationCoordinator()
        }
        return instance!
    }
    
    var window: UIWindow?
    
    func start() {
        let tabBarCoordinator = TabBarCoordinator.getInstance()
        tabBarCoordinator.start()
        
        window?.rootViewController = tabBarCoordinator.tabBarController
        window?.makeKeyAndVisible()
    }
    
    func navigateToLogin() {
        let navigationController = TabBarCoordinator.getInstance().navigationController
        let loginCoordinator = LoginScreenCoordinator.getInstance()
        loginCoordinator.navigationController = navigationController
        loginCoordinator.start()
    }
    
    func navigateToMain() {
        MainScreenCoordinator.getInstance().start()
        TabBarCoordinator.getInstance().tabBarController.selectedIndex = 0
    }
    func navigateToProfile() {
        ProfileScreenCoordinator.getInstance().start()
        TabBarCoordinator.getInstance().tabBarController.selectedIndex = 1
    }
}
