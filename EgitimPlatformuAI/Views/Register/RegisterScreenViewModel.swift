//
//  RegisterScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 28.03.2025.
//

import Foundation
class RegisterScreenViewModel {

    var coordinator: RegisterScreenCoordinator?

    init(coordinator: RegisterScreenCoordinator?) {
        self.coordinator = coordinator
    }
    
    func register(user: Register, completion: @escaping (Result<Void, Error>) -> Void) {
           NetworkManager.shared.registerUser(request: user) { result in
               switch result {
               case .success:
                   completion(.success(()))
               case .failure(let error):
                   completion(.failure(error))
               }
           }
       }
}
