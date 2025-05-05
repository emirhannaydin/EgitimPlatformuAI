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
        /*let loginCoordinator = LoginScreenCoordinator.getInstance()
        loginCoordinator.start()
        if let window = self.window {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.window?.rootViewController = loginCoordinator.navigationController
            })
            window.makeKeyAndVisible()
        }
        window?.makeKeyAndVisible()*/
        
        initTabBar()
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
    func navigateToRegister(){
        pushToRegisterScreen()
    }
    func navigateToMainLogin(){
        pushToMainLoginScreen()
    }

    func initTabBar(){
        tabBarCoordinator.start()
        tabBarCoordinator.tabBarController.isTabBarHidden = false
        tabBarCoordinator.tabBarController.selectedIndex = 0
        if let window = self.window {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.window?.rootViewController = self.tabBarCoordinator.tabBarController
            })
            window.makeKeyAndVisible()
        }

    }
    func pushFromTabBarCoordinator<T: Coordinator>(_ coordinatorType: T.Type) {
       let coordinator = coordinatorType.getInstance()
       coordinator.start()
       guard let navController = tabBarCoordinator.tabBarController.selectedViewController as? UINavigationController,
             let newVC = coordinator.navigationController.viewControllers.first else { return }
        newVC.hidesBottomBarWhenPushed = false
       navController.pushViewController(newVC, animated: true)
    }
    func pushWithoutTabBarFromTabBarCoordinator<T: Coordinator>(_ coordinatorType: T.Type) {
        let coordinator = coordinatorType.getInstance()
        coordinator.start()
        
        guard let navController = tabBarCoordinator.tabBarController.selectedViewController as? UINavigationController,
              let newVC = coordinator.navigationController.viewControllers.first else { return }
        
        newVC.hidesBottomBarWhenPushed = true
        navController.pushViewController(newVC, animated: true)
    }

    func pushToRegisterScreen() {
        let navController = LoginScreenCoordinator.getInstance().navigationController

        if let existingRegisterVC = navController.viewControllers.first(where: { $0 is RegisterScreenViewController }) {
            navController.popToViewController(existingRegisterVC, animated: true)
        } else {
            let registerCoordinator = RegisterScreenCoordinator.getInstance()
            registerCoordinator.start()
            
            if let registerVC = registerCoordinator.navigationController.viewControllers.first {
                navController.pushViewController(registerVC, animated: true)
            }
        }
    }

    func pushToMainLoginScreen() {
        let navController = LoginScreenCoordinator.getInstance().navigationController

        if let existingLoginVC = navController.viewControllers.first(where: { $0 is MainLoginScreenViewController }) {
            navController.popToViewController(existingLoginVC, animated: true)
        } else {
            let mainLoginCoordinator = MainLoginScreenCoordinator.getInstance()
            mainLoginCoordinator.start()
            
            if let mainLoginVC = mainLoginCoordinator.navigationController.viewControllers.first {
                navController.pushViewController(mainLoginVC, animated: true)
            }
        }
    }




}
