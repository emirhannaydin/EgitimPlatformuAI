//
//  UITextViewExtensions.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 26.05.2025.
//

import UIKit

extension WritingScreenViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter your text here..." {
            textView.text = ""
            textView.textColor = .porcelain
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "Enter your text here..."
            textView.textColor = .lightGray
        }
    }
}
