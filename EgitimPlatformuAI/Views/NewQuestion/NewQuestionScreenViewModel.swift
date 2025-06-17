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
    var questions: [Lessons] = []
    var isUpdate: Bool = false

    init(coordinator: NewQuestionScreenCoordinator?, selectedLessonId: String!, selecteCourseName: String, isUpdate: Bool) {
        self.coordinator = coordinator
        self.selectedLessonId = selectedLessonId
        self.selectedCourseName = selecteCourseName
        self.isUpdate = isUpdate
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
    
    func editQuestions(_ questions: LessonQuestionRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.editLessonQuestion(question: questions) { result in
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
    func loadLessonData(completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.fetchLessonsData(for: selectedLessonId ) { [weak self]
            result in
            switch result {
            case .success(let lessons):
                self?.questions = lessons
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
    
    func deleteQuestion(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.deleteLessonQuestion(with: id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let isSuccess):
                    if isSuccess {
                        completion(.success(()))
                    } else {
                        completion(.failure(NSError(domain: "Deletion failed", code: 0)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    
    

}
