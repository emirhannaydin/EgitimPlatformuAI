//  UIViewControllerExtensions.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 18.01.2025.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, okAction: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Okey", style: .default) { _ in
            okAction?()
        }
        
        alertController.addAction(okButton)
        present(alertController, animated: true)
    }
}

