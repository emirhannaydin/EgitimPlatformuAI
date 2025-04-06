//
//  UIColorExtensions.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 27.03.2025.
//

import UIKit

extension UIColor {
    static let customDarkBlue = UIColor(hex: "#1E232C")
    static let customPorcelain = UIColor(hex: "#F7F8F9")

    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let g = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let b = CGFloat(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
