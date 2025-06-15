//
//  CustomNameContainer.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 18.01.2025.
//

import UIKit

final class CustomNameContainer: UIView {
    
    var hamburgerMenuManager: HamburgerMenuManager!
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var logoutImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var onLogoutTapped: (() -> Void)?
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
       
    func configureView(nameText: String, welcomeLabelText: String, imageName: String, levelName: String, levelColor: UIColor) {
        self.nameLabel.adjustsFontSizeToFitWidth = true

        let attributedText = NSMutableAttributedString(string: nameText, attributes: [
            .font: UIFont.systemFont(ofSize: nameLabel.font.pointSize)
        ])

        let levelRange = (nameText as NSString).range(of: levelName)
        if levelRange.location != NSNotFound {
            attributedText.addAttributes([
                .foregroundColor: levelColor,
                .font: UIFont.boldSystemFont(ofSize: nameLabel.font.pointSize)
            ], range: levelRange)
        }

        self.nameLabel.attributedText = attributedText
        self.imageView.image = UIImage(systemName: imageName)
        imageView.isUserInteractionEnabled = true
        self.welcomeLabel.text = welcomeLabelText

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGesture)

        let logoutTapGesture = UITapGestureRecognizer(target: self, action: #selector(logoutImageTapped))
        logoutImage.addGestureRecognizer(logoutTapGesture)
    }


   
    @objc private func imageTapped() {
        hamburgerMenuManager?.toggleSlideMenu()
    }
    
    @objc private func logoutImageTapped() {
        onLogoutTapped?()
    }
}
