//
//  MainLoginViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 22.04.2025.
//

import UIKit

class MainLoginScreenViewController: UIViewController {

    var viewModel: MainLoginScreenViewModel?

    @IBOutlet var backButton: CustomBackButtonView!
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            self.navigationController?.isNavigationBarHidden = true
        }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func registerNowButton(_ sender: Any) {
        ApplicationCoordinator.getInstance().navigateToRegister()
    }
    
    @IBAction func loginButton(_ sender: Any) {
        ApplicationCoordinator.getInstance().initTabBar()
    }
}
