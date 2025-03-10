//
//  LoginScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 28.02.2025.
//
import UIKit
import Foundation

public final class LoginScreenViewController: UIViewController {
    
    private var hamburgerMenuManager: HamburgerMenuManager!
    @IBOutlet var loginButton: UIButton!
    
    var viewModel: LoginScreenViewModel?

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        hamburgerMenuManager = HamburgerMenuManager(viewController: self)
        removeEdgePanGesture()
    }
    @IBAction func loginButtonClicked(_ sender: Any) {
        ApplicationCoordinator.getInstance().initTabBar()
    }
    
    private func removeEdgePanGesture() {
        if let window = hamburgerMenuManager.getKeyWindow() {
            window.gestureRecognizers?.removeAll(where: { $0 is UIScreenEdgePanGestureRecognizer })
        }
    }
    
    
}
