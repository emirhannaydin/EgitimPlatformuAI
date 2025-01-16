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
        
        MainScreenCoordinator.getInstance().start()
        ProfileScreenCoordinator.getInstance().start()
        tabBarController.viewControllers = [MainScreenCoordinator.getInstance().navigationController,
                                            ProfileScreenCoordinator.getInstance().navigationController]
    }
}
