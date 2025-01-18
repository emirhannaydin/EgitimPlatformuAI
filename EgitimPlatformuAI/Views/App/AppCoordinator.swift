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
            instance = ApplicationCoordinator(window: UIWindow())
        }
        return instance!
    }
    var window: UIWindow?


    init(window: UIWindow){
        self.window = window
    }
    
    func start() {
        TabBarCoordinator.getInstance().start()
        window?.rootViewController = TabBarCoordinator.getInstance().tabBarController
        window?.makeKeyAndVisible()
        
    }
    
}
