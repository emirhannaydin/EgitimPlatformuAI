import Foundation
import SwiftOpenAI

class ReadingScreenViewModel {
    var coordinator: ReadingScreenCoordinator?
    private var aiAPIManager = AIAPIManager.shared
    var messages: [MessageChatGPT] {
        aiAPIManager.messages
    }

    let lessonId: String?
    init(coordinator: ReadingScreenCoordinator?, lessonId: String? = nil) {
        self.coordinator = coordinator
        self.lessonId = lessonId
    }

    func sendMessage(_ message: String) {
        Task {
            aiAPIManager.isStream = false
            await aiAPIManager.send(message: message, appendToMessages: false)
        }
    }
}
