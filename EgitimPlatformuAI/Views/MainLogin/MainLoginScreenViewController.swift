//
//  MainLoginViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 22.04.2025.
//

import UIKit

class MainLoginScreenViewController: UIViewController {

    private var hamburgerMenuManager: HamburgerMenuManager!
    var viewModel: MainLoginScreenViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        removeEdgePanGesture()

    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            self.navigationController?.isNavigationBarHidden = true
        }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func removeEdgePanGesture() {
        if let window = hamburgerMenuManager.getKeyWindow() {
            window.gestureRecognizers?.removeAll(where: { $0 is UIScreenEdgePanGestureRecognizer })
        }
    }


}
