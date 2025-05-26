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

    var messages: [MessageChatGPT] {
        aiAPIManager.messages
    }
    init(coordinator: ListeningScreenCoordinator?) {
        self.coordinator = coordinator
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
}
