//
//  TabbarController.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 16.01.2025.
//

import UIKit

public final class TabBarCoordinator: Coordinator {
    private static var instance : TabBarCoordinator?
    static func getInstance() -> TabBarCoordinator {
        if(instance == nil){
            instance = TabBarCoordinator()
        }
        return instance!
    }
    
    let tabBarController: UITabBarController = UITabBarController()
    
    func start() {
        tabBarController.tabBar.tintColor = .systemRed
        let backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        }
        tabBarController.tabBar.backgroundColor = backgroundColor

        let mainCoordinator = MainScreenCoordinator.getInstance()
        let profileCoordinator = ProfileScreenCoordinator.getInstance()
        
        mainCoordinator.start()
        profileCoordinator.start()
        
        tabBarController.viewControllers = [mainCoordinator.navigationController,
                                            profileCoordinator.navigationController]
    }
}
