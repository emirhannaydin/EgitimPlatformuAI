//
//  NetworkManager.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 27.04.2025.
//

import UIKit
class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    private var baseUrl = "http://localhost:5001/api/"
    
    func registerUser(request: Register, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        let endPoint = "Account/signup"
        
        guard let url = URL(string: "\(baseUrl)\(endPoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(request)
            urlRequest.httpBody = jsonData

            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Giden JSON: \(jsonString)")
            }
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "No response", code: 0)))
                return
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                    let backendError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(backendError))
                } else {
                    completion(.failure(NSError(domain: "Invalid response", code: httpResponse.statusCode)))
                }
                return
            }

            completion(.success(true))

        }.resume()
    }

    
    func loginUser(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        
        let endPoint = "Account/login"
        guard let url = URL(string: "\(baseUrl)\(endPoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let loginBody: [String: Any] = [
            "eMail": email,
            "password": password
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: loginBody)
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "No response", code: 0)))
                return
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                    let backendError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(backendError))
                } else {
                    completion(.failure(NSError(domain: "Invalid response", code: httpResponse.statusCode)))
                }
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }

            do {
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                completion(.success(loginResponse))
            } catch {
                completion(.failure(error))
            }

        }.resume()
    }
    
    func getCourses(completion: @escaping (Result<[Course], Error>) -> Void) {
        let endPoint = "Course"
        guard let url = URL(string: "\(baseUrl)\(endPoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "No response", code: 0)))
                return
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                    let backendError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(backendError))
                } else {
                    completion(.failure(NSError(domain: "Invalid response", code: httpResponse.statusCode)))
                }
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }

            do {
                let courses = try JSONDecoder().decode([Course].self, from: data)
                completion(.success(courses))
            } catch {
                completion(.failure(error))
            }

        }.resume()
    }
    
    func submitCourseSelections(request: CourseRegisterRequest, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endPoint = "Student/AllCourseRegister"
        
        guard let url = URL(string: "\(baseUrl)\(endPoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(request)
            urlRequest.httpBody = jsonData

            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Giden JSON: \(jsonString)")
            }
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "No response", code: 0)))
                return
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                    let backendError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(backendError))
                } else {
                    completion(.failure(NSError(domain: "Invalid response", code: httpResponse.statusCode)))
                }
                return
            }

            completion(.success(true))
        }.resume()
    }
    
    
    func fetchCourseClasses(for studentId: String, completion: @escaping (Result<[CourseClass], Error>) -> Void) {
        let endpoint = "Account/GetStudentInfo/\(studentId)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Invalid response", code: 0)))
                return
            }

            do {
                let classes = try JSONDecoder().decode([CourseClass].self, from: data)
                completion(.success(classes))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchTeacherClasses(for studentId: String, completion: @escaping (Result<[CourseClass], Error>) -> Void) {
        let endpoint = "Teacher/GetTeacherClasses/\(studentId)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Invalid response", code: 0)))
                return
            }

            do {
                let classes = try JSONDecoder().decode([CourseClass].self, from: data)
                completion(.success(classes))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchCourseLessons(for studentId: String, for courseId: String, completion: @escaping (Result<[CourseClass], Error>) -> Void) {
        let endpoint = "Class/\(courseId)/\(studentId)/classes"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Invalid response", code: 0)))
                return
            }

            do {
                let classes = try JSONDecoder().decode([CourseClass].self, from: data)
                completion(.success(classes))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchLessonsData(for lessonId: String, completion: @escaping (Result<[Lessons], Error>) -> Void){
        let endpoint = "Lesson/GetLessonQuestions/\(lessonId)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Invalid response", code: 0)))
                return
            }
            
            do {
                print("Raw data string: \(String(data: data ?? Data(), encoding: .utf8) ?? "nil")")
                let classes = try JSONDecoder().decode([Lessons].self, from: data)
                completion(.success(classes))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchStudent(by studentId: String, completion: @escaping (Result<Student, Error>) -> Void) {
        let endpoint = "Student/\(studentId)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Invalid response", code: 0)))
                return
            }

            do {
                let student = try JSONDecoder().decode(Student.self, from: data)
                completion(.success(student))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchImage(from imageName: String, completion: @escaping (Result<Data, Error>) -> Void) {
            let baseURL = "http://localhost:5001/profilePictures/"
            guard let url = URL(string: baseURL + imageName) else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0)))
                return
            }

            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    completion(.success(data))
                } else {
                    completion(.failure(NSError(domain: "No data", code: 0)))
                }
            }

            task.resume()
        }


}




