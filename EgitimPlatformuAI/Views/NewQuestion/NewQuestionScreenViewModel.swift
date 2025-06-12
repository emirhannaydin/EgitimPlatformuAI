//
//  NewQuestionScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 12.06.2025.
//

import Foundation
import SwiftOpenAI

class NewQuestionScreenViewModel {
    var coordinator: NewQuestionScreenCoordinator?
    var selectedLessonId: String!

    init(coordinator: NewQuestionScreenCoordinator?, selectedLessonId: String!) {
        self.coordinator = coordinator
        self.selectedLessonId = selectedLessonId
    }

    
}
