//
//  UIViewExtensions.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 18.01.2025.
//

import Foundation
import UIKit

extension UIView {
    func loadViewFromNib(nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        guard let view = bundle.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView else {
            return nil
        }
        return view
    }
}

