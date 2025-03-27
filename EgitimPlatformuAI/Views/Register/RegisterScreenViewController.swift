//
//  RegisterScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 28.03.2025.
//

import UIKit
class RegisterScreenViewController: UIViewController {

    var viewModel: RegisterScreenViewModel?
    private var hamburgerMenuManager: HamburgerMenuManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Register"
        navigationController?.isNavigationBarHidden = false
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
}
