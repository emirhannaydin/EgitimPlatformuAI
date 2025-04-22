//
//  CustomNameContainer.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 18.01.2025.
//

import UIKit

final class CustomNameContainer: UIView {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViews()
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

    
    func configureView(nameLabel: String, statusLabel: String, image: String){
        self.nameLabel.adjustsFontSizeToFitWidth = true
        self.nameLabel.text = nameLabel
        self.imageView.image = UIImage(systemName: "\(image)")
    }
    
    
    
}
