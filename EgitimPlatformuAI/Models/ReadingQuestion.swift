//
//  ReadingQuestion.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 13.05.2025.
//

struct ReadingQuestion {
    let passage: String       // Metin
    let question: String      // Soru
    let answers: [String]     // 4 şık
    let correctAnswerIndex: Int // Doğru şıkkın index'i (0-3)
}
