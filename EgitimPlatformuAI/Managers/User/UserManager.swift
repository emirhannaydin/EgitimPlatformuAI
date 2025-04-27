//
//  UserManager.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 27.04.2025.
//

import UIKit

class UserManager {
    static let shared = UserManager()

    var userName: String? {
        return UserDefaults.standard.string(forKey: "userName")
    }
}
