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
    
    func showAlertWithAction(title: String, message: String, okAction: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
            okAction()
        }

        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(okButton)
        alertController.addAction(cancelButton)

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
    
    func animateViewShake(_ view: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 5, y: view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 5, y: view.center.y))
        view.layer.add(animation, forKey: "position")
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
    
    func setupPasswordToggle(for textField: UITextField) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .gray
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
        
        textField.rightView = button
        textField.rightViewMode = .always
        textField.isSecureTextEntry = true
    }
    
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        guard let textField = sender.superview as? UITextField ?? (sender.superview?.superview as? UITextField) else { return }

        textField.isSecureTextEntry.toggle()
        
        let imageName = textField.isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    func applyGradientBackground() {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = view.bounds

            gradientLayer.colors = [
                UIColor.backDarkBlue.cgColor,
                UIColor.charcoal.cgColor
            ]

            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)

            view.layer.insertSublayer(gradientLayer, at: 0)
        }
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture)
        }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}


