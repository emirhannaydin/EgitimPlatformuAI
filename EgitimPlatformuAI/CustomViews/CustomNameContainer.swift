//
//  CustomNameContainer.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 18.01.2025.
//

import UIKit

final class CustomNameContainer: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setView()

    }
    
    private func setView() {
        guard let view = self.loadViewFromNib(nibName: "CustomNameContainerView") else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }

    
    func configureView(title: String){
        self.titleLabel.text = title
    }
    
}
