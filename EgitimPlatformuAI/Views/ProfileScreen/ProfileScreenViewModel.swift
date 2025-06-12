//
//  ProfileScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 16.01.2025.
//

import Foundation
class ProfileScreenViewModel {
    
    var coordinator: ProfileScreenCoordinator?
    var student: Student?
    var courseClasses: [CourseClass] = []
    
    init(coordinator: ProfileScreenCoordinator?, courseClasses: [CourseClass]) {
        self.coordinator = coordinator
    }
    
    
    func loadStudent(studentId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.fetchStudent(by: studentId) { [weak self] result in
            switch result {
            case .success(let student):
                self?.student = student
                print(result)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func loadCourseClasses(studentId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.fetchCourseClasses(for: studentId) { [weak self] result in
            switch result {
            case .success(let classes):
                self?.courseClasses = classes
                print(result)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchProfileImage(completion: @escaping (Result<Data, Error>) -> Void) {
            guard let imageName = student?.profilePicture else {
                completion(.failure(NSError(domain: "No image name", code: 0)))
                return
            }

            NetworkManager.shared.fetchImage(from: imageName) { result in
                completion(result)
            }
        }

}
