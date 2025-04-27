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

    func registerUser(request: Register, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:5001/api/Account/signup") else {
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
        guard let url = URL(string: "http://localhost:5001/api/Account/login") else {
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


}



