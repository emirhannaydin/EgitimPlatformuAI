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

    func sendMessage(_ prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let fakeResponse = """
            No. You translated it as "Ben okula gittim", but the correct translation is "I went to school." Keep it up! You're doing great — just a little more attention to verb tense.
            """
            completion(.success(fakeResponse))
        }
    }

}
