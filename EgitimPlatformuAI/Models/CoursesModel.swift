//
//  CoursesModel.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 26.05.2025.
//


import Foundation

struct Course: Codable {
    let name: String
    let description: String
    let duration: Int
    let level: Int
    let courseType: Int
    let classes: [String] // Eğer `classes` içeriği boşsa, şu an için [String] olarak bırakabiliriz.
    let id: String
    let createdDate: String
    let updatedDate: String
}

struct CourseRegisterRequest: Codable {
    let studentId: String
    let courseRegisters: [CourseRegister]
}

struct CourseRegister: Codable {
    let courseId: String
    let level: Int
}


