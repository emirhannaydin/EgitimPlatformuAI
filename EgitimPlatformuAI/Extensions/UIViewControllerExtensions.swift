//  UIViewControllerExtensions.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 18.01.2025.
//

import UIKit
import Lottie

private var lottieLoadingTag = 888888

extension UIViewController {
    func showAlert(title: String, message: String, okAction: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Okey", style: .default) { _ in
            okAction?()
        }
        
        alertController.addAction(okButton)
        present(alertController, animated: true)
    }
    
    func animateLabelShake(_ label: UILabel) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: label.center.x - 5, y: label.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: label.center.x + 5, y: label.center.y))
        label.layer.add(animation, forKey: "position")
    }
    
    
    func showLottieLoading(animationName: String = "loading") {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow }).first,
              window.viewWithTag(lottieLoadingTag) == nil else {
            return
        }
        
        let overlay = UIView()
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        overlay.tag = lottieLoadingTag
        overlay.isUserInteractionEnabled = true
        overlay.translatesAutoresizingMaskIntoConstraints = false
        
        let animationView = LottieAnimationView(name: animationName)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        
        overlay.addSubview(animationView)
        window.addSubview(overlay)
        
        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: window.topAnchor),
            overlay.bottomAnchor.constraint(equalTo: window.bottomAnchor),
            overlay.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            
            animationView.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: overlay.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 120),
            animationView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    func hideLottieLoading() {
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow }).first {
            window.viewWithTag(lottieLoadingTag)?.removeFromSuperview()
        }
        
    }
    
}


