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
    var navigationController = UINavigationController()
    var window: UIWindow?
    let tabBarCoordinator = TabBarCoordinator.getInstance()
    func start() {
        let loginCoordinator = LoginScreenCoordinator.getInstance()
        loginCoordinator.start()
        window?.rootViewController = loginCoordinator.navigationController
        window?.makeKeyAndVisible()
    }
    func navigateToMain() {
        tabBarCoordinator.tabBarController.selectedIndex = 0
    }
    func navigateToAI(){
        tabBarCoordinator.tabBarController.selectedIndex = 1
    }
    func navigateToProfile() {
        tabBarCoordinator.tabBarController.selectedIndex = 2
    }

    func initTabBar(){
        tabBarCoordinator.start()
        tabBarCoordinator.tabBarController.isTabBarHidden = false
        tabBarCoordinator.tabBarController.selectedIndex = 0
        window?.rootViewController = tabBarCoordinator.tabBarController
        window?.makeKeyAndVisible()
    }
    func pushFromTabBarCoordinator<T: Coordinator>(_ coordinatorType: T.Type) {
       let coordinator = coordinatorType.getInstance()
       coordinator.start()
       guard let navController = tabBarCoordinator.tabBarController.selectedViewController as? UINavigationController,
             let newVC = coordinator.navigationController.viewControllers.first else { return }
       newVC.hidesBottomBarWhenPushed = true
       navController.pushViewController(newVC, animated: true)
    }
}
