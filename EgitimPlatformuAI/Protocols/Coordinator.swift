//
//  Coordinator.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 16.01.2025.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
        
    static func getInstance() -> Self
    
    
}
