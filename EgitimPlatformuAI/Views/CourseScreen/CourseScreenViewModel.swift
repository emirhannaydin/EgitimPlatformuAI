//
//  ListeningFirstScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.05.2025.
//

import Foundation

class CourseScreenViewModel {
    var coordinator: CourseScreenCoordinator?
    var courseClasses: [CourseClass] = []
    let courseType: CourseType
    let courseLevelName: String
    init(coordinator: CourseScreenCoordinator?,
         courseType: CourseType,
         courseLevelName: String, courseClasses: [CourseClass]) {
        self.coordinator = coordinator
        self.courseType = courseType
        self.courseLevelName = courseLevelName
        self.courseClasses = courseClasses
    }
    
}
