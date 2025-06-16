//
//  NewQuestionScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 12.06.2025.
//

import Foundation
import SwiftOpenAI

class NewQuestionScreenViewModel {
    var coordinator: NewQuestionScreenCoordinator?
    var selectedLessonId: String!
    var selectedCourseName: String

    init(coordinator: NewQuestionScreenCoordinator?, selectedLessonId: String!, selecteCourseName: String) {
        self.coordinator = coordinator
        self.selectedLessonId = selectedLessonId
        self.selectedCourseName = selecteCourseName
    }

    func submitQuestions(_ questions: [LessonQuestionRequest], completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.addLessonQuestions(lessonId: selectedLessonId, questions: questions) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

}
