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
        showSlideMenu()
        
    }

       private func showSlideMenu() {
           // Menüyü temsil eden kırmızı bir view oluşturuluyor
           let menuView = UIView()
           menuView.backgroundColor = .red
           menuView.frame = CGRect(x: -300, y: 0, width: 300, height: view.frame.height) // Başlangıç konumu
           view.addSubview(menuView)
           
           // Animasyonlu olarak görünüme eklemek
           UIView.animate(withDuration: 0.3) {
               menuView.frame.origin.x = 0 // Sol tarafa kaydırılır
           }
           
           // Menüye dokunduğunda kapatılmasını sağlamak için bir kapatıcı alan eklenir
           let closeButton = UIButton(frame: view.bounds)
           closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Yarı saydam arka plan
           closeButton.addTarget(self, action: #selector(hideSlideMenu(_:)), for: .touchUpInside)
           view.insertSubview(closeButton, belowSubview: menuView)
           closeButton.tag = 999 // Belirlemek için bir tag atanır
       }

       @objc private func hideSlideMenu(_ sender: UIButton) {
           // Kapatma butonuna basıldığında menüyü kapatmak
           if let menuView = view.subviews.first(where: { $0.backgroundColor == .red }) {
               UIView.animate(withDuration: 0.3, animations: {
                   menuView.frame.origin.x = -300 // Eski konumuna kaydırılır
               }) { _ in
                   menuView.removeFromSuperview() // Görünüm kaldırılır
                   sender.removeFromSuperview() // Kapatma butonu kaldırılır
               }
           }
       }
    

}
