//
//  ListeningFirstScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.05.2025.
//

import Foundation

class AddQuestionScreenViewModel {
    var coordinator: AddQuestionScreenCoordinator?
    var courseClasses: [CourseClass] = []
    var courseId: String
    var sections: [TestSection] = []
    var questions: [Lessons] = []
    var courseLevelName: String
    var allClassIds: [String] {
        return courseClasses.map { $0.id }
    }
    
    init(coordinator: AddQuestionScreenCoordinator?,
         courseLevelName: String,
         courseId: String) {
        self.coordinator = coordinator
        self.courseId = courseId
        self.courseLevelName = courseLevelName
        self.sections = self.convertToSections(classes: courseClasses)
    }
    
    func loadCourseLessons(teacherId: String, completion: @escaping (Result<Void, Error>) -> Void) {

        NetworkManager.shared.fetchCourseLessonsForTeacher(for: teacherId, for: courseId) { [weak self] result in
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
            let sortedLessons = courseClass.lessons.sorted { $0.content.localizedCaseInsensitiveCompare($1.content) == .orderedAscending }
            let title = levelTextForInt(for: courseClass.level)
            return TestSection(level: courseClass.level, title: title, tests: sortedLessons)
        }
    }
    
    func deleteLesson(lessonId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        NetworkManager.shared.deleteLesson(lessonId: lessonId) { result in
            switch result {
            case .success(let isCompleted):
                completion(.success(isCompleted))
            case .failure(let error):
                completion(.failure(error))
            }
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
    
}

