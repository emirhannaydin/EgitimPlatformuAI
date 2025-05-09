import Foundation
import SwiftOpenAI

class ReadingScreenViewModel {
    var coordinator: ReadingScreenCoordinator?
    private var aiAPIManager = AIAPIManager.shared
    var messages: [MessageChatGPT] {
        aiAPIManager.messages
    }

    init(coordinator: ReadingScreenCoordinator?) {
        self.coordinator = coordinator
    }

    func sendMessage(_ message: String) {
        Task {
            aiAPIManager.isStream = false
            await aiAPIManager.send(message: message, appendToMessages: false)
        }
    }
}
