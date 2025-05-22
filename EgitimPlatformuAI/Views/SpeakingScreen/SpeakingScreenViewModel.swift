//
//  SpeakingScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 28.04.2025.
//

import Foundation

class SpeakingScreenViewModel {
    var coordinator: SpeakingScreenCoordinator?

    init(coordinator: SpeakingScreenCoordinator?) {
        self.coordinator = coordinator
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

    
}
