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
    var selectedCourseName: String

    init(coordinator: NewQuestionScreenCoordinator?, selectedLessonId: String!, selecteCourseName: String) {
        self.coordinator = coordinator
        self.selectedLessonId = selectedLessonId
        self.selectedCourseName = selecteCourseName
    }

    
}
