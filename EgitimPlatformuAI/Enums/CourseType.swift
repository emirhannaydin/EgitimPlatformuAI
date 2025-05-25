//
//  CourseType.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 15.05.2025.
//

import Foundation

enum CourseType: String {
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

    var introCoordinator: Coordinator {
        switch self {
        case .reading:
            return ReadingScreenCoordinator.getInstance()
        case .listening:
            return ListeningScreenCoordinator.getInstance()
        case .writing:
            return WritingScreenCoordinator.getInstance()
        case .speaking:
            return SpeakingScreenCoordinator.getInstance()
        }
    }
}


