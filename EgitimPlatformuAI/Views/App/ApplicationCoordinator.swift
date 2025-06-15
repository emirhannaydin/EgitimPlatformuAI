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
    let teacherCoordinator = TeacherScreenCoordinator.getInstance()

    func start() {
        let userType = UserDefaults.standard.integer(forKey: "userType")
        let hasUserType = UserDefaults.standard.object(forKey: "userType") != nil
        if let tokenData = KeychainHelper.shared.read(service: "access-token", account: "user"),
           let token = String(data: tokenData, encoding: .utf8),
           !token.isEmpty {
            if !hasUserType {
                navigateToLogin()
                return
            }
            if userType == 0 {
                ApplicationCoordinator.getInstance().initTeacherScreen()
            }else{
                ApplicationCoordinator.getInstance().initTabBar()
            }
        } else {
            navigateToLogin()
        }

    }
    func navigateToLogin(){
        let loginCoordinator = LoginScreenCoordinator.getInstance()
        loginCoordinator.navigationController = UINavigationController()
        loginCoordinator.start()
        if let window = self.window {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.window?.rootViewController = loginCoordinator.navigationController
            })
            window.makeKeyAndVisible()
        }
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
    func navigateToAddQuestionScreen(){
        pushToAddQuestionScreen()
    }

    func initTabBar(){
        UserDefaults.standard.set(1, forKey: "userType")
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
    
    func initTeacherScreen(){
        UserDefaults.standard.set(0, forKey: "userType")
        teacherCoordinator.start()
        if let window = self.window {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.window?.rootViewController = self.teacherCoordinator.navigationController
            })
            window.makeKeyAndVisible()
        }
    }
    func pushFromTabBarCoordinator<T: Coordinator>(_ coordinatorType: T.Type, hidesBottomBar: Bool) {
       
        let coordinator = coordinatorType.getInstance()
      
        coordinator.start()
       
        guard let navController = tabBarCoordinator.tabBarController.selectedViewController as? UINavigationController,
             let newVC = coordinator.navigationController.viewControllers.first else { return }
        
        newVC.hidesBottomBarWhenPushed = hidesBottomBar
        navController.pushViewController(newVC, animated: true)
    }
    // Variables pushlanacağı zaman start yapılmalı!
    func pushFromTabBarCoordinatorAndVariables(_ coordinator: Coordinator, hidesBottomBar: Bool = false) {
        guard let navController = tabBarCoordinator.tabBarController.selectedViewController as? UINavigationController,
              let newVC = coordinator.navigationController.viewControllers.first else {
            return
        }

        newVC.hidesBottomBarWhenPushed = hidesBottomBar
        navController.pushViewController(newVC, animated: true)
    }
    
    func pushFromTeacherScreenCoordinatorAndVariables(_ coordinator: Coordinator, hidesBottomBar: Bool = false) {
        let navController = teacherCoordinator.navigationController
        if let newVC = coordinator.navigationController.viewControllers.first {
            newVC.hidesBottomBarWhenPushed = hidesBottomBar
            navController.pushViewController(newVC, animated: true)
        }
    }

    func pushToTeacherScreen(){
        let navController = LoginScreenCoordinator.getInstance().navigationController

        if let existingRegisterVC = navController.viewControllers.first(where: { $0 is TeacherScreenViewController }) {
            navController.popToViewController(existingRegisterVC, animated: true)
        } else {
            let registerCoordinator = TeacherScreenCoordinator.getInstance()
            registerCoordinator.start()
            
            if let registerVC = registerCoordinator.navigationController.viewControllers.first {
                navController.pushViewController(registerVC, animated: true)
            }
        }
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
    
    func pushToLevelScreen() {
        let navController = LoginScreenCoordinator.getInstance().navigationController

        if let existingLoginVC = navController.viewControllers.first(where: { $0 is LevelScreenViewController }) {
            navController.popToViewController(existingLoginVC, animated: true)
        } else {
            let mainLoginCoordinator = LevelScreenCoordinator.getInstance()
            mainLoginCoordinator.start()
            
            if let mainLoginVC = mainLoginCoordinator.navigationController.viewControllers.first {
                navController.pushViewController(mainLoginVC, animated: true)
            }
        }
    }
    
    func pushToVerifyEmailScreen(){
        let navController = LoginScreenCoordinator.getInstance().navigationController

        if let existingLoginVC = navController.viewControllers.first(where: { $0 is VerifyEmailScreenViewController }) {
            navController.popToViewController(existingLoginVC, animated: true)
        } else {
            let mainLoginCoordinator = VerifyEmailScreenCoordinator.getInstance()
            mainLoginCoordinator.start()
            
            if let mainLoginVC = mainLoginCoordinator.navigationController.viewControllers.first {
                navController.pushViewController(mainLoginVC, animated: true)
            }
        }
    }
    
    func pushToVerifyEmailScreen(with viewModel: VerifyEmailScreenViewModel) {
        let navController = LoginScreenCoordinator.getInstance().navigationController

        if let existingRegisterVC = navController.viewControllers.first(where: { $0 is VerifyEmailScreenViewController }) {
            navController.popToViewController(existingRegisterVC, animated: true)
        } else {
            let verifyCoordinator = VerifyEmailScreenCoordinator.getInstance()
            verifyCoordinator.start(with: viewModel)

            if let verifyVC = verifyCoordinator.navigationController.viewControllers.first {
                navController.pushViewController(verifyVC, animated: true)
            }
        }
    }

    
    func pushToForgotPasswordScreen(){
        let navController = LoginScreenCoordinator.getInstance().navigationController

        if let existingLoginVC = navController.viewControllers.first(where: { $0 is ForgotPasswordViewController }) {
            navController.popToViewController(existingLoginVC, animated: true)
        } else {
            let mainLoginCoordinator = ForgotPasswordCoordinator.getInstance()
            mainLoginCoordinator.start()
            
            if let mainLoginVC = mainLoginCoordinator.navigationController.viewControllers.first {
                navController.pushViewController(mainLoginVC, animated: true)
            }
        }
    }
    
    func pushToResetPasswordScreen(with viewModel: ResetPasswordScreenViewModel) {
        let navController = LoginScreenCoordinator.getInstance().navigationController

        if let existingRegisterVC = navController.viewControllers.first(where: { $0 is ResetPasswordScreenViewController }) {
            navController.popToViewController(existingRegisterVC, animated: true)
        } else {
            let verifyCoordinator = ResetPasswordScreenCoordinator.getInstance()
            verifyCoordinator.start(with: viewModel)

            if let verifyVC = verifyCoordinator.navigationController.viewControllers.first {
                navController.pushViewController(verifyVC, animated: true)
            }
        }
    }
    
    func pushToAddQuestionScreen() {
        let navController = LoginScreenCoordinator.getInstance().navigationController

        if let existingLoginVC = navController.viewControllers.first(where: { $0 is AddQuestionScreenViewController }) {
            navController.popToViewController(existingLoginVC, animated: true)
        } else {
            let mainLoginCoordinator = AddQuestionScreenCoordinator.getInstance()
            mainLoginCoordinator.start()
            
            if let mainLoginVC = mainLoginCoordinator.navigationController.viewControllers.first {
                navController.pushViewController(mainLoginVC, animated: true)
            }
        }
    }

    func handleCourseEntry(with viewModel: CourseScreenViewModel) {
        let coordinator = CourseScreenCoordinator.getInstance()
        coordinator.start(with: viewModel)
        pushFromTabBarCoordinatorAndVariables(coordinator, hidesBottomBar: true)
    }
    
    func handleAddQuestionEntry(with viewModel: AddQuestionScreenViewModel) {
        let coordinator = AddQuestionScreenCoordinator.getInstance()
        coordinator.start(with: viewModel)
        pushFromTeacherScreenCoordinatorAndVariables(coordinator, hidesBottomBar: true)
    }


}


