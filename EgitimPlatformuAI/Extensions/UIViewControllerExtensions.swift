//  UIViewControllerExtensions.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 18.01.2025.
//

import UIKit

extension UIViewController {
    func setNavigationBar() {
        configureNavigationBarAppearance()
        configureMenuButton()
        addEdgePanGesture()
    }
    
    private func configureNavigationBarAppearance() {
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
    
    private func configureMenuButton() {
        let menuButton = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal"),
            style: .plain,
            target: self,
            action: #selector(toggleSlideMenu)
        )
        menuButton.tintColor = .black
        navigationItem.leftBarButtonItem = menuButton
    }
    
    private func addEdgePanGesture() {
        guard let window = getKeyWindow() else { return }
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(_:)))
        edgePanGesture.edges = .left
        window.addGestureRecognizer(edgePanGesture)
    }
    
    @objc private func handleEdgePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
        let translation = gesture.translation(in: view).x
        if gesture.state == .ended, translation > 50 {
            showSlideMenu()
        }
    }
    
    @objc private func toggleSlideMenu() {
        if getKeyWindow()?.viewWithTag(999) != nil {
            hideSlideMenu()
        } else {
            showSlideMenu()
        }
    }
    
    private func showSlideMenu() {
        guard let window = getKeyWindow() else { return }
        let backgroundView = createBackgroundView()
        let menuView = createMenuView(in: window)
        setupMenuSubviews(in: menuView)
        
        window.addSubview(backgroundView)
        window.addSubview(menuView)
        
        UIView.animate(withDuration: 0.3) {
            menuView.frame.origin.x = 0
        }
    }
    
    private func createBackgroundView() -> UIView {
        guard let window = getKeyWindow() else { return UIView() }
        let backgroundView = UIView(frame: window.bounds)
        backgroundView.tag = 1000
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let closeButton = UIButton(frame: backgroundView.bounds)
        closeButton.addTarget(self, action: #selector(hideSlideMenu), for: .touchUpInside)
        backgroundView.addSubview(closeButton)
        return backgroundView
    }
    
    private func createMenuView(in window: UIWindow) -> UIView {
        let menuView = UIView()
        menuView.tag = 999
        menuView.backgroundColor = .systemBackground
        menuView.frame = CGRect(x: -300, y: 0, width: window.frame.width * 2/3, height: window.frame.height)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        menuView.addGestureRecognizer(panGesture)
        return menuView
    }
    
    private func setupMenuSubviews(in menuView: UIView) {
        let tableView = getTableView()
        let imageView = getImageView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        menuView.addSubview(tableView)
        menuView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: menuView.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant: 5),
            imageView.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: -5),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: -5),
            tableView.bottomAnchor.constraint(equalTo: menuView.bottomAnchor)
        ])
    }
    
    @objc private func hideSlideMenu() {
        guard let window = getKeyWindow(),
              let menuView = window.viewWithTag(999),
              let backgroundView = window.viewWithTag(1000) else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            menuView.frame.origin.x = -menuView.frame.width
            backgroundView.alpha = 0
        }) { _ in
            menuView.removeFromSuperview()
            backgroundView.removeFromSuperview()
        }
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let menuView = gesture.view else { return }
        let translation = gesture.translation(in: menuView)
        
        switch gesture.state {
        case .changed:
            if translation.x < 0 {
                menuView.frame.origin.x = max(-menuView.frame.width, translation.x)
            }
        case .ended:
            let shouldClose = translation.x < -menuView.frame.width / 3
            if shouldClose {
                hideSlideMenu()
            } else {
                UIView.animate(withDuration: 0.3) {
                    menuView.frame.origin.x = 0
                }
            }
        default:
            break
        }
    }
    
    private func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first
    }
    
    private func getTableView() -> UITableView {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HamburgerTableViewCell.nib(), forCellReuseIdentifier: HamburgerTableViewCell.identifier)
        return tableView
    }
    
    private func getImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        return imageView
    }
}

extension UIViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HamburgerTableViewCell.identifier) as! HamburgerTableViewCell
        switch indexPath.row {
        case 0:
            cell.labelText.text = "Login"
            cell.logoImageView.image = UIImage(systemName: "lock")
            cell.logoImageView.tintColor = .green
        case 1:
            cell.labelText.text = "Profile"
            cell.logoImageView.image = UIImage(systemName: "person.circle")
            cell.logoImageView.tintColor = .blue
        case 2:
            cell.labelText.text = "Home"
            cell.logoImageView.image = UIImage(systemName: "house")
            cell.logoImageView.tintColor = .red
        default:
            cell.labelText.text = "--"
            cell.logoImageView.image = UIImage(systemName: "link")
            cell.logoImageView.tintColor = .darkGray
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected menu item \(indexPath.row + 1)")
        hideSlideMenu()
        
        let tabBarController = TabBarCoordinator.getInstance().tabBarController
        
        switch indexPath.row {
        case 0: // Login sayfası, tab barda olmadığı için push yapılabilir
            let loginCoordinator = LoginScreenCoordinator.getInstance()
            loginCoordinator.navigationController = tabBarController.selectedViewController as? UINavigationController
            loginCoordinator.start()
            
        case 1: // Profile sayfası tab bar içinde, bu yüzden sadece tab'a geçmeliyiz
            tabBarController.selectedIndex = 1
            
        case 2: // Home sayfası tab bar içinde, bu yüzden sadece tab'a geçmeliyiz
            tabBarController.selectedIndex = 0
            
        default:
            break
        }
    }
}
