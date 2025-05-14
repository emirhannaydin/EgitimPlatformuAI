//
//  CourseType.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 15.05.2025.
//

enum CourseType {
    case reading
    case listening
    case writing
    case speaking

    var courseName: String {
        switch self {
        case .reading: return "Reading Course"
        case .listening: return "Listening Course"
        case .writing: return "Writing Course"
        case .speaking: return "Speaking Course"
        }
    }

    var courseLevelName: String {
        switch self {
        case .reading: return "A1"
        case .listening: return "B1"
        case .writing: return "B2"
        case .speaking: return "B3"
        }
    }
}

