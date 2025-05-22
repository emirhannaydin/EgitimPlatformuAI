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

    init(coordinator: WritingScreenCoordinator?) {
        self.coordinator = coordinator
    }

    func sendMessage(_ message: String) {
        Task {
            aiAPIManager.isStream = false
            await aiAPIManager.send(message: message, appendToMessages: false)
        }
    }

}
