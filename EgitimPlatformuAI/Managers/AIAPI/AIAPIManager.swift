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
                    model: .gpt4(.base),
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
    
    func transcribeWhisperManually(audioURL: URL, expectedText: String) async -> (transcribedText: String, accuracy: Double)? {
        let apiKey = Config.openAIKey
        let endpoint = URL(string: "https://api.openai.com/v1/audio/transcriptions")!

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        data.append("--\(boundary)\r\n")
        data.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n")
        data.append("whisper-1\r\n")

        data.append("--\(boundary)\r\n")
        data.append("Content-Disposition: form-data; name=\"language\"\r\n\r\n")
        data.append("tr\r\n")

        let filename = "audio.m4a"
        let audioData = try! Data(contentsOf: audioURL)
        data.append("--\(boundary)\r\n")
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        data.append("Content-Type: audio/m4a\r\n\r\n")
        data.append(audioData)
        data.append("\r\n")

        data.append("--\(boundary)--\r\n")

        request.httpBody = data

        do {
            let (responseData, _) = try await URLSession.shared.data(for: request)
            let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
            let transcribed = (json?["text"] as? String ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            let accuracy = calculateSimilarity(between: transcribed, and: expectedText)
            return (transcribed, accuracy)
        } catch {
            print("Whisper manual API hatası: \(error.localizedDescription)")
            return nil
        }
    }


}

extension Notification.Name {
    static let aiMessageUpdated = Notification.Name("AIMessageUpdated")
    static let aiMessageFinished = Notification.Name("AIMessageFinished")

}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

private func calculateSimilarity(between str1: String, and str2: String) -> Double {
    let distance = levenshtein(str1.lowercased(), str2.lowercased())
    let maxLen = max(str1.count, str2.count)
    return maxLen == 0 ? 1.0 : 1.0 - Double(distance) / Double(maxLen)
}

private func levenshtein(_ a: String, _ b: String) -> Int {
    let a = Array(a)
    let b = Array(b)
    var dist = [[Int]](repeating: [Int](repeating: 0, count: b.count + 1), count: a.count + 1)

    for i in 0...a.count { dist[i][0] = i }
    for j in 0...b.count { dist[0][j] = j }

    for i in 1...a.count {
        for j in 1...b.count {
            if a[i - 1] == b[j - 1] {
                dist[i][j] = dist[i - 1][j - 1]
            } else {
                dist[i][j] = min(
                    dist[i - 1][j - 1] + 1,
                    min(dist[i][j - 1] + 1, dist[i - 1][j] + 1)
                )
            }
        }
    }
    return dist[a.count][b.count]
}





