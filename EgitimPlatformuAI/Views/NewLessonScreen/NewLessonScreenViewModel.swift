//
//  NewLessonScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 12.06.2025.
//

import Foundation
import SwiftOpenAI

class NewLessonScreenViewModel {
    var coordinator: NewLessonScreenCoordinator?
    var selectedLessonId: String!

    init(coordinator: NewLessonScreenCoordinator?, selectedLessonId: String!) {
        self.coordinator = coordinator
        self.selectedLessonId = selectedLessonId
    }
}
