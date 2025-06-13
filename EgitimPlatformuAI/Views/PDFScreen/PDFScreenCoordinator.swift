//
//  PDFScreenCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.06.2025.
//

import Foundation
import UIKit

public final class PDFScreenCoordinator: Coordinator {
    private static var instance: PDFScreenCoordinator?
    
    static func getInstance() -> PDFScreenCoordinator {
        if instance == nil {
            instance = PDFScreenCoordinator()
        }
        return instance!
    }
    
    var navigationController = UINavigationController()
    
    func start() {
        let storyboard = UIStoryboard(name: "PDFScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "PDFScreen")
                as? PDFScreenViewController else {
            fatalError("Failed to instantiate PDFScreenViewController")
        }
        
        let viewModel = PDFScreenViewModel(coordinator: self, fileName: "")
        viewController.viewModel = viewModel
        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func start(with viewModel: PDFScreenViewModel) {
        let storyboard = UIStoryboard(name: "PDFScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "PDFScreen")
                as? PDFScreenViewController else {
            fatalError("Failed to instantiate PDFScreenViewController")
        }
        
        
        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .pageSheet

        if #available(iOS 15.0, *) {
            if let sheet = viewController.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
            }
        }
        
        UIApplication.shared.windows.first?.rootViewController?.present(viewController, animated: true)
        
    }
}
    

