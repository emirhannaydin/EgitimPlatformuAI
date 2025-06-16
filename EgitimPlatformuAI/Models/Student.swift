//
//  StudentModel.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 5.06.2025.
//

struct Student: Codable {
    let id: String
    let name: String
    let surname: String?
    let username: String?
    let email: String?
    let phoneNumber: String?
    let address: String?
    let profilePicture: String?
    let birthDate: String?
    let classes: [CourseClass]?
}

