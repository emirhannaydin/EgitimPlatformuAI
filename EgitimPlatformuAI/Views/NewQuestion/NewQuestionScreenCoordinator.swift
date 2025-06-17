//
//  NewQuestionScreenCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 12.06.2025.
//

import Foundation
import UIKit

public final class NewQuestionScreenCoordinator: Coordinator {
    private static var instance: NewQuestionScreenCoordinator?
    
    static func getInstance() -> NewQuestionScreenCoordinator {
        if instance == nil {
            instance = NewQuestionScreenCoordinator()
        }
        return instance!
    }
    
    var navigationController = UINavigationController()
    
    func start() {
        let storyboard = UIStoryboard(name: "NewQuestionScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "NewQuestionScreen")
                as? NewQuestionScreenViewController else {
            fatalError("Failed to instantiate NewQuestionScreenViewController")
        }
        
        let viewModel = NewQuestionScreenViewModel(coordinator: self, selectedLessonId: nil, selecteCourseName: "", isUpdate: false)
        viewController.viewModel = viewModel
        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func start(with viewModel: NewQuestionScreenViewModel) {
        let storyboard = UIStoryboard(name: "NewQuestionScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "NewQuestionScreen") as? NewQuestionScreenViewController else {
            fatalError("Failed to instantiate NewQuestionScreenViewController")
        }

        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .pageSheet

        if #available(iOS 15.0, *) {
            if let sheet = viewController.sheetPresentationController {
                sheet.detents = [.large()] // Sadece medium, yukarı çıkamaz
                sheet.prefersGrabberVisible = true // Yukarıdaki çubuk
                sheet.largestUndimmedDetentIdentifier = .medium // Arka planı karart
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false // Scroll varsa büyümesin
            }
        }

        UIApplication.shared.windows.first?.rootViewController?.present(viewController, animated: true)
    }



    
    
}
