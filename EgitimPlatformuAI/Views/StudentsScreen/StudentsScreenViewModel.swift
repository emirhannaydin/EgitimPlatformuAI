//
//  StudentsScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 16.06.2025.
//

import Foundation

class StudentsScreenViewModel {
    var coordinator: StudentsScreenCoordinator?
    var students: [Student] = []
    
    init(coordinator: StudentsScreenCoordinator?) {
        self.coordinator = coordinator
    }
    
    func getStudents(completion: @escaping (Result<[Student], Error>) -> Void) {
        NetworkManager.shared.fetchStudents { result in
            switch result {
            case .success(let students):
                self.students = students
                completion(.success(students))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchProfileImage(for student: Student, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageName = student.profilePicture else {
            completion(.failure(NSError(domain: "Profile picture not found", code: 0)))
            return
        }

        NetworkManager.shared.fetchImage(from: imageName) { result in
            completion(result)
        }
    }

}
