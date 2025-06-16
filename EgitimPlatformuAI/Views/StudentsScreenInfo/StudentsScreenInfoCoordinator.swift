//
//  StudentsScreenInfoCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 16.06.2025.
//

import Foundation
import UIKit

public final class StudentsScreenInfoCoordinator: Coordinator {
    private static var instance: StudentsScreenInfoCoordinator?
    
    static func getInstance() -> StudentsScreenInfoCoordinator {
        if instance == nil {
            instance = StudentsScreenInfoCoordinator()
        }
        return instance!
    }
    
    var navigationController = UINavigationController()
    
    func start() {
        let storyboard = UIStoryboard(name: "StudentsScreenInfo", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "StudentsScreenInfo")
                as? StudentsScreenInfoViewController else {
            fatalError("Failed to instantiate StudentsScreenInfoViewController")
        }
        
        let viewModel = StudentsScreenInfoViewModel(coordinator: self, studentId: "")
        viewController.viewModel = viewModel
        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func start(with viewModel: StudentsScreenInfoViewModel) {
        let storyboard = UIStoryboard(name: "StudentsScreenInfo", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "StudentsScreenInfo")
                as? StudentsScreenInfoViewController else {
            fatalError("Failed to instantiate StudentsScreenInfoViewController")
        }

        viewController.viewModel = viewModel

        viewController.modalPresentationStyle = .pageSheet

        if #available(iOS 15.0, *) {
            if let sheet = viewController.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
                sheet.largestUndimmedDetentIdentifier = .medium // Arka plan kararsın
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false // Scroll olsa bile büyümesin
            }
        }

        UIApplication.shared.windows.first?.rootViewController?.present(viewController, animated: true)
    }
}
