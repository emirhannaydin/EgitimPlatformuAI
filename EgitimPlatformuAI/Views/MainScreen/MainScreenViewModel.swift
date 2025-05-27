//
//  MainScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 16.01.2025.
//

import Foundation
class MainScreenViewModel {

    var coordinator: MainScreenCoordinator?
    var courseClasses: [CourseClass] = []

    init(coordinator: MainScreenCoordinator?, courseClasses: [CourseClass]) {
        self.coordinator = coordinator
        self.courseClasses = courseClasses
    }
    

        func loadCourseClasses(studentId: String, completion: @escaping (Result<Void, Error>) -> Void) {
            NetworkManager.shared.fetchCourseClasses(for: studentId) { [weak self] result in
                switch result {
                case .success(let classes):
                    self?.courseClasses = classes
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
}
