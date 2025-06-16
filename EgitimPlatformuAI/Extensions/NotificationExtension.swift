//
//  NotificationExtension.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 16.06.2025.
//
import Foundation

extension Notification.Name {
    static let aiMessageUpdated = Notification.Name("AIMessageUpdated")
    static let aiMessageFinished = Notification.Name("AIMessageFinished")
    static let aiSpeechFinished = Notification.Name("AISpeechFinished")
    static let aiSpeechDidStart = Notification.Name("AISpeechDidStart")
    static let questionScreenDismissed = Notification.Name("questionScreenDismissed")

}
