//
//  ListeningFirstScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.05.2025.
//

import Foundation

class CourseScreenViewModel {
    var coordinator: CourseScreenCoordinator?
    var courseType: CourseType

    init(coordinator: CourseScreenCoordinator?, courseType: CourseType) {
        self.coordinator = coordinator
        self.courseType = courseType
    }
    
    var courseName: String{
        courseType.courseName
    }
    
    var courseLevelName: String{
        courseType.courseLevelName
    }
    
    
    
    
}
