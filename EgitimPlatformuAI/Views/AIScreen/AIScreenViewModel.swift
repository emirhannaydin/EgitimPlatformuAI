//
//  AIScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 21.03.2025.
//

import Foundation
import SwiftOpenAI

final class AIScreenViewModel {
    var coordinator: AIScreenCoordinator?
    private var aiAPIManager = AIAPIManager.shared

    var messages: [MessageChatGPT] {
        aiAPIManager.messages
    }
    
    init(coordinator: AIScreenCoordinator?) {
        self.coordinator = coordinator
    }

    func sendMessage(_ message: String) {
        Task {
            await aiAPIManager.send(message: message)
        }
    }
}




