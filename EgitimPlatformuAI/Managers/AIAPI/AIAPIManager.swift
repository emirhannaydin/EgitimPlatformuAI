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
    var isStream = Bool()
    
    @MainActor
    func send(message: String, appendToMessages: Bool = true) async {
        let userMessage = MessageChatGPT(text: message, role: .user)
        
        if appendToMessages {
            messages.append(userMessage)
            currentMessage = MessageChatGPT(text: "AI: ", role: .assistant)
            messages.append(currentMessage)
        } else {
            currentMessage = MessageChatGPT(text: "", role: .assistant)
        }

        let optionalParameters = ChatCompletionsOptionalParameters(
            temperature: 0.3,
            stream: isStream,
            maxTokens: 2000
        )

        let messageList = appendToMessages ? messages : [userMessage]

        if isStream {
            do {
                for try await newMessage in try await openAI.createChatCompletionsStream(
                    model: .gpt3_5(.turbo),
                    messages: messageList,
                    optionalParameters: optionalParameters
                ) {
                    onReceiveStream(newMessage: newMessage, appendToMessages: appendToMessages)
                }
            } catch {
                print("Error generating Chat Completion with STREAM: \(error.localizedDescription)")
            }
        } else {
            do {
                let chatCompletions = try await openAI.createChatCompletions(
                    model: .gpt3_5(.turbo),
                    messages: messageList,
                    optionalParameters: optionalParameters
                )
                chatCompletions.map {
                    onReceive(newMessage: $0, appendToMessages: appendToMessages)
                }
            } catch {
                print("Error generating Chat Completion: \(error.localizedDescription)")
            }
        }
    }



    
    @MainActor
    private func onReceiveStream(newMessage: ChatCompletionsStreamDataModel, appendToMessages: Bool) {
        if let finishReason = newMessage.choices.first?.finishReason, finishReason == "stop" {
            NotificationCenter.default.post(name: .aiMessageFinished, object: nil)
            return
        }

        guard let content = newMessage.choices.first?.delta?.content, !content.isEmpty else {
            return
        }

        currentMessage.text.append(content)

        if appendToMessages, let lastIndex = messages.indices.last {
            messages[lastIndex].text = currentMessage.text
            NotificationCenter.default.post(name: .aiMessageUpdated, object: nil)
        }
    }




    
    @MainActor
    private func onReceive(newMessage: ChatCompletionsDataModel, appendToMessages: Bool) {
        guard let lastMessage = newMessage.choices.first else { return }

        currentMessage.text.append(lastMessage.message.content)

        if appendToMessages, let lastIndex = messages.indices.last {
            messages[lastIndex].text = currentMessage.text
            NotificationCenter.default.post(name: .aiMessageUpdated, object: nil)
        }

        NotificationCenter.default.post(name: .aiMessageFinished, object: nil)
    }


}

extension Notification.Name {
    static let aiMessageUpdated = Notification.Name("AIMessageUpdated")
    static let aiMessageFinished = Notification.Name("AIMessageFinished")

}



