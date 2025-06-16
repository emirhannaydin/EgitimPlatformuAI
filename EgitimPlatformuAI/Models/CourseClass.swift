//
//  CourseClass.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 15.06.2025.
//

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

struct Lesson: Codable {
    let id: String
    let order: Int
    let classId: String
    let content: String
    let isCompleted: Bool?
    let students: [String]?
    let questions: [String]?
    let questionCount: Int?
}


