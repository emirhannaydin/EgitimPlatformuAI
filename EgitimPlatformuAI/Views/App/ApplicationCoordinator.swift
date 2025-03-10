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
    let tabBarCoordinator = TabBarCoordinator.getInstance()
    func start() {
        let loginCoordinator = LoginScreenCoordinator.getInstance()
        loginCoordinator.start()
        window?.rootViewController = loginCoordinator.navigationController
        window?.makeKeyAndVisible()
    }
    
    func navigateToLogin() {
        let loginCoordinator = LoginScreenCoordinator.getInstance()
        tabBarCoordinator.tabBarController.isTabBarHidden = true
        loginCoordinator.navigationController = tabBarCoordinator.tabBarController.selectedViewController as? UINavigationController
        loginCoordinator.start()

    }
    func navigateToMain() {
        TabBarCoordinator.getInstance().tabBarController.selectedIndex = 0
    }
    func navigateToProfile() {
        TabBarCoordinator.getInstance().tabBarController.selectedIndex = 1
    }
    func initTabBar(){
        tabBarCoordinator.start()
        tabBarCoordinator.tabBarController.isTabBarHidden = false
        window?.rootViewController = tabBarCoordinator.tabBarController
        window?.makeKeyAndVisible()
    }
}
