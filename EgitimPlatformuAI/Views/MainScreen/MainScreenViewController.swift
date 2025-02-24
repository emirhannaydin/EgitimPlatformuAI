//
//  ViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 16.01.2025.
//
import UIKit

class MainScreenViewController: UIViewController {

    @IBOutlet weak var nameContainerView: CustomNameContainer!
    var viewModel: MainScreenViewModel?

    private var menuView: UIView?
    private var closeButton: UIButton?
    private var isMenuVisible = false

    init(viewModel: MainScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        self.setNavigateBar()
        nameContainerView.configureView(nameLabel: "emirhanaydin_1600@hotmail.com", statusLabel: "Online", image: "person.fill")
    }

    override func hamburgerMenuTapped() {
        toggleSlideMenu()
    }

    private func toggleSlideMenu() {
        if isMenuVisible {
            hideSlideMenu()
        } else {
            showSlideMenu()
        }
    }

    private func showSlideMenu() {
        guard menuView == nil else { return } // Eğer menü zaten açıksa tekrar açma

        let menuView = UIView()
        menuView.backgroundColor = .red
        menuView.frame = CGRect(x: -300, y: 0, width: view.frame.width/2, height: view.frame.height - TabBarCoordinator.getInstance().tabBarController.tabBar.frame.height)
        view.addSubview(menuView)
        self.menuView = menuView
        
        let closeButton = UIButton(frame: view.bounds)
        closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        closeButton.addTarget(self, action: #selector(hideSlideMenu), for: .touchUpInside)
        view.insertSubview(closeButton, belowSubview: menuView)
        self.closeButton = closeButton

        UIView.animate(withDuration: 0.3) {
            menuView.frame.origin.x = 0
        }

        isMenuVisible = true
    }

    @objc private func hideSlideMenu() {
        guard let menuView = self.menuView else { return }

        UIView.animate(withDuration: 0.3, animations: {
            menuView.frame.origin.x = -300
        }) { _ in
            menuView.removeFromSuperview()
            self.menuView = nil

            self.closeButton?.removeFromSuperview()
            self.closeButton = nil
        }

        isMenuVisible = false
    }
}
