//
//  ListeningFirstScreenCoordinator.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.05.2025.
//

import Foundation
import UIKit

final class CourseScreenCoordinator: Coordinator {
    private static var instance: CourseScreenCoordinator?
    static func getInstance() -> CourseScreenCoordinator {
        if instance == nil {
            instance = CourseScreenCoordinator()
        }
        return instance!
    }

    var navigationController = UINavigationController()

    private var courseType: CourseType = .reading
    private var courseLevelName: String = "A1" // default

    func setCourseType(_ type: CourseType) {
        self.courseType = type
    }
    
    func setCourseLevelName(_ name: String) {
        self.courseLevelName = name
    }

    func start() {
        let storyboard = UIStoryboard(name: "CourseScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "CourseScreen") as? CourseScreenViewController else {
            fatalError("Failed to instantiate CourseScreenViewController")
        }

        let viewModel = CourseScreenViewModel(
            coordinator: self,
            courseType: courseType,
            courseLevelName: courseLevelName
        )

        viewController.viewModel = viewModel

        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        }
    }
}


