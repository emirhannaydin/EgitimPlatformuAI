//
//  TabbarController.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 16.01.2025.
//

import UIKit

public final class TabBarCoordinator: Coordinator {
    private static var instance: TabBarCoordinator?
    static func getInstance() -> TabBarCoordinator {
        if instance == nil {
            instance = TabBarCoordinator()
        }
        return instance!
    }

    let tabBarController: UITabBarController = UITabBarController()
    var navigationController = UINavigationController()

    func start() {
        tabBarController.tabBar.unselectedItemTintColor = .white
        tabBarController.tabBar.tintColor = .summer
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance
    

        
        let mainCoordinator = MainScreenCoordinator.getInstance()
        let profileCoordinator = ProfileScreenCoordinator.getInstance()
        let aiCoordinator = AIScreenCoordinator.getInstance()
        
        mainCoordinator.start()
        profileCoordinator.start()
        aiCoordinator.start()

        let mainNav = UINavigationController(rootViewController: mainCoordinator.navigationController.viewControllers.first!)
        let profileNav = UINavigationController(rootViewController: profileCoordinator.navigationController.viewControllers.first!)
        let aiNav = UINavigationController(rootViewController: aiCoordinator.navigationController.viewControllers.first!)

        mainNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        aiNav.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "checkmark.message"), tag: 1)
        profileNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 2)

        tabBarController.viewControllers = [mainNav, aiNav, profileNav]
    }
}
