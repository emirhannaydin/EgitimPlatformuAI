//
//  AIAPIManager.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 22.03.2025.
//

import SwiftOpenAI
import Foundation
import AVFoundation

final class AIAPIManager: NSObject {
    static let shared = AIAPIManager()

    var openAIAudioPlayer: AVAudioPlayer?
    var shouldPlayAudio = true

    
    
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
                    model: .gpt4(.base),
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
    
    @MainActor
    func openAISpeak(text: String, voice: OpenAIVoiceType = .nova) async {
        shouldPlayAudio = true
        do {
            let data = try await openAI.createSpeech(
                model: .tts(.tts1),
                input: text,
                voice: voice,
                responseFormat: .mp3,
                speed: 1.0
            )

            let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("speech.mp3")

            if FileManager.default.fileExists(atPath: fileURL.path) {
                try FileManager.default.removeItem(at: fileURL)
            }

            try data!.write(to: fileURL)
            NotificationCenter.default.post(name: .aiSpeechDidStart, object: nil)
            openAIAudioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            openAIAudioPlayer?.delegate = self
            
        } catch {
            print("TTS Hatası: \(error.localizedDescription)")
        }
    }

    func openAIStartPlayback() {
        guard shouldPlayAudio else { return }
        openAIAudioPlayer?.play()
    }

    func openAIStopPlayback() {
        shouldPlayAudio = false
        openAIAudioPlayer?.stop()
        openAIAudioPlayer?.currentTime = 0
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
        guard let audioData = try? Data(contentsOf: audioURL) else {
            print("❌ Ses verisi okunamadı")
            return nil
        }
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
    
    
    private func calculateSimilarity(between str1: String, and str2: String) -> Double {
        let norm1 = normalize(str1)
        let norm2 = normalize(str2)

        let distance = levenshtein(norm1, norm2)
        let maxLen = max(norm1.count, norm2.count)
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

    private func normalize(_ str: String) -> String {
        return str
            .lowercased()
            .folding(options: .diacriticInsensitive, locale: .current)
            .components(separatedBy: .punctuationCharacters).joined()
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\t", with: " ")
            .replacingOccurrences(of: "  ", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

}

extension AIAPIManager: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        NotificationCenter.default.post(name: .aiSpeechFinished, object: nil)
        
    }

}


extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

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









