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
}



