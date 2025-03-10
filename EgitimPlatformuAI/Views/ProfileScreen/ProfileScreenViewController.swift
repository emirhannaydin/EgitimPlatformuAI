//
//  ProfileScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 16.01.2025.
//

import UIKit
class ProfileScreenViewController: UIViewController {

    var viewModel: ProfileScreenViewModel?
    private var hamburgerMenuManager: HamburgerMenuManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        hamburgerMenuManager = HamburgerMenuManager(viewController: self)
        hamburgerMenuManager.setNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
}
