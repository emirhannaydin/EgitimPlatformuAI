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
    var courseId: String!

    init(coordinator: NewLessonScreenCoordinator?, courseId: String!) {
        self.coordinator = coordinator
        self.courseId = courseId
    }
}
