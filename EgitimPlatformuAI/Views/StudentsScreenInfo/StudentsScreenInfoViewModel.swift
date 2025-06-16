//
//  StudentsScreenInfoViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 16.06.2025.
//

import Foundation

class StudentsScreenInfoViewModel {
    var coordinator: StudentsScreenInfoCoordinator?
    var student: Student?
    var courseClasses: [CourseClass] = []
    var studentId: String?
    init(coordinator: StudentsScreenInfoCoordinator?, studentId: String?) {
        self.coordinator = coordinator
        self.studentId = studentId
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
}
