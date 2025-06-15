//
//  HamburgerMenuManager.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 10.03.2025.
//

import UIKit

class HamburgerMenuManager: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var viewController: UIViewController
    private var menuView: UIView!
    private var backgroundView: UIView!
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init()
    }
    
    func setNavigationBar() {
        configureNavigationBarAppearance()
        configureMenuButton()
        addEdgePanGesture()
    }
    
    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.backDarkBlue
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]
        viewController.navigationController?.navigationBar.standardAppearance = appearance
        viewController.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func configureMenuButton() {
        let menuButton = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal"),
            style: .plain,
            target: self,
            action: #selector(toggleSlideMenu)
        )
        menuButton.tintColor = .summer
        viewController.navigationItem.leftBarButtonItem = menuButton
    }
    
    private func addEdgePanGesture() {
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(_:)))
        edgePanGesture.edges = .left
        edgePanGesture.name = "EdgePanGesture"
        
        if let window = getKeyWindow(), window.gestureRecognizers?.contains(where: { $0.name == "EdgePanGesture" }) == false {
            window.addGestureRecognizer(edgePanGesture)
        }
    }
    
    @objc private func handleEdgePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
        let translation = gesture.translation(in: viewController.view).x
        if gesture.state == .ended, translation > 50 {
            showSlideMenu()
        }
    }
    
    @objc func toggleSlideMenu() {
        if getKeyWindow()?.viewWithTag(999) != nil {
            hideSlideMenu()
        } else {
            showSlideMenu()
        }
    }
    
    private func showSlideMenu() {
        guard let window = getKeyWindow() else { return }
        backgroundView = createBackgroundView()
        menuView = createMenuView(in: window)
        setupMenuSubviews(in: menuView)
        
        window.addSubview(backgroundView)
        window.addSubview(menuView)
        
        UIView.animate(withDuration: 0.3) {
            self.menuView.frame.origin.x = 0
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
        menuView.backgroundColor = .darkBlue
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
    
    func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first
    }
    
    private func getTableView() -> UITableView {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HamburgerTableViewCell.nib(), forCellReuseIdentifier: HamburgerTableViewCell.identifier)
        tableView.backgroundColor = .darkBlue
        return tableView
    }
    
    private func getImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .porcelain
        return imageView
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HamburgerTableViewCell.identifier) as! HamburgerTableViewCell
        cell.logoImageView.backgroundColor = .clear
        cell.labelText.backgroundColor = .clear
        cell.backgroundColor = .charcoal
        switch indexPath.row {
        case 0:
            cell.labelText.text = "Home"
            cell.logoImageView.image = UIImage(systemName: "house")
            cell.logoImageView.tintColor = .softRed
        case 1:
            cell.labelText.text = "AI"
            cell.logoImageView.image = UIImage(systemName: "checkmark.message")
            cell.logoImageView.tintColor = .summer
        case 2:
            cell.labelText.text = "Profile"
            cell.logoImageView.image = UIImage(systemName: "person.circle")
            cell.logoImageView.tintColor = .royalBlue
        default:
            cell.labelText.text = "--"
            cell.logoImageView.image = UIImage(systemName: "link")
            cell.logoImageView.tintColor = .lightGray
        }
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .backDarkBlue
        cell.selectedBackgroundView = selectedBackgroundView
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected menu item \(indexPath.row + 1)")
        hideSlideMenu()
        
        
        switch indexPath.row {
        case 0:
            ApplicationCoordinator.getInstance().navigateToMain()
        case 1:
            ApplicationCoordinator.getInstance().navigateToAI()
        case 2:
            ApplicationCoordinator.getInstance().navigateToProfile()
        default:
            break
        }
    }
}
