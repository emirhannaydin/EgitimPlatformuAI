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
    
    var sections: [TestSection] = []
    
    init(coordinator: CourseScreenCoordinator?,
         courseType: CourseType,
         courseLevelName: String,
         courseClasses: [CourseClass]) {
        self.coordinator = coordinator
        self.courseType = courseType
        self.courseLevelName = courseLevelName
        self.courseClasses = courseClasses
        
        self.sections = Self.convertToSections(classes: courseClasses)
    }
    
    func loadCourseLessons(studentId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let matchingCourse = courseClasses.first(where: {
            $0.name.lowercased().contains(courseType.rawValue)
        }) else {
            completion(.failure(NSError(domain: "Course ID not found", code: 0)))
            return
        }

        let courseId = matchingCourse.courseId

        NetworkManager.shared.fetchCourseLessons(for: studentId, for: courseId ?? "") { [weak self] result in
            switch result {
            case .success(let classes):
                self?.courseClasses = classes
                self?.sections = Self.convertToSections(classes: classes)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private static func convertToSections(classes: [CourseClass]) -> [TestSection] {
        let sortedClasses = classes.sorted(by: { $0.level < $1.level })
        return sortedClasses.map { courseClass in
            let title = levelText(for: courseClass.level)
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

