//
//  NewLessonScreenCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 12.06.2025.
//

import Foundation
import UIKit

public final class NewLessonScreenCoordinator: Coordinator {
    private static var instance: NewLessonScreenCoordinator?
    
    static func getInstance() -> NewLessonScreenCoordinator {
        if instance == nil {
            instance = NewLessonScreenCoordinator()
        }
        return instance!
    }
    
    var navigationController = UINavigationController()
    
    func start() {
        let storyboard = UIStoryboard(name: "NewLessonScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "NewLessonScreen")
                as? NewLessonScreenViewController else {
            fatalError("Failed to instantiate NewLessonScreenViewController")
        }
        
        let viewModel = NewLessonScreenViewModel(coordinator: self, courseClasses: [])
        viewController.viewModel = viewModel
        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func start(with viewModel: NewLessonScreenViewModel) {
        let storyboard = UIStoryboard(name: "NewLessonScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "NewLessonScreen") as? NewLessonScreenViewController else {
            fatalError("Failed to instantiate NewLessonScreenViewController")
        }

        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .pageSheet

        if #available(iOS 15.0, *) {
            if let sheet = viewController.sheetPresentationController {
                sheet.detents = [.medium()] // Sadece medium seviyeye kadar açılsın
                sheet.prefersGrabberVisible = true // Yukarıdaki tutma çubuğu görünsün
                sheet.largestUndimmedDetentIdentifier = .medium // Arka plan kararsın
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false // Scroll olsa bile büyümesin
            }
        }

        UIApplication.shared.windows.first?.rootViewController?.present(viewController, animated: true)
    }


    
    
}
