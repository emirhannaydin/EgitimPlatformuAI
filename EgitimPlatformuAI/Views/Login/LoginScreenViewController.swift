//
//  LoginScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 28.02.2025.
//
import UIKit
import Foundation

public final class LoginScreenViewController: UIViewController {
    
    
    @IBOutlet var loginButton: UIButton!
    
    var viewModel: LoginScreenViewModel?

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        self.setNavigationBar()
    }
    @IBAction func loginButtonClicked(_ sender: Any) {
        ApplicationCoordinator.getInstance().start()
    }
    
}
