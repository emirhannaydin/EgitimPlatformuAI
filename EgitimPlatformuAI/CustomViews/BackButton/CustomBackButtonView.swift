//
//  CustomBackButtonView.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 6.04.2025.
//

import UIKit

class CustomBackButtonView: UIView {
    

    @IBOutlet var backButton: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setViews()

    }
    
    private func setViews() {
        guard let view = self.loadViewFromNib(nibName: "CustomBackButtonView") else { return }
        view.frame = self.bounds
        self.addSubview(view)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.systemGray2.cgColor
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    }

}
