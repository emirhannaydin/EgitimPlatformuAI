//
//  TeacherScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 3.06.2025.
//

class TeacherScreenViewModel{
    var coordinator: TeacherScreenCoordinator?
    var courseClasses: [CourseClass] = []
    
    init(coordinator: TeacherScreenCoordinator?) {
        self.coordinator = coordinator
    }
    
    func loadCourseClasses(teacherId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.fetchCourseClasses(for: teacherId) { [weak self] result in
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
