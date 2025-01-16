//
//  AppCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 16.01.2025.
//

import UIKit
public final class ApplicationCoordinator: Coordinator {
    private static var instance : ApplicationCoordinator?
    static func getInstance() -> ApplicationCoordinator {
        if(instance == nil){
            instance = ApplicationCoordinator()
        }
        return instance!
    }
    
    var window: UIWindow?
    var tabBarCoordinator: TabBarCoordinator?
    
    func start() {
        tabBarCoordinator = TabBarCoordinator()
        tabBarCoordinator?.start()
        window?.rootViewController = tabBarCoordinator?.tabBarController
        window?.makeKeyAndVisible()
    }
}
