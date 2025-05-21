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
    
    func startSpeaking(text: String){
        Task{
            await AIAPIManager.shared.openAISpeak(text: text)
            AIAPIManager.shared.openAIStartPlayback()

        }
    }
    
    func stopSpeaking(){
        AIAPIManager.shared.openAIStopPlayback()
    }

    
}
