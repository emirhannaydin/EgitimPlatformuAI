//
//  AddQuestionModel.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 15.06.2025.
//



struct LessonQuestionRequest: Codable {
    let id: String
    let questionString: String
    let answerOne: String?
    let answerTwo: String?
    let answerThree: String?
    let answerFour: String?
    let correctAnswer: String
    let listeningSentence: String
}
