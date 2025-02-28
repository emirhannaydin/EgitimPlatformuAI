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
    
    init(viewModel: LoginScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        self.setNavigateBar()
    }
    @IBAction func loginButtonClicked(_ sender: Any) {
        ApplicationCoordinator.getInstance().start()
    }
    
}
