//
//  UIViewControllerExtensions.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 18.01.2025.
//

import UIKit

extension UIViewController{
    func setNavigateBar(){
        let menuButton = UIBarButtonItem(
                    image: UIImage(systemName: "line.3.horizontal"),
                    style: .plain,
                    target: self,
                    action: #selector(hamburgerMenuTapped)
                )
                menuButton.tintColor = .black
                navigationItem.leftBarButtonItem = menuButton
        

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemGreen
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc func hamburgerMenuTapped() {
            
        }
}
