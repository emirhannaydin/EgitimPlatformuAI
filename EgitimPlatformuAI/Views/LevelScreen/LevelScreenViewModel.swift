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
    private var selectedLevels: [CourseRegister] = []

    init(coordinator: LevelScreenCoordinator?) {
        self.coordinator = coordinator
    }

    // Kursları API'den çek
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

    // Seçilen kurs ve seviyeyi listeye ekle
    func addCourseSelection(courseId: String, level: Int) {
        let register = CourseRegister(courseId: courseId, level: level)
        selectedLevels.append(register)
        print(register)
    }

    // Seçilen tüm kurs ve seviyeleri API'ye gönder
    func submitSelections(studentId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let request = CourseRegisterRequest(studentId: studentId, courseRegisters: selectedLevels)
        print(request)
        NetworkManager.shared.submitCourseSelections(request: request, completion: completion)
    }
}

