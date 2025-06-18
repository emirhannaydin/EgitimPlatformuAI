//
//  StringExtensions.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 27.04.2025.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        guard let first = self.first else { return self }
        return first.uppercased() + self.dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func cleanedForComparison() -> String {
        let punctuationCharacters = CharacterSet.punctuationCharacters
        let cleaned = self
            .components(separatedBy: punctuationCharacters).joined()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        return cleaned
    }
    
    var isValidPassword: Bool {
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$&*_.?\\-])[A-Za-z!@#$&*_.?\\-\\d]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
    
    var hasUppercase: Bool {
            return range(of: "[A-Z]", options: .regularExpression) != nil
        }

        var hasLowercase: Bool {
            return range(of: "[a-z]", options: .regularExpression) != nil
        }

        var hasSpecialCharacter: Bool {
            return range(of: "[!@#$&*_.?\\-]", options: .regularExpression) != nil
        }

        var hasMinimumLength: Bool {
            return count >= 8
        }

    
}



