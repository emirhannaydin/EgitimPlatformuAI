//
//  Login.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 27.04.2025.
//

struct LoginResponse: Codable {
    let token: String
    let user: User
}

struct User: Codable {
    let id: String
    let name: String
    let userType: Int
    let eMail: String
    let isEmailActivated: Bool
    let classes: [CourseClass]?
}
