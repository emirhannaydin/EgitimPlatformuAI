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


    func animateIn() {
        self.transform = CGAffineTransform(translationX: 0, y: self.frame.height)

        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseOut], animations: {
            self.transform = .identity
        }, completion: nil)
    }
    
    func setCorrectAnswer(_ text: String = "Great Job!"){
        
        self.descLabel.text = text
        self.descLabel.textColor = .systemGreen
        self.continueButton.backgroundColor = .systemGreen
        self.continueButton.setTitle("Continue", for: .normal)
    }
    
    func setWrongAnswer(_ text: String = "Incorrect"){
        self.descLabel.text = text
        self.descLabel.textColor = .systemRed
        self.continueButton.backgroundColor = .systemRed
        self.continueButton.setTitle("Continue", for: .normal)
        
    }
    
    func setMedLevelAnswer(_ text: String = "Almost There!"){
        self.descLabel.text = text
        self.descLabel.textColor = .summer
        self.continueButton.backgroundColor = .summer
        self.continueButton.setTitle("Continue", for: .normal)
    }

    
}
