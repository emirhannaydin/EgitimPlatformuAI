//
//  MainLoginScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 22.04.2025.
//

import Foundation

class MainLoginScreenViewModel {

    var coordinator: MainLoginScreenCoordinator?
    var mail: String = ""
    var user: User?

    init(coordinator: MainLoginScreenCoordinator?) {
        self.coordinator = coordinator
    }

    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.loginUser(email: email, password: password) { result in
            switch result {
            case .success(let loginResponse):
                if let tokenData = loginResponse.token.data(using: .utf8) {
                    KeychainHelper.shared.save(tokenData, service: "access-token", account: "user")
                }
                self.user = loginResponse.user
                self.mail = email
                UserDefaults.standard.set(loginResponse.user.id, forKey: "userID")
                UserDefaults.standard.set(loginResponse.user.name, forKey: "username")
                completion(.success(()))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    

}

