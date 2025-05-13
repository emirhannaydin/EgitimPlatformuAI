//
//  CustomContinueView.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.05.2025.
//

import UIKit

final class CustomContinueView: UIView {

    @IBOutlet var descLabel: UILabel!
    @IBOutlet var continueButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViews()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setViews()

    }
    
    private func setViews() {
           guard let view = self.loadViewFromNib(nibName: "CustomContinueView") else { return }
           view.frame = self.bounds
           self.addSubview(view)
       }
}
