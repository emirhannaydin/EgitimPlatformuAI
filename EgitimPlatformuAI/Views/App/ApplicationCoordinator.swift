//
//  ApplicationCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 1.03.2025.
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
    
    func navigateToLogin() {
        LoginScreenCoordinator.getInstance().start()
        window?.rootViewController = LoginScreenCoordinator.getInstance().navigationController
        window?.makeKeyAndVisible()
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
