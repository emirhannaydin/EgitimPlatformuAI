//
//  ForgotPasswordViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.06.2025.
//

import Foundation

class ForgotPasswordViewModel {
    var coordinator: ForgotPasswordCoordinator?
    
    init(coordinator: ForgotPasswordCoordinator?) {
        self.coordinator = coordinator
    }
    
    func requestUserId(email: String, completion: @escaping (Result<String, Error>) -> Void) {
        NetworkManager.shared.forgotPasswordRequest(email: email) { result in
            completion(result)
        }
    }
    

}
