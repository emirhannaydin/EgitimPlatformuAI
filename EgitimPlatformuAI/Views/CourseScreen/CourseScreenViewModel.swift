//
//  ListeningFirstScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.05.2025.
//

import Foundation

struct TestSection {
    let level: Int
    let title: String
    let tests: [Lesson]
}

class CourseScreenViewModel {
    var coordinator: CourseScreenCoordinator?
    var courseClasses: [CourseClass] = []
    let courseType: CourseType
    let courseLevelName: String
    
   
    init(coordinator: CourseScreenCoordinator?,
         courseType: CourseType,
         courseLevelName: String, courseClasses: [CourseClass]) {
        self.coordinator = coordinator
        self.courseType = courseType
        self.courseLevelName = courseLevelName
        self.courseClasses = courseClasses
    }
    
    var sections: [TestSection] {
        let sortedClasses = courseClasses.sorted(by: { $0.level < $1.level })

        return sortedClasses.map { courseClass in
            let title = Self.levelText(for: courseClass.level)
            return TestSection(level: courseClass.level, title: title, tests: courseClass.lessons)
        }
    }

    private static func levelText(for level: Int) -> String {
        switch level {
        case 0: return "A1"
        case 1: return "A2"
        case 2: return "B1"
        case 3: return "B2"
        case 4: return "C1"
        case 5: return "C2"
        default: return "Unknown"
        }
    }

    
}
