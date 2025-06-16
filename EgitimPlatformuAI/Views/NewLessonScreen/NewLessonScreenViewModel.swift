//
//  NewLessonScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 12.06.2025.
//

import Foundation
import SwiftOpenAI

class NewLessonScreenViewModel {
    var coordinator: NewLessonScreenCoordinator?
    var courseClasses: [CourseClass]

    init(coordinator: NewLessonScreenCoordinator?, courseClasses: [CourseClass]) {
        self.coordinator = coordinator
        self.courseClasses = courseClasses
    }
    
    func addLesson(classId: String, content: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let request = AddLessonRequest(classId: classId, content: content)
        NetworkManager.shared.postAddLesson(body: request, completion: completion)
    }

}
