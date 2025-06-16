//
//  Lessons.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 29.05.2025.
//

struct Lessons: Decodable{
    let id: String
    let questionString: String?
    let answerOne: String?
    let answerTwo: String?
    let answerThree: String?
    let answerFour: String?
    let correctAnswer: String?
    let listeningSentence: String
    
    var options: [String] {
        return [answerOne, answerTwo, answerThree, answerFour].compactMap { $0 }
    }

}
