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
    var isExpanded: Bool = true
}

class CourseScreenViewModel {
    var coordinator: CourseScreenCoordinator?
    var courseClasses: [CourseClass] = []
    var courseId: String
    var sections: [TestSection] = []
    var courseLevelName: String
    
    init(coordinator: CourseScreenCoordinator?,
         courseLevelName: String,
         courseId: String) {
        self.coordinator = coordinator
        self.courseId = courseId
        self.courseLevelName = courseLevelName
        self.sections = self.convertToSections(classes: courseClasses)
    }
    
    func loadCourseLessons(studentId: String, completion: @escaping (Result<Void, Error>) -> Void) {

        NetworkManager.shared.fetchCourseLessons(for: studentId, for: courseId) { [weak self] result in
            switch result {
            case .success(let classes):
                self?.courseClasses = classes
                if let section = self?.convertToSections(classes: classes){
                    self?.sections = section

                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func convertToSections(classes: [CourseClass]) -> [TestSection] {
        let sortedClasses = classes.sorted(by: { $0.level < $1.level })
        
        return sortedClasses.map { courseClass in
            let sortedLessons = courseClass.lessons.sorted {
                $0.order < $1.order
            }
            let title = levelTextForInt(for: courseClass.level)
            
            let allLessonsCompleted = sortedLessons.allSatisfy { $0.isCompleted == true }

            return TestSection(
                level: courseClass.level,
                title: title,
                tests: sortedLessons,
                isExpanded: !allLessonsCompleted
            )
        }
    }



    func levelTextForInt(for level: Int) -> String {
        switch level {
        case 0: return "A1"
        case 1: return "A2"
        case 2: return "B1"
        case 3: return "B2"
        case 4: return "C1"
        case 5: return "C2"

        default: return " - "
        }
    }
    //burası düzeltilecek
    func levelTextForString(for level: String) -> String {
        
        switch level {
        case "0": return "A1"
        case "1": return "A2"
        case "2": return "B1"
        case "3": return "B2"
        case "4": return "C1"
        case "5": return "C2"

        default: return " - "
        }
    }
}

