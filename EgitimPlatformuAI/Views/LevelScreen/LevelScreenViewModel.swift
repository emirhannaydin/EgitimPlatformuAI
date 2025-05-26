//
//  LevelScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 24.05.2025.
//

import Foundation
class LevelScreenViewModel {

    var coordinator: LevelScreenCoordinator?
    var courses: [Course] = []

    init(coordinator: LevelScreenCoordinator?) {
        self.coordinator = coordinator
    }

    func getCourses(completion: @escaping (Result<[Course], Error>) -> Void) {
        NetworkManager.shared.getCourses { result in
            switch result {
            case .success(let courses):
                self.courses = courses
                print("Gelen kurslar:", courses)
                completion(.success(courses))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
