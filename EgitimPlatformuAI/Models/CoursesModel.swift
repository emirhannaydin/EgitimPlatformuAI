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
    let classes: [String]
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

struct Lesson: Codable {
    let id: String
    let order: Int
    let classId: String
    let content: String
    let isCompleted: Bool
}

struct CourseClass: Codable {
    let id: String
    let level: Int
    let courseName: String
    let courseId: String
    let name: String
    let completedLessonCount: Int
    let studentStatus: Int
    let lessons: [Lesson]
    let lessonCount: Int
    let myProperty: Int
}



