//  UIViewControllerExtensions.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 18.01.2025.
//

import UIKit

extension UIViewController {
    func setNavigateBar() {
        let menuButton = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal"),
            style: .plain,
            target: self,
            action: #selector(hamburgerMenuTapped)
        )
        menuButton.tintColor = .black
        navigationItem.leftBarButtonItem = menuButton
        
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
    
    @objc func hamburgerMenuTapped() {
        toggleSlideMenu()
    }
    
    private func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }

    func toggleSlideMenu() {
        if let menuView = getKeyWindow()?.viewWithTag(999) {
            hideSlideMenu()
        } else {
            showSlideMenu()
        }
    }
    
    private func showSlideMenu() {
        guard let window = getKeyWindow() else { return }
        
        let backgroundView = UIView(frame: window.bounds)
        backgroundView.tag = 1000
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let menuView = UIView()
        menuView.tag = 999
        menuView.backgroundColor = .systemBackground
        menuView.frame = CGRect(x: -300, y: 0, width: window.frame.width * 2/3, height: window.frame.height)

        let closeButton = UIButton(frame: backgroundView.bounds)
        closeButton.addTarget(self, action: #selector(hideSlideMenu), for: .touchUpInside)
        
        backgroundView.addSubview(closeButton)
        window.addSubview(backgroundView)
        window.addSubview(menuView)
        
        let tableView = UITableView(frame: menuView.bounds)
            tableView.delegate = self
            tableView.dataSource = self
            menuView.addSubview(tableView)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        menuView.addGestureRecognizer(panGesture)

        UIView.animate(withDuration: 0.3) {
            menuView.frame.origin.x = 0
        }
    }
    
    @objc private func hideSlideMenu() {
        guard let window = getKeyWindow(),
              let menuView = window.viewWithTag(999),
              let backgroundView = window.viewWithTag(1000) else { return }

        UIView.animate(withDuration: 0.3, animations: {
            menuView.frame.origin.x = -300
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
            if translation.x < 0 { // Sadece sola sürüklemeye izin veriyoruz
                menuView.frame.origin.x = max(-menuView.frame.width, translation.x)
            }
        case .ended:
            let shouldClose = translation.x < -menuView.frame.width / 3 // Menü yeterince sola kaydıysa kapat
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
}

extension UIViewController: @retroactive UITableViewDataSource, @retroactive UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 5 // Menüde gösterilecek öğe sayısı
        }

        // Menü öğelerini tanımlıyoruz
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell") ?? UITableViewCell(style: .default, reuseIdentifier: "MenuItemCell")
            cell.textLabel?.text = "Menu Item \(indexPath.row + 1)" // Menü öğelerini buradan belirleyebilirsiniz
            return cell
        }

        
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("Selected menu item \(indexPath.row + 1)")
            hideSlideMenu()
        }
}


