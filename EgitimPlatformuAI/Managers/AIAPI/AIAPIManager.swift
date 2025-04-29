//
//  AIAPIManager.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 22.03.2025.
//

import SwiftOpenAI
import Foundation

final class AIAPIManager {
    static let shared = AIAPIManager()

    struct Config {
        static var openAIKey: String {
            guard let filePath = Bundle.main.path(forResource: "Config", ofType: "plist"),
                  let plist = NSDictionary(contentsOfFile: filePath),
                  let value = plist.object(forKey: "OpenAI_API_Key") as? String else {
                fatalError("Couldn't find OpenAI_API_Key in Config.plist.")
            }
            return value
        }
    }
    
    var openAI = SwiftOpenAI(apiKey: Config.openAIKey)
    
    var messages: [MessageChatGPT] = [
        .init(text: "I am an AI and I am here to help you.", role: .system)
    ]
    
    var currentMessage: MessageChatGPT = .init(text: "", role: .assistant)
    var isStream: Bool = true
    
    @MainActor
    func send(message: String) async {
        let userMessage = MessageChatGPT(text: message, role: .user)
        messages.append(userMessage)
        
        NotificationCenter.default.post(name: .aiMessageUpdated, object: nil)
        
        currentMessage = MessageChatGPT(text: "AI: ", role: .assistant)
        messages.append(currentMessage)
        
        let optionalParameters = ChatCompletionsOptionalParameters(
            temperature: 0.5,
            stream: isStream,
            maxTokens: 2000
        )
        
        if isStream {
            do {
                for try await newMessage in try await openAI.createChatCompletionsStream(model: .gpt4o(.base), messages: messages, optionalParameters: optionalParameters) {
                    onReceiveStream(newMessage: newMessage)
                }
            } catch {
                print("Error generating Chat Completion with STREAM: \(error.localizedDescription)")
            }
        } else {
            do {
                let chatCompletions = try await openAI.createChatCompletions(
                    model: .gpt4(.base),
                    messages: messages,
                    optionalParameters: optionalParameters
                )
                chatCompletions.map { onReceive(newMessage: $0) }
            } catch {
                print("Error generating Chat Completion: \(error.localizedDescription)")
            }
        }
    }

    
    @MainActor
    private func onReceiveStream(newMessage: ChatCompletionsStreamDataModel) {
        guard let lastMessage = newMessage.choices.first,
              lastMessage.finishReason == nil,
              let content = lastMessage.delta?.content,
              !content.isEmpty else { return }
        
        currentMessage.text.append(content)
        if let lastIndex = messages.indices.last {
            messages[lastIndex].text = currentMessage.text
        }
        
        NotificationCenter.default.post(name: .aiMessageUpdated, object: nil)
    }
    
    @MainActor
    private func onReceive(newMessage: ChatCompletionsDataModel) {
        guard let lastMessage = newMessage.choices.first else { return }
        
        currentMessage.text.append(lastMessage.message.content)
        if let lastIndex = messages.indices.last {
            messages[lastIndex].text = currentMessage.text
        }
        
        NotificationCenter.default.post(name: .aiMessageUpdated, object: nil)
    }
}

extension Notification.Name {
    static let aiMessageUpdated = Notification.Name("AIMessageUpdated")
}



