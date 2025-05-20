//
//  ListeningWord.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.05.2025.
//

struct ListeningWord: Decodable {
    let question: String
    let hearingSound: String
    let options: [String]
    let correctAnswer: String
    let level: String
}
