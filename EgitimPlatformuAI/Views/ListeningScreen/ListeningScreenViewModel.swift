//
//  ListeningScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 28.04.2025.
//

import Foundation
import SwiftOpenAI

class ListeningScreenViewModel {
    var coordinator: ListeningScreenCoordinator?
    private var aiAPIManager = AIAPIManager.shared
    var questions: [Lessons] = []
    var courseClasses: [CourseClass] = []

    var messages: [MessageChatGPT] {
        aiAPIManager.messages
    }
    
    let lessonId: String?
    init(coordinator: ListeningScreenCoordinator?, lessonId: String? = nil) {
        self.coordinator = coordinator
        self.lessonId = lessonId
    }
    
    func startAIListening(text: String){
        Task{
            await AIAPIManager.shared.openAISpeak(text: text)
            AIAPIManager.shared.openAIStartPlayback()

        }
    }
    func stopAIListening(){
        AIAPIManager.shared.openAIStopPlayback()
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
                completion(.success(isCompleted))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
