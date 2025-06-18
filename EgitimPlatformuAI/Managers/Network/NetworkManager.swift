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
    var token: String!
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
                let tokenData = String(data: KeychainHelper.shared.read(service: "access-token", account: "user")!, encoding: .utf8)
                self.token = tokenData
            } catch {
                completion(.failure(error))
            }

        }.resume()
    }
    
    func verifyEmail(userId: String, code: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let endPoint = "Account/VerifyEmail"
        guard let url = URL(string: "\(baseUrl)\(endPoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "userId": userId,
            "code": code
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
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

            guard let data = data,
                  let message = String(data: data, encoding: .utf8) else {
                completion(.failure(NSError(domain: "Empty message", code: 0)))
                return
            }

            if (200..<300).contains(httpResponse.statusCode) {
                completion(.success(()))
            } else {
                let backendError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message])
                completion(.failure(backendError))
            }

        }.resume()
    }

    func forgotPasswordRequest(email: String, completion: @escaping (Result<String, Error>) -> Void) {
        let endPoint = "Account/ForgotPasswordMail"
        guard let url = URL(string: "\(baseUrl)\(endPoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "email": email
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
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

            guard let data = data,
                  let userIdString = String(data: data, encoding: .utf8) else {
                completion(.failure(NSError(domain: "No data or invalid encoding", code: 0)))
                return
            }

            if (200..<300).contains(httpResponse.statusCode) {
                completion(.success(userIdString))
            } else {
                let backendError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: userIdString])
                completion(.failure(backendError))
            }
        }.resume()
    }
    
    func forgotPasswordOTP(userId: String, otpCode: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        let endPoint = "Account/ForgotPasswordCodeCheck"
        guard let url = URL(string: "\(baseUrl)\(endPoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "userId": userId,
            "code": otpCode
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
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

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }

            if (200..<300).contains(httpResponse.statusCode) {
                do {
                    let result = try JSONDecoder().decode(Bool.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            } else {
                let message = String(data: data, encoding: .utf8) ?? "Unknown error"
                let backendError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message])
                completion(.failure(backendError))
            }

        }.resume()
    }

    func resetPassword(userId: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        let endPoint = "Account/ForgotPasswordChange"
        guard let url = URL(string: "\(baseUrl)\(endPoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "userId": userId,
            "newPassword": password
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
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

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }

            if (200..<300).contains(httpResponse.statusCode) {
                do {
                    let result = try JSONDecoder().decode(Bool.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            } else {
                let message = String(data: data, encoding: .utf8) ?? "Unknown error"
                let backendError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message])
                completion(.failure(backendError))
            }

        }.resume()
    }


    
    func getCourses(completion: @escaping (Result<[Course], Error>) -> Void) {
        let endPoint = "Course"
        guard let url = URL(string: "\(baseUrl)\(endPoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        let tokenData = String(data: KeychainHelper.shared.read(service: "access-token", account: "user")!, encoding: .utf8)
        self.token = tokenData
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")

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
        
        let tokenData = String(data: KeychainHelper.shared.read(service: "access-token", account: "user")!, encoding: .utf8)
        self.token = tokenData

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")

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

        let tokenData = String(data: KeychainHelper.shared.read(service: "access-token", account: "user")!, encoding: .utf8)
        self.token = tokenData
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")

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
    
    func fetchStudents(completion: @escaping (Result<[Student], Error>) -> Void) {
        let endPoint = "Student"
        guard let url = URL(string: "\(baseUrl)\(endPoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        let tokenData = String(data: KeychainHelper.shared.read(service: "access-token", account: "user")!, encoding: .utf8)
        self.token = tokenData
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")

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
                let courses = try JSONDecoder().decode([Student].self, from: data)
                completion(.success(courses))
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
        
        let tokenData = String(data: KeychainHelper.shared.read(service: "access-token", account: "user")!, encoding: .utf8)
        self.token = tokenData

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")

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
        
        let tokenData = String(data: KeychainHelper.shared.read(service: "access-token", account: "user")!, encoding: .utf8)
        self.token = tokenData

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")

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
    
    func fetchCourseLessonsForTeacher(for teacherId: String, for courseId: String, completion: @escaping (Result<[CourseClass], Error>) -> Void) {
        let endpoint = "Teacher/GetTeacherClasses/\(teacherId)/\(courseId)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        let tokenData = String(data: KeychainHelper.shared.read(service: "access-token", account: "user")!, encoding: .utf8)
        self.token = tokenData
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")

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
        
        let tokenData = String(data: KeychainHelper.shared.read(service: "access-token", account: "user")!, encoding: .utf8)
        self.token = tokenData
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")

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

        let tokenData = String(data: KeychainHelper.shared.read(service: "access-token", account: "user")!, encoding: .utf8)
        self.token = tokenData
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")

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
    
    func completeLesson(studentId: String, lessonId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endPoint = "Lesson/CompleteLesson/\(studentId)/\(lessonId)"
        guard let url = URL(string: "\(baseUrl)\(endPoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        let tokenData = String(data: KeychainHelper.shared.read(service: "access-token", account: "user")!, encoding: .utf8)
        self.token = tokenData
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")

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

            guard let data = data,
                  let resultString = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
            else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }

            let isCompleted = resultString == "true"
            completion(.success(isCompleted))

        }.resume()
    }
    
    func deleteLesson(lessonId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endPoint = "Lesson/DeleteLesson/\(lessonId)"
        guard let url = URL(string: "\(baseUrl)\(endPoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        let tokenData = String(data: KeychainHelper.shared.read(service: "access-token", account: "user")!, encoding: .utf8)
        self.token = tokenData

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")

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

            guard let data = data,
                  let resultString = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
            else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }

            let isCompleted = resultString == "true"
            completion(.success(isCompleted))

        }.resume()
    }
    
    func uploadFile(fileURL: URL, completion: @escaping (Result<PDFUploadResponse, Error>) -> Void) {
        
        let endPoint = "ClassMedia/upload"
        guard let url = URL(string: "\(baseUrl)\(endPoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let tokenData = String(data: KeychainHelper.shared.read(service: "access-token", account: "user")!, encoding: .utf8)
        self.token = tokenData
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")

        guard let pdfData = try? Data(contentsOf: fileURL) else {
            completion(.failure(NSError(domain: "File read error", code: 0)))
            return
        }
        
        let filename = fileURL.lastPathComponent
        let mimetype = "application/pdf"
        
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"File\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
        body.append(pdfData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
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
                let responseModel = try JSONDecoder().decode(PDFUploadResponse.self, from: data)
                completion(.success(responseModel))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
    
    func uploadBookMetadata(title: String, coverName: String, fileName: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        let endpoint = "Book/CreateBook"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        let tokenData = String(data: KeychainHelper.shared.read(service: "access-token", account: "user")!, encoding: .utf8)
        self.token = tokenData
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "title": title,
            "coverName": coverName,
            "fileName": fileName
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
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
            
            completion(.success(true))
            
        }.resume()
    }

    func getBooks(completion: @escaping (Result<[Books], Error>) -> Void) {
        let endpoint = "Book/GetBooks"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        let tokenData = String(data: KeychainHelper.shared.read(service: "access-token", account: "user")!, encoding: .utf8)
        self.token = tokenData
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }

            do {
                let books = try JSONDecoder().decode([Books].self, from: data)
                completion(.success(books))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }


    func postAddLesson<T: Codable>(body: T, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endPoint = "Lesson/AddLesson"
        guard let url = URL(string: "\(baseUrl)\(endPoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        let tokenData = String(data: KeychainHelper.shared.read(service: "access-token", account: "user")!, encoding: .utf8)
        self.token = tokenData
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")

        do {
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }.resume()
    }

    func addLessonQuestions(lessonId: String, questions: [LessonQuestionRequest], completion: @escaping (Result<Bool, Error>) -> Void) {
        let endpoint = "Lesson/AddLessonQuestion/\(lessonId)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        let tokenData = String(data: KeychainHelper.shared.read(service: "access-token", account: "user")!, encoding: .utf8)
        self.token = tokenData
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        
        do {
            let data = try JSONEncoder().encode(questions)
            request.httpBody = data
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Invalid response", code: 0)))
                return
            }
            
            completion(.success(true))
        }
        
        task.resume()
        
    }
    
    func editLessonQuestion(question: LessonQuestionRequest, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endpoint = "Lesson/UpdateLessonQuestion"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        let tokenData = String(data: KeychainHelper.shared.read(service: "access-token", account: "user")!, encoding: .utf8)
        self.token = tokenData
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")

        do {
            let data = try JSONEncoder().encode(question)
            request.httpBody = data
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Invalid response", code: 0)))
                return
            }

            completion(.success(true))
        }

        task.resume()
    }
    
    func deleteLessonQuestion(with id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endpoint = "Lesson/DeleteLessonQuestion/\(id)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        let tokenData = String(data: KeychainHelper.shared.read(service: "access-token", account: "user")!, encoding: .utf8)
        self.token = tokenData
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")

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
                let result = try JSONDecoder().decode(Bool.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }



}




