//
//  CourseRegister.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 15.06.2025.
//

struct CourseRegisterRequest: Codable {
    let studentId: String
    let courseRegisters: [CourseRegister]
}

struct CourseRegister: Codable {
    let courseId: String
    let level: Int
}
