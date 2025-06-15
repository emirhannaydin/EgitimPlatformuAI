//
//  SpeakingScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 28.04.2025.
//

import Foundation

class SpeakingScreenViewModel {
    var coordinator: SpeakingScreenCoordinator?
    var questions: [Lessons] = []

    let lessonId: String?
    init(coordinator: SpeakingScreenCoordinator?, lessonId: String? = nil) {
        self.coordinator = coordinator
        self.lessonId = lessonId
    }
    
    func startAISpeaking(text: String){
        Task{
            await AIAPIManager.shared.openAISpeak(text: text)
            AIAPIManager.shared.openAIStartPlayback()

        }
    }
    
    func stopAISpeaking(){
        AIAPIManager.shared.openAIStopPlayback()
    }
    
    var expectedText: String = ""

    func startRecording() {
        do {
            try AudioRecorderManager.shared.startRecording()
        } catch {
            print("🎤 Kayıt başlatılamadı:", error.localizedDescription)
        }
    }

    func stopRecordingAndEvaluate(completion: @escaping (String, Double) -> Void) {
        AudioRecorderManager.shared.stopRecording()

        guard let url = AudioRecorderManager.shared.getAudioFileURL() else {
            completion("❌ Kayıt bulunamadı", 0)
            return
        }

        Task {
            if let result = await AIAPIManager.shared.transcribeWhisperManually(audioURL: url, expectedText: expectedText) {
                completion(result.transcribedText, result.accuracy)
            } else {
                completion("❌ Transkripsiyon başarısız", 0)
            }
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
