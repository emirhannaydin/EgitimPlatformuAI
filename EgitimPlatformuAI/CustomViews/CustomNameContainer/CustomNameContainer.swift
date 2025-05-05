//
//  CustomNameContainer.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 18.01.2025.
//

import UIKit

final class CustomNameContainer: UIView {
    
    weak var hamburgerMenuManager: HamburgerMenuManager?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViews()
        hamburgerMenuManager = HamburgerMenuManager(viewController: MainScreenViewController())
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setViews()

    }
    
    private func setViews() {
           guard let view = self.loadViewFromNib(nibName: "CustomNameContainerView") else { return }
           view.frame = self.bounds
           self.addSubview(view)
       }
       
       func configureView(nameText: String, statusText: String, imageName: String) {
           self.nameLabel.adjustsFontSizeToFitWidth = true
           self.nameLabel.text = nameText
           self.imageView.image = UIImage(systemName: imageName)
           imageView.isUserInteractionEnabled = true
           
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
           imageView.addGestureRecognizer(tapGesture)
       }
       
       @objc private func imageTapped() {
           hamburgerMenuManager?.toggleSlideMenu()
       }


    
    
    
}
