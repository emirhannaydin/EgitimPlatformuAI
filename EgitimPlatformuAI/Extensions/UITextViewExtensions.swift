//
//  UITextViewExtensions.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 26.05.2025.
//

import UIKit

extension WritingScreenViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        let placeholderText = "Enter your answer here..."
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        let placeholderText = "Enter your answer here..."
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
    }
}
