//
//  TeacherScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 3.06.2025.
//

class TeacherScreenViewModel{
    var coordinator: TeacherScreenCoordinator?
    var courses: [Course] = []
    
    init(coordinator: TeacherScreenCoordinator?) {
        self.coordinator = coordinator
    }
    
    func getCourses(completion: @escaping (Result<[Course], Error>) -> Void) {
        NetworkManager.shared.getCourses { result in
            switch result {
            case .success(let courses):
                self.courses = courses
                completion(.success(courses))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
