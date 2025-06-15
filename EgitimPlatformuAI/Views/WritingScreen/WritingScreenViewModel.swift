//
//  WritingScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 28.04.2025.
//

import Foundation
import SwiftOpenAI

class WritingScreenViewModel {
    var coordinator: WritingScreenCoordinator?

    private var aiAPIManager = AIAPIManager.shared
    var messages: [MessageChatGPT] {
        aiAPIManager.messages
    }
    var questions: [Lessons] = []

    let lessonId: String?
    init(coordinator: WritingScreenCoordinator?, lessonId: String? = nil) {
        self.coordinator = coordinator
        self.lessonId = lessonId
    }

    func sendMessage(_ message: String) {
        Task {
            aiAPIManager.isStream = false
            await aiAPIManager.send(message: message, appendToMessages: false)
        }
    }

    func loadLessonData(lessonId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.fetchLessonsData(for: lessonId ) { [weak self]
            result in
            switch result {
            case .success(let lessons):
                print(lessons)
                self?.questions = lessons
                completion(.success(()))
                
            case .failure(let error):
            print("Error: \(error)")
            completion(.failure(error))
            }
        }
    }
    
    func completeLesson(studentId: String, lessonId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        NetworkManager.shared.completeLesson(studentId: studentId, lessonId: lessonId) { result in
            switch result {
            case .success(let isCompleted):
                if isCompleted {
                    print("Ders başarıyla tamamlandı.")
                } else {
                    print("Ders tamamlanamadı.")
                }
                completion(.success(isCompleted))
            case .failure(let error):
                print("❌ Hata oluştu: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

}
