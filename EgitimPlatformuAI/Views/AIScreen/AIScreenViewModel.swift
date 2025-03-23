//
//  AIScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 21.03.2025.
//

import Foundation
import SwiftOpenAI

class AIScreenViewModel {
    var coordinator: AIScreenCoordinator?
    private var aiAPIManager = AIAPIManager()
    private(set) var messages: [MessageChatGPT] = []
    
    init(coordinator: AIScreenCoordinator?) {
        self.coordinator = coordinator
        self.messages = aiAPIManager.messages
    }

    func sendMessage(_ message: String, completion: @escaping () -> Void) {
        messages.append(MessageChatGPT(text: message, role: .user))
        messages.append(MessageChatGPT(text: "", role: .system)) // Boş mesaj
        completion()
        NotificationCenter.default.post(name: Notification.Name("AIMessageStarted"), object: nil)

        Task {
            await aiAPIManager.send(message: message)
            
            if let lastIndex = messages.lastIndex(where: { $0.text == "" && $0.role == .system }) {
                let aiMessage = aiAPIManager.messages.last ?? MessageChatGPT(text: "Error", role: .system)
                messages[lastIndex] = aiMessage

                if !aiMessage.text.isEmpty {
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: Notification.Name("AIMessageCompleted"), object: nil)
                        completion() 
                    }
                } else {
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: Notification.Name("AIMessageCompleted"), object: nil)
                        completion()
                    }
                }
            }
        }
    }


}


